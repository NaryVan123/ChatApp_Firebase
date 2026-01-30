class ChatParticipantsModel {
  final String? username;
  final String? phoneNumber;
  String? userUID;

  ChatParticipantsModel({this.username, this.phoneNumber, this.userUID});

  factory ChatParticipantsModel.fromMapParticipants({
    required Map<String, dynamic> data,
  }) {
    return ChatParticipantsModel(
      username: data['username'] ?? '',
      phoneNumber: data['phone_number'] ?? '',
      userUID: data['user_uid'] ?? '',
    );
  }
}
