// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> init() async {
//     await Firebase.initializeApp();
//     await _firebaseMessaging.requestPermission();
//     _firebaseMessaging.getToken().then((token) {
//       print(token);
//     });
//     _firebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');
//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//       }
//     });
//     _firebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//     });
//   }

//   Future<void> sendNotification(String title, String body, String topic) async {
//     await _firestore.collection('notifications').add({
//       'title': title,
//       'body': body,
//       'topic': topic,
//     });
//   }

//   //when a user like a post, send a notification to the post owner
//   Future<void> sendLikeNotification(
//       String title, String body, String topic, String postOwner) async {
//     await _firestore.collection('notifications').add({
//       'title': title,
//       'body': body,
//       'topic': topic,
//       'postOwner': postOwner,
//     });
//   }

//   //when a user comment on a post, send a notification to the post owner
//   Future<void> sendCommentNotification(
//       String title, String body, String topic, String postOwner) async {
//     await _firestore.collection('notifications').add({
//       'title': title,
//       'body': body,
//       'topic': topic,
//       'postOwner': postOwner,
//     });
//   }

//   //when a user follow another user, send a notification to the user being followed
//   Future<void> sendFollowNotification(
//       String title, String body, String topic, String postOwner) async {
//     await _firestore.collection('notifications').add({
//       'title': title,
//       'body': body,
//       'topic': topic,
//       'postOwner': postOwner,
//     });
//   }
// }
