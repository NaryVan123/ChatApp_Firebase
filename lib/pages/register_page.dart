import 'package:chat_app_using_firebase/components/text_button.dart';
import 'package:chat_app_using_firebase/components/text_field.dart';
import 'package:chat_app_using_firebase/pages/login_page.dart';
import 'package:chat_app_using_firebase/utils/textfield_validation.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, required this.onTap});
  final VoidCallback? onTap;

  final TextEditingController usernameContronller = TextEditingController();
  final TextEditingController phoneNumberContronller = TextEditingController();
  final TextEditingController passwordContronller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register',
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
              ),
              TextFieldWidget(
                label: 'Password',
                controller: passwordContronller,
                validator: nullValidation,
              ),
              SizedBox(height: 20),
              TextButtonWidget(
                nameButton: 'SIGN UP',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
