import 'package:chat_app_using_firebase/Services/auth_services.dart';
import 'package:chat_app_using_firebase/models/chat_participants_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  static Future<void> saveUserData({
    required ChatParticipantsModel particapants,
  }) async {
    try {
      final CollectionReference users = FirebaseFirestore.instance.collection(
        'users',
      );
      await users.doc(particapants.userUID).set({
        'username': particapants.username,
        'phone_number': particapants.phoneNumber,
        'user_uid': particapants.userUID,
        'time_stamp': FieldValue.serverTimestamp(),
      });
      print('User data saved successful!');
    } catch (e) {
      print('Fialed to saved user data: $e');
    }
  }

  // Get all users data except current user
  static Stream<List<ChatParticipantsModel>> getAllUsersData() {
    final currentUID = AuthServices.getCurrentUser()!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .where('user_uid', isNotEqualTo: currentUID)
        .snapshots()
        .map(
          (querySnapshot) =>
              querySnapshot.docs
                  .map(
                    (doc) => ChatParticipantsModel.fromMapParticipants(
                      data: doc.data(),
                    ),
                  )
                  .toList(),
        );

    // .map((messages) {
    //   List<ChatParticipantsModel> particapants = [];
    //   for (var message in messages.docs) {
    //     particapants.add(
    //       ChatParticipantsModel.fromMapParticipants(data: message.data()),
    //     );
    //   }
    //   return particapants;
    // });
  }
}
