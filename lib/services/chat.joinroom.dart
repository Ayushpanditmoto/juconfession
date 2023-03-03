import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CreateRoom {
  FirebaseDatabase database = FirebaseDatabase.instance;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref("rooms");

  void createRoom({
    required String peerId,
    required String incomingCall,
  }) {
    print(getRoomKey());
    if (getRoomKey()) {
      //room is available
      _databaseReference.child(FirebaseAuth.instance.currentUser!.uid).set({
        "createdBy": peerId,
        "incomingCall": incomingCall,
        "status": 0,
        "isAvailable": true,
      });
    } else {
      //room is not available
      _databaseReference.child(FirebaseAuth.instance.currentUser!.uid).set({
        "createdBy": peerId,
        "incomingCall": incomingCall,
        "status": 0,
        "isAvailable": false,
      });
    }
  }

  String updateRoomKey(String keey) {
    return keey;
  }

  bool getRoomKey() {
    String? roomKey;

    _databaseReference
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      // roomKey = event.snapshot.key!;
      roomKey = updateRoomKey(event.snapshot.key!);
      // print("ayush : $roomKey");
      // print("ayush : ${FirebaseAuth.instance.currentUser!.uid}");
      // print("ayush : ${roomKey == FirebaseAuth.instance.currentUser!.uid}");
    });

    print("ayush : $roomKey");
    print("ayush : ${FirebaseAuth.instance.currentUser!.uid}");
    print("ayush : ${roomKey == FirebaseAuth.instance.currentUser!.uid}");

    if (roomKey == FirebaseAuth.instance.currentUser!.uid) {
      return true;
    } else {
      return false;
    }
  }

  void deleteRoom() {
    _databaseReference
        .child(
          FirebaseAuth.instance.currentUser!.uid,
        )
        .remove();
  }
}
