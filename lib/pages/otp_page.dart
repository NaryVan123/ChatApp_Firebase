import 'package:chat_app_using_firebase/Services/auth_services.dart';
import 'package:chat_app_using_firebase/components/text_button.dart';
import 'package:chat_app_using_firebase/models/chat_participants_model.dart';
import 'package:chat_app_using_firebase/utils/textfield_validation.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    super.key,
    required this.verificationId,
    required this.particapants,
  });
  final String verificationId;
  final ChatParticipantsModel particapants;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController codeController = TextEditingController();

  final globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: globalKey,
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.scale,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      inactiveColor: Colors.amber,
                      activeColor: Colors.blue,
                    ),
                    textStyle: TextStyle(color: Colors.red),
                    animationDuration: Duration(milliseconds: 300),
                    validator: otpValidation,
                    controller: codeController,
                    onChanged: (value) {},
                  ),

                  TextButtonWidget(
                    nameButton: 'Verify Otp',
                    onPressed: () {
                      if (globalKey.currentState!.validate()) {
                        AuthServices.signInWithOtp(
                          context: context,
                          otpCode: codeController.text,
                          verificationId: widget.verificationId,
                          particapants: widget.particapants,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
