class Validations {
  static String? validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    final RegExp nameExp = new RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!nameExp.hasMatch(value)) return 'Invalid email address';
    return null;
  }

  static String? valdiatePassword(String value) {
    if (value.trim().isEmpty) return "Enter password";
    if (value.trim().length < 8) {
      return "Password should be greater then 8 character.";
    }
    return null;
  }

  static String? validateFullName(String value) {
    if (value.isEmpty) return 'Name is required.';
    return null;
  }

  static String? validateOTP(String value) {
    if (value.isEmpty) return 'OTP is required.';
    if (value.length != 6) return 'OTP has to be 6 digits';
    return null;
  }
}
