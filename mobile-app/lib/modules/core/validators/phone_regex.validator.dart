import 'package:tello_social_app/modules/core/validators/i_simple.validator.dart';

class PhoneRegexpValidator implements ISimpleValidator<String> {
  @override
  Future<String> validate(String input) {
    String phoneNumber = input.trim();
    if (phoneNumber.isEmpty || phoneNumber.length < 5) {
      throw Exception("tooShortOrEmpty");
    }
    String regexPattern = r'^(?:[+0][1-9])?[0-9]{8,12}$';
    final regExp = RegExp(regexPattern);

    final bool b = regExp.hasMatch(phoneNumber);
    if (!b) {
      throw Exception("NotValid");
    }

    return Future.value(phoneNumber);
  }
}
