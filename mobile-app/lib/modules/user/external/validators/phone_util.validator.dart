import 'package:phone_number/phone_number.dart';
import 'package:tello_social_app/modules/core/validators/i_simple.validator.dart';

class PhoneUtilValidator implements ISimpleValidator<String> {
  @override
  Future<String> validate(String phoneNumber) async {
    final parsed = await PhoneNumberUtil().parse(phoneNumber, regionCode: null);
    return parsed.e164;
  }
}
