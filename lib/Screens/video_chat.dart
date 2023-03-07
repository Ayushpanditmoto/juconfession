import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peerdart/peerdart.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class VideoChat extends StatefulWidget {
  const VideoChat({super.key});

  @override
  State<VideoChat> createState() => _VideoChatState();
}

class _VideoChatState extends State<VideoChat> {
  double left = 100;
  double top = 100;
  final Peer peer = Peer();
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  final TextEditingController _controller = TextEditingController();
  late String? peerId;
  bool isPermissionGranted = false;
  bool inCall = false;
  StreamSubscription? _streamSubscription;

  void requestMultiplePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.microphone] == PermissionStatus.granted) {
      setState(() {
        isPermissionGranted = true;
      });

      _getUsersMedia(true, true);

      debugPrint('Permission granted');
    } else {
      debugPrint('Permission denied');
      setState(() {
        isPermissionGranted = false;
      });

      // requestMultiplePermissions();
    }
  }

  //generate peer id function
  String? generatePeerId() {
    peer.on('open').listen((id) {
      setState(() {
        peerId = id;
      });
    });
    return peer.id;
  }

  @override
  void initState() {
    super.initState();
    requestMultiplePermissions();
    initRenderers();
    peerId = generatePeerId();
    debugPrint("ayush: peerId generated");
    debugPrint("ayush: $peerId");
    peer.on<MediaConnection>("call").listen((call) async {
      final mediaStream = await navigator.mediaDevices
          .getUserMedia({"video": true, "audio": true});

      call.answer(mediaStream);

      call.on("close").listen((event) {
        setState(() {
          inCall = false;
          remoteRenderer.srcObject = null;
        });
      });

      call.on<MediaStream>("stream").listen((event) {
        localRenderer.srcObject = mediaStream;
        remoteRenderer.srcObject = event;

        setState(() {
          inCall = true;
        });
      });
    });
  }

  //getuser media function
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    closeCameraStream();
    peer.dispose();
    _controller.dispose();
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }

  void connect(String incoming) async {
    final mediaStream = await navigator.mediaDevices
        .getUserMedia({"video": true, "audio": true});

    // final conn = peer.call(_controller.text, mediaStream);
    final conn = peer.call(incoming, mediaStream);

    conn.on("close").listen((event) {
      setState(() {
        inCall = false;
      });
    });

    conn.on<MediaStream>("stream").listen((event) {
      remoteRenderer.srcObject = event;
      localRenderer.srcObject = mediaStream;

      setState(() {
        inCall = true;
      });
    });
  }

  Future<void> initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  _getUsersMedia(bool x, bool y) async {
    final Map<String, dynamic> mediaConstraints = {'audio': x, 'video': y};
    try {
      final MediaStream stream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);

      localRenderer.srcObject = stream;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  closeCameraStream() async {
    try {
      final MediaStream? stream = localRenderer.srcObject;
      stream!.getTracks().forEach((track) => track.stop());
      localRenderer.srcObject = null;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void createRoom() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final DatabaseReference database =
        FirebaseDatabase.instance.ref().child("rooms");
    _streamSubscription = database
        .child(auth.currentUser!.uid)
        .orderByChild("status")
        .equalTo(0)
        .limitToFirst(1)
        .onValue
        .listen((event) {
      debugPrint("ayush 69 ${event.snapshot.key}");

      if (event.snapshot.children.isNotEmpty) {
        //room available

        final peerId = event.snapshot.children.first.key;
        debugPrint("ayush peerId $peerId");
        database.child(auth.currentUser!.uid).update({
          "incomingCall": peerId,
          "status": 1,
          "isAvailable": false,
        });
        if (inCall) {
          connect(peerId!);
        }
      } else {
        //room not available
        Map room = {
          "createdBy": peerId,
          "incomingCall": peerId,
          "status": 0,
          "isAvailable": true,
        };
        database.child(auth.currentUser!.uid).set(room).whenComplete(() {
          debugPrint("ayush room created");

          database.child(auth.currentUser!.uid).onValue.listen((event) {
            if (event.snapshot.child("status").exists &&
                event.snapshot.child("status").value == 1) {
              debugPrint("ayush: call accepted");
              connect(event.snapshot.child("incomingCall").value as String);
            }
          });
        });
      }

      // print("ayush room key ${event.snapshot.key} $peerId");
      // if (event.snapshot.key == auth.currentUser!.uid) {
      //   print("ayush: room already exists");
      //   database.child(auth.currentUser!.uid).update({
      //     "incomingCall": peerId,
      //     "status": 0,
      //     "isAvailable": false,
      //   });
      // } else {
      //   print("ayush: room does not exists");
      //   database.child(auth.currentUser!.uid).set({
      //     "createdBy": peerId,
      //     "incomingCall": peerId,
      //     "status": 0,
      //     "isAvailable": true,
      //   });
      // }
    });
  }

  @override
  void deactivate() {
    _streamSubscription?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Video Chat'),
      ),
      body: isPermissionGranted
          ? peerId != null
              ? SingleChildScrollView(
                  child: SizedBox(
                    // height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        videoRenderers(
                          theme,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Click below to copy the Peer id',
                        ),
                        peerId == null
                            ? const Text('Loading peer id...')
                            : TextButton(
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: peer.id.toString()));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Peer id copied to clipboard'),
                                    ),
                                  );
                                },
                                child: Text(peerId!),
                              ),
                        inCall
                            ? ElevatedButton(
                                onPressed: () {
                                  peer.disconnect();
                                  setState(() {
                                    remoteRenderer.srcObject = null;
                                    inCall = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.deepPurple,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                child: const Text('Disconnect'),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: TextField(
                                      controller: _controller,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter peer id',
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.deepPurple,
                                            ),
                                          )),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      connect(_controller.text);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.deepPurple,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                    child: const Text('Connect'),
                                  ),
                                ],
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            createRoom();
                            // we are currently working on this feature
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepPurple,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          child: const Text('Search for a random user'),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('Connecting to server...'),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                )
          : requestPermission(),
    );
  }

  SizedBox videoRenderers(ThemeProvider theme) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              key: const Key('local'),
              margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              decoration: BoxDecoration(
                color: theme.themeMode == ThemeMode.dark
                    ? const Color.fromARGB(137, 44, 44, 44)
                    : const Color.fromARGB(255, 172, 172, 172),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: RTCVideoView(
                  remoteRenderer,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            ),
            Positioned(
              top: top,
              left: left,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    top = max(
                      0,
                      min(top + details.delta.dy,
                          MediaQuery.of(context).size.height * 0.3 - 2),
                    );
                    left = max(
                        0,
                        min(left + details.delta.dx,
                            MediaQuery.of(context).size.width * 0.7 - 10));
                  });
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.19,
                    key: const Key('remote'),
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    decoration: BoxDecoration(
                      color: theme.themeMode == ThemeMode.dark
                          ? const Color.fromARGB(137, 44, 44, 44)
                          : const Color.fromARGB(255, 45, 45, 45),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: RTCVideoView(localRenderer,
                          mirror: true,
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
                    )),
              ),
            )
          ],
        ),
      );

  Widget requestPermission() => Center(
        child: ElevatedButton(
          onPressed: () {
            requestMultiplePermissions();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          child: const Text('Request Permission'),
        ),
      );
}
