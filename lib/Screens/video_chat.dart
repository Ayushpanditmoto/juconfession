import 'dart:math';

import 'package:flutter/material.dart';
import 'package:peerdart/peerdart.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoChat extends StatefulWidget with WidgetsBindingObserver {
  const VideoChat({super.key});

  @override
  State<VideoChat> createState() => _VideoChatState();
}

class _VideoChatState extends State<VideoChat> {
  double left = 100;
  double top = 100;
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  bool isPermissionGranted = false;

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

  @override
  void initState() {
    super.initState();
    requestMultiplePermissions();
    initRenderers();
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    closeCameraStream();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Video Chat'),
      ),
      body: isPermissionGranted
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                videoRenderers(),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    //this feature is not yet implemented
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Feature not yet implemented'),
                        content: const Text(
                            'This feature is not yet implemented. Please try again later'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: const Text('Search for a random user'),
                ),
              ],
            )
          : requestPermission(),
    );
  }

  SizedBox videoRenderers() => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Stack(
          children: [
            Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                key: const Key('local'),
                margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: RTCVideoView(remoteRenderer, mirror: true)),
            Positioned(
              top: top,
              left: left,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    top = max(
                      0,
                      min(top + details.delta.dy,
                          MediaQuery.of(context).size.height * 0.5 - 2),
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
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 46, 46, 46),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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

// SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(20.0),
//                 child: Image.asset('assets/girl.jpg'),
//               ),
//               const SizedBox(height: 10),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(20.0),
//                 child: Image.asset('assets/boy.jpg'),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Text('Status:',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       )),
//                   Text('Connected',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       )),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: const Text('Development in progress'),
//                           content: const Text(
//                               'This feature is still under development. Please check back later.'),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text('Cancel'),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text('Yes'),
//                             ),
//                           ],
//                         );
//                       });
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.amber,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//                 child: const Text('Search for a match'),
//               ),
//             ],
//           ),
//         ),
//       ),
