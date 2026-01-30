import 'package:chat_app_using_firebase/Services/auth_services.dart';
import 'package:chat_app_using_firebase/models/chat_messages_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  // Tạo 1 chatID duy nhất cho 2 người, bất kể ai là người gửi hay người nhận
  // User A chat User B
  // User B chat User A
  // ➡️ chatID vẫn giống nhau
  // User nào nhỏ hơn sẽ đứng trước
  static getMessagesHashCodeID({required String userIDReceiver}) {
    String currentUserID = AuthServices.getCurrentUser()!.uid;
    String chatHashID = '';
    // User nào nhỏ hơn sẽ đứng trước
    if (currentUserID.hashCode <= userIDReceiver.hashCode) {
      chatHashID = 'ChatHasID: $currentUserID - $userIDReceiver';
    } else {
      chatHashID = 'ChatHasID: $userIDReceiver - $currentUserID';
    }
    return chatHashID;
  }

  // Gửi tin nhắn cá nhân (Individual Message)
  static sendIndividualMessage({required ChatMessagesModel message}) async {
    String chatId = getMessagesHashCodeID(
      userIDReceiver: message.userIDReceiver!,
    );

    FirebaseFirestore.instance
        .collection('chat_system')
        .doc('individual_messages')
        .collection(chatId)
        .add(message.toIndividualMessagesMap());
  }

  static Stream<List<ChatMessagesModel>> getIndividualMessages({
    required String userIDReceiver,
  }) {
    String chatID = getMessagesHashCodeID(userIDReceiver: userIDReceiver);

    return FirebaseFirestore.instance
        .collection('chat_system')
        .doc('individual_messages')
        .collection(chatID)
        .orderBy('time', descending: true)
        .snapshots()
        .map(
          (querySnapshot) =>
              querySnapshot.docs
                  .map(
                    (doc) => ChatMessagesModel.fromIndividualMessages(
                      message: doc.data(),
                    ),
                  )
                  .toList(),
        );
  }
}
