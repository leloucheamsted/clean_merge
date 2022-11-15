/*import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tello_social_app/modules/user/domain/errors/auth_failure.dart';
import 'package:tello_social_app/modules/user/domain/entities/auth_user.dart';
import 'package:tello_social_app/modules/user/domain/repositories/iauth_phone_repo.dart';

class FirebasePhoneAuthSvc implements IAuthPhoneRepo {
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<AuthUser?> get onAuthChanged => _auth.authStateChanges().map(
        (User? user) {
          if (user == null) {
            // The user is signed out
            return null;
          } else {
            // The user is logged in
            return AuthUser(id: user.uid, phoneNumber: user.phoneNumber!);
          }
        },
      );

  @override
  Stream<Either<AuthFailure, String>> signInWithPhoneNumber({
    required String phoneNumber,
    required Duration timeout,
  }) async* {
    // throw UnimplementedError();
    final StreamController<Either<AuthFailure, String>> streamController =
        StreamController<Either<AuthFailure, String>>();

    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeout,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY auto verification
        signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        late final Either<AuthFailure, String> result;

        switch (e.code) {
          case "invalid-phone-number":
            result = left(AuthFailure.invalidPhoneNumber());
            break;
          default:
            result = left(AuthFailure.serverError());
        }
        streamController.add(result);
      },
      codeSent: (String verificationId, int? resendToken) async {
        // dispatch event on view open code enter input
        streamController.add(right(verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        streamController.add(left(AuthFailure.smsAutoRetrivalTimeout()));
      },
    );

    yield* streamController.stream;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<Either<AuthFailure, Unit>> verifySmsCode({
    required String smsCode,
    required String verificationId,
  }) async {
    try {
      final PhoneAuthCredential phoneAuthCredential =
          PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

      signInWithCredential(phoneAuthCredential);
      return right(unit);
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case "session-expired":
          return left(AuthFailure.sessionExpired());

        case "invalid-verification-code":
        case "ınvalıd-verıfıcatıon-code":
          return left(AuthFailure.smsCodeInvalid());
        default:
          return left(AuthFailure.serverError());
      }
    } catch (ex) {
      return left(AuthFailure.unhandledException(ex.toString()));
    }
  }

  void signInWithCredential(PhoneAuthCredential credential) {
    _auth.signInWithCredential(credential);
  }
}
*/