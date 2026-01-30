import 'package:chat_app_using_firebase/Services/db_services.dart';
import 'package:chat_app_using_firebase/models/chat_participants_model.dart';
import 'package:chat_app_using_firebase/pages/chat_page.dart';
import 'package:chat_app_using_firebase/pages/login_page.dart';
import 'package:chat_app_using_firebase/utils/app_prefs.dart';
import 'package:flutter/material.dart';

class AllChatsPage extends StatelessWidget {
  const AllChatsPage({super.key, required this.username});
  final String? username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Cahts'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            username ?? 'Hello',
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AppPrefs.logOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: DBService.getAllUsersData(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<ChatParticipantsModel>> snapList,
        ) {
          // Loading
          if (snapList.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapList.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          // empty
          final participants = snapList.data;
          if (participants == null || participants.isEmpty) {
            return const Center(child: Text('No users found'));
          }
          print('USER DATA -> All Chats: ${snapList.data}');

          return ListView.builder(
            itemCount: participants.length,
            itemBuilder: (context, index) {
              var participant = snapList.data![index];
              return _buildListTile(
                context,
                particapants: participant,
                title: participant.username ?? '',
                subtitle: participant.phoneNumber ?? '',
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required ChatParticipantsModel particapants,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(particapants: particapants),
            ),
          );
        },
      ),
    );
  }
}
