import 'dart:async';

class AuthValidator {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('Enter a valid email');
    }
  });

  final validatePhoneNumber = StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    if (phone.length > 4) {
      sink.add(phone);
    } else {
      sink.addError('Phone number must be at least 5 digits');
    }
  });

  final validateCountryCode = StreamTransformer<String, String>.fromHandlers(handleData: (cCode, sink) {
    if (cCode.length > 1) {
      sink.add(cCode);
    } else {
      sink.addError('Invalid country code');
    }
  });

  final validateOtpCode = StreamTransformer<String, String>.fromHandlers(handleData: (cCode, sink) {
    if (cCode.length == 6) {
      sink.add(cCode);
    } else {
      sink.addError('Invalid otp code');
    }
  });
}
