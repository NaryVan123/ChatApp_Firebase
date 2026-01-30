import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessagesModel {
  String? userIDSender;
  String? userIDReceiver;
  String? message;
  Timestamp? time;

  ChatMessagesModel({
    this.userIDSender,
    this.userIDReceiver,
    this.message,
    this.time,
  });

  factory ChatMessagesModel.fromIndividualMessages({
    required Map<String, dynamic> message,
  }) {
    return ChatMessagesModel(
      userIDSender: message['user_id_sender'] ?? '',
      userIDReceiver: message['user_id_receiver'] ?? '',
      message: message['message'] ?? '',
      time: message['time'] ?? '',
    );
  }

  Map<String, dynamic> toIndividualMessagesMap() {
    return {
      'user_id_sender': userIDSender,
      'user_id_receiver': userIDReceiver,
      'message': message,
      'time': FieldValue.serverTimestamp(),
    };
  }
}
