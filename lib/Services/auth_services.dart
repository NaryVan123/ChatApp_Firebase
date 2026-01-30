import 'package:chat_app_using_firebase/Services/db_services.dart';
import 'package:chat_app_using_firebase/components/loading_progress.dart';
import 'package:chat_app_using_firebase/models/chat_participants_model.dart';
import 'package:chat_app_using_firebase/pages/all_chat_page.dart';
import 'package:chat_app_using_firebase/pages/otp_page.dart';
import 'package:chat_app_using_firebase/utils/app_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {
  // Get current user logined
  static User? getCurrentUser() => FirebaseAuth.instance.currentUser;

  static phoneNumberVerification({
    required BuildContext context,
    required ChatParticipantsModel participants,
  }) async {
    LoadingProgress.onLoading(context);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: participants.phoneNumber, //
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        LoadingProgress.hideDialog(context);
      },
      codeSent: (String verificationId, int? resendToken) {
        LoadingProgress.hideDialog(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return OTPScreen(
                verificationId: verificationId,
                particapants: participants,
              );
            },
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static signInWithOtp({
    required BuildContext context,
    required String otpCode,
    required String verificationId,
    required ChatParticipantsModel particapants,
  }) async {
    try {
      LoadingProgress.onLoading(context);
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      final UserCredential user = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final updatedParticipant = ChatParticipantsModel(
        username: particapants.username,
        phoneNumber: particapants.phoneNumber,
        userUID: user.user!.uid,
      );

      await DBService.saveUserData(particapants: updatedParticipant);

      await AppPrefs.savedData(
        phoneNumber: particapants.phoneNumber.toString(),
        username: particapants.username.toString(),
      );

      if (!context.mounted) return;

      LoadingProgress.hideDialog(context);

      final String? username = await AppPrefs.getUserName();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AllChatsPage(username: username),
        ),
        (route) => false,
      );

      print('User sign in successful!');
    } on FirebaseAuthException catch (e) {
      LoadingProgress.hideDialog(context);
      String errorMessage = 'Error, Please try again!';
      if (e.code == 'invalid-verification-code') {
        errorMessage = 'OTP is not correct. Please try again!';
      } else if (e.code == 'session-expired') {
        errorMessage = "OTP is expired. Please resend OTP.";
      }

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }

      print('Error during user sign in: $e');
    } catch (e) {
      LoadingProgress.hideDialog(context);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Input wrong OTP!")));
      }
      print('Unknown error during user sign in: $e');
    }
  }
}
