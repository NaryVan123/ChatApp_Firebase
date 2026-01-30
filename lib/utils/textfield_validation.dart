String? nullValidation(String? value) {
  if (value!.isEmpty) {
    return 'required';
  } else {
    return null;
  }
}

String? phoneNumberValidateion(String? value) {
  if (value!.isNotEmpty) {
    if (value.length >= 12 && value.length == 13) {
      if (value.startsWith('+855')) {
        return null;
      } else {
        return 'Number must start with +855...';
      }
    } else {
      return 'Invalid phone number';
    }
  } else {
    return 'required';
  }
}

String? otpValidation(String? value) {
  if (value!.isNotEmpty) {
    if (value.length == 6) {
      return null;
    } else {
      return 'Invalid OTP !';
    }
  } else {
    return 'required';
  }
}
