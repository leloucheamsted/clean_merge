import 'dart:developer';

import 'package:asuka/asuka.dart' as asuka;

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tello_social_app/modules/core/presentation/action_state.dart';
import 'package:tello_social_app/modules/core/presentation/blocs/base_bloc.dart';
import 'package:tello_social_app/modules/core/presentation/either_stream_binder.dart';
import 'package:tello_social_app/modules/core/services/dialog_service.dart';
import 'package:tello_social_app/modules/core/services/interfaces/ihttpclient_service.dart';
import 'package:tello_social_app/modules/user/domain/entities/otp_token.dart';
import 'package:tello_social_app/modules/user/domain/usecases/get_sim_code.usecase.dart';
import 'package:tello_social_app/modules/user/domain/usecases/otp.usecase.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_save_phone_number.usecase.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_save_token.usecase.dart';
import 'package:tello_social_app/modules/user/domain/usecases/signin.usecase.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import '../../../../core/blocs/app_state_bloc.dart';
import 'auth_validator.dart';

enum AuthSteps { phone, otp, completed }

class AuthBloc extends BaseBloc with AuthValidator {
  late final AppStateBloc appStateBloc = Modular.get();
  final _stepsCtrl = BehaviorSubject<AuthSteps>.seeded(AuthSteps.phone);

  final _countryCtrl = BehaviorSubject<Country>();

  final _dialCodeCtrl = BehaviorSubject<String>();
  final _phoneCtrl = BehaviorSubject<String>();

  final BehaviorSubject<String> _otpCodeCtrl = BehaviorSubject<String>();

  final _busyCtrl = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get busyStream => _busyCtrl.stream;

  // final _simCodeBind = EitherStreamBinder();

  // final _phoneNumberVerifyBind = EitherStreamBinder();
  // Stream<ActionState> get phoneNumberVerifyStream => _phoneNumberVerifyBind.outStream;

  final _otpVerifyBind = EitherStreamBinder<String?>();

  Stream<ActionState> get otpVerifyStream => _otpVerifyBind.outStream;

  Stream<String> get phoneNumber => _phoneCtrl.stream.transform(validatePhoneNumber);
  // Stream<String?> get dialCode => _dialCodeCtrl.stream.transform(validateCountryCode);
  Stream<String> get dialCode => _dialCodeCtrl.stream;

  Stream<Country> get countryStream => _countryCtrl.stream;

  Stream<String> get otpStream => _otpCodeCtrl.stream.transform(validateOtpCode);
  // Stream<bool> get canSubmit => Rx.combineLatest2(phoneNumber, dialCode, (e, p) => true);
  Stream<bool> get canSubmitPhone => Rx.combineLatest3<String, String?, AuthSteps, bool>(
        phoneNumber,
        dialCode,
        _stepsCtrl.stream,
        (a, b, c) {
          return c == AuthSteps.phone;
        },
      );

  Stream<bool> get canSubmitOtp => Rx.combineLatest2<String, AuthSteps, bool>(
        otpStream,
        _stepsCtrl.stream,
        (a, b) => b == AuthSteps.otp,
      );
  // final _formValidCtrl = BehaviorSubject<bool>();
  // Stream<bool> get formIsValid => _formValidCtrl.stream;

  Function(String) get changePhone => _phoneCtrl.sink.add;
  Function(String) get changeDialCode => _dialCodeCtrl.sink.add;

  Function(Country) get changeCountry => _countryCtrl.sink.add;

  Function(String) get changeOtpCode => _otpCodeCtrl.sink.add;

  OtpToken? _otpToken;

  String _lastUsedPhoneNumber = "";
  String _lastUsedDialCode = "";
  bool _otpHasBeenSent = false;
  String? _phoneNumberError;

  String get lastUsedPhoneNumber => _lastUsedPhoneNumber;
  // String? get lastUsedPhoneNumber => _lastUsedPhoneNumberCtrl.value;

  final GetSimCodeUseCase getSimCodeUseCase;

  final _lastValidatedPhoneNumberCtrl = BehaviorSubject<String?>.seeded(null);
  final _lastValidatedDialCodeCtrl = BehaviorSubject<String?>.seeded(null);

  //action button on phone input pages will render next or send button
  final _isPhoneNumberAlreadValidated = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isPhoneNumberAlreadyValidated => _isPhoneNumberAlreadValidated.stream;

  final String otpTokenKeyName = "Otp-Token";
  late final IHttpClientService _httpClientService = Modular.get();
  /*Stream<bool> get isPhoneNumberUpdated =>
      Rx.combineLatest2<String, String, bool>(phoneNumber, dialCode, (phoneValue, dialCodeValue) {
        final bool st = phoneValue != _lastUsedPhoneNumber || dialCodeValue != _lastUsedDialCode;
        log("vaildateIfPhoneNumberIsChanged $st");
        return st;
      }).distinct();*/

  AuthBloc(this.getSimCodeUseCase) {
    Rx.combineLatest4<String, String, String?, String?, bool>(
        phoneNumber, dialCode, _lastValidatedPhoneNumberCtrl.stream, _lastValidatedDialCodeCtrl.stream,
        (phoneValue, dialCodeValue, lastUsedPhoneNumberValue, lastUsedDialCodeValue) {
      if (lastUsedDialCodeValue == null || lastUsedPhoneNumberValue == null) {
        return false;
      }
      // final bool st = phoneValue != _lastUsedPhoneNumber || dialCodeValue != _lastUsedDialCode;
      final bool st = phoneValue == lastUsedPhoneNumberValue && dialCodeValue == lastUsedDialCodeValue;

      return st;
    }).distinct().listen((st) {
      log("isPhoneNumberAlreadyValidated $st");
      _isPhoneNumberAlreadValidated.sink.add(st);
    });

    _setBusy(true);
    final _simCodeBind = EitherStreamBinder<String?>();
    _simCodeBind.callUseCase(() => getSimCodeUseCase.call(null),
        onCompleted: (_) => _setBusy(false),
        onSuccess: (String? simCountryCode) {
          simCountryCode ??= "IL";

          try {
            final Country c = CountryPickerUtils.getCountryByIsoCode(simCountryCode);
            // _countryCtrl.sink.add(c);
            final String phoneCode = c.phoneCode;
            _dialCodeCtrl.sink.add((!phoneCode.startsWith("+") ? "+" : "") + phoneCode);
            _simCodeBind.dispose();
            _setBusy(false);
          } catch (e) {
            _setBusy(false);
          }
        });

    /*Stream.fromFuture(FlutterSimCountryCode.simCountryCode).listen((String? countryCode) {
      if (countryCode != null) {
        Country c = CountryPickerUtils.getCountryByIsoCode(countryCode);
        _countryCtrl.sink.add(c);
        _dialCodeCtrl.sink.add(c.phoneCode);
      }
    });*/
  }

  /*void getCountryCode() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterSimCountryCode.simCountryCode;
      if (mounted) {
        _setCountryFromCode(platformVersion);
      }
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
      //TODO log error
    }
  }*/
  // void signInWithPhoneNumber(String phoneNumberInput) async {

  void _setBusy(bool flag) {
    if (!_busyCtrl.isClosed) {
      _busyCtrl.add(flag);
    }
  }

  void signInWithPhoneNumber() async {
    //validate phone number
    final String phoneNumberInput = _phoneCtrl.value;
    final String dialCode = _dialCodeCtrl.value;

    if (phoneNumberInput == _lastUsedPhoneNumber && dialCode == _lastUsedDialCode) {
      // if (_isPhoneNumberAlreadValidated.value) {
      //nothing changed route directly to otp code part
      if (_phoneNumberError != null) {
        _showAlert(_phoneNumberError!);
        return;
      }
      if (_otpHasBeenSent) {
        _gotoOtpPage();
        return;
      }
    }

    _lastUsedPhoneNumber = phoneNumberInput;
    _lastUsedDialCode = dialCode;
    // _phoneNumberVerifyBind.addLoading();
    _setBusy(true);
    _otpHasBeenSent = false;
    _otpCodeCtrl.sink.add("");

    try {
      final SigninUseCase useCase = Modular.get();

      final response = await useCase.call(
        SigninParams(phoneNumber: phoneNumberInput, phonePrefix: dialCode),
      );
      response.fold((l) {
        _setBusy(false);
        _phoneNumberError = l.toString();
        _showAlert(_phoneNumberError!);
      }, (r) {
        _lastValidatedPhoneNumberCtrl.sink.add(phoneNumberInput);
        _lastValidatedDialCodeCtrl.sink.add(dialCode);

        _isPhoneNumberAlreadValidated.sink.add(true);

        _setBusy(false);
        _phoneNumberError = null;
        _otpHasBeenSent = true;

        _otpToken = r;
        _httpClientService.setHeaders({otpTokenKeyName: _otpToken!.token});
        log("otpToken $r");
        // _showAlert("OtpToken :${r.code}");
        _otpCodeCtrl.sink.add(r.code);
        _gotoOtpPage();
      });
    } catch (e) {
      _setBusy(false);
      _showAlert("$e");
    }
  }

  void _showAlert(String msg) {
    DialogService.simpleAlert(title: "!", body: msg);
  }

  void gotoPhonePage() {
    _stepsCtrl.add(AuthSteps.phone);
    Modular.to.pop(_phoneCtrl.value);
    // Modular.to.pushNamed(AppRoute.auth.path);
  }

  void _gotoOtpPage() {
    _stepsCtrl.add(AuthSteps.otp);
    Modular.to.pushNamed(
      AppRoute.otp.path,
      arguments: {
        "otp": _otpCodeCtrl.hasValue ? _otpCodeCtrl.value : "",
      },
    );
  }

  void sendOtp() {
    final String smsCode = _otpCodeCtrl.value;
    _setBusy(true);

    final OtpUseCase otpUseCase = Modular.get();

    _otpVerifyBind.callUseCase(
      () => otpUseCase.call(
        VerifyParams(smsCode: smsCode, otpToken: _otpToken!),
      ),
      onFailure: (error) {
        _showAlert(error);
      },
      onCompleted: (bool isSuccess) {
        _setBusy(false);
      },
      onSuccess: _onAuthenticationDone,
    );
  }

  void _onAuthenticationDone(String? token) async {
    _httpClientService.renmoveHeader(otpTokenKeyName);
    _stepsCtrl.add(AuthSteps.completed);
    _setBusy(false);
    if (token != null) {
      final SessionSaveTokenUseCase useCase = Modular.get();
      await useCase.call(token);

      final SessionSavePhoneNumberUseCase sessionSavePhoneNumberUseCase = Modular.get();
      await sessionSavePhoneNumberUseCase.call("$_lastUsedDialCode$_lastUsedPhoneNumber");

      //TODO: [TS-348] load user groups then redirect to active group if exists
      DialogService.showToast(msg: "Authentication success!");
      // Modular.to.navigate(AppRoute.home.path);
      await appStateBloc.bootstrap();
    } else {
      _showAlert("AuthFinish with errors (nullToken)");
      //TODO: handle error
    }
  }

  void dispose() {
    // _phoneNumberVerifyBind.dispose();
    _lastValidatedDialCodeCtrl.close();
    _lastValidatedDialCodeCtrl.close();
    _isPhoneNumberAlreadValidated.close();
    _otpVerifyBind.dispose();
    _phoneCtrl.close();
    _dialCodeCtrl.close();
    _countryCtrl.close();
    // _formValidCtrl?.close();
  }
}
