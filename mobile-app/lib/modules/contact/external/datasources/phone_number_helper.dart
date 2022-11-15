class PhoneNumberHelper {
  static final RegExp _trimDigitSpace = RegExp(r'[^0-9]');
  static String fixIt(String phoneNumber) {
    final String res = phoneNumber.replaceAll(_trimDigitSpace, '');
    return "+$res";
  }
}
