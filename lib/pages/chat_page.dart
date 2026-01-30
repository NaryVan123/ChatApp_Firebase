import 'package:chat_app_using_firebase/Services/auth_services.dart';
import 'package:chat_app_using_firebase/Services/chat_services.dart';
import 'package:chat_app_using_firebase/models/chat_messages_model.dart';
import 'package:chat_app_using_firebase/models/chat_participants_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.particapants});

  final ChatParticipantsModel particapants;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _msgContoller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.particapants.username.toString(),
          style: TextStyle(),
        ),
        elevation: 1,
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
              flex: 9,
              child: StreamBuilder(
                stream: ChatServices.getIndividualMessages(
                  userIDReceiver: widget.particapants.userUID.toString(),
                ),
                builder: (
                  context,
                  AsyncSnapshot<List<ChatMessagesModel>> asyncSnapshot,
                ) {
                  if (asyncSnapshot.hasData) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: asyncSnapshot.data!.length,
                      itemBuilder: (context, index) {
                        final msg = asyncSnapshot.data![index];
                        return _singleItemView(msg: msg, Key: UniqueKey());
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Card(
                      color: Colors.blue.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextField(
                        controller: _msgContoller,
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'send message',
                          hintStyle: TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(
                      icon: Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: () async {
                        // if there is something inside the textfield
                        if (_msgContoller.text.isNotEmpty) {
                          var chat = ChatMessagesModel(
                            message: _msgContoller.text,
                            userIDReceiver: widget.particapants.userUID,
                            userIDSender: AuthServices.getCurrentUser()!.uid,
                          );

                          // Send the message
                          ChatServices.sendIndividualMessage(message: chat);
                        }

                        // Clear text field after send message
                        _msgContoller.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _singleItemView({
    required ChatMessagesModel msg,
    required UniqueKey Key,
  }) {
    bool isMe = msg.userIDSender == AuthServices.getCurrentUser()!.uid;

    return Align(
      alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            isMe
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildItemChat(isMe: isMe, msg: msg),
                    SizedBox(width: 5),
                    _buildUserImgPath(),
                  ],
                )
                : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    _buildUserImgPath(),
                    SizedBox(width: 5),
                    _buildItemChat(isMe: isMe, msg: msg),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemChat({required bool isMe, required ChatMessagesModel msg}) {
    String formatTime(Timestamp timestamp) {
      final date = timestamp.toDate();
      return DateFormat('HH:mm').format(date); // 14:35
    }

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.50,
          ),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            msg.message.toString(),
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        Text(
          formatTime(msg.time!),
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildUserImgPath() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: CircleAvatar(radius: 15, child: Icon(Icons.person, size: 15)),
    );
  }
}
