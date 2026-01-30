import 'package:chat_app_using_firebase/Services/auth_services.dart';
import 'package:chat_app_using_firebase/components/text_button.dart';
import 'package:chat_app_using_firebase/components/text_field.dart';
import 'package:chat_app_using_firebase/models/chat_participants_model.dart';
import 'package:chat_app_using_firebase/utils/textfield_validation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key, this.onTap});

  final VoidCallback? onTap;

  final TextEditingController usernameContronller = TextEditingController();

  final TextEditingController phoneNumberContronller = TextEditingController();

  final globalKey = GlobalKey<FormState>();

  // @override
  // void dispose() {
  //   usernameContronller.dispose();
  //   phoneNumberContronller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return _buildloginform(
      onPressed: () {
        if (globalKey.currentState!.validate()) {
          var participants = ChatParticipantsModel(
            username: usernameContronller.text,
            phoneNumber: phoneNumberContronller.text,
            userUID: '',
          );

          AuthServices.phoneNumberVerification(
            context: context,
            participants: participants,
          );
        }
      },
    );
  }

  Widget _buildloginform({required onPressed}) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: globalKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.grey, fontSize: 30),
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: 'Username',
                  controller: usernameContronller,
                  validator: nullValidation,
                ),
                TextFieldWidget(
                  label: 'Phone number',
                  controller: phoneNumberContronller,
                  validator: phoneNumberValidateion,
                  maxLength: 13,
                  keyboardType: TextInputType.phone,
                ),
                TextButtonWidget(nameButton: 'SIGN IN', onPressed: onPressed),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member? ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
