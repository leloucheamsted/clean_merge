import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/widgets.dart';
import 'package:tello_social_app/modules/core/presentation/streambuilder_all.dart';

import '../../bloc/auth_bloc.dart';

class OtpPageNoKeyboard extends StatefulWidget {
  static const String routeName = "/otp_nokeyboard";

  const OtpPageNoKeyboard({
    Key? key,
  }) : super(key: key);

  @override
  _OtpPageNoKeyboardState createState() => _OtpPageNoKeyboardState();
}

class _OtpPageNoKeyboardState extends State<OtpPageNoKeyboard> with SingleTickerProviderStateMixin {
  late String phoneNumber = Modular.args.data?["phone"] ?? "";

  final AuthBloc bloc = Modular.get();

  final int time = 30;
  late AnimationController _controller;

  final int totalFields = 6;

  late final List<int?> _digitValues = List.generate(totalFields, (index) => null);

  // Variables
  Size? _screenSize;
  int? _currentDigit;

  Timer? timer;
  int? totalTimeInSeconds;
  bool _hideResendButton = false;

  String userName = "";
  bool didReadNotifications = false;
  int unReadNotificationsCount = 0;

  // Returns "Appbar"
  get _getAppbar {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        child: Icon(
          Icons.arrow_back,
          color: Colors.black54,
        ),
        onTap: () {
          // Navigator.pop(context);
          // Modular.to.pop();
          bloc.gotoPhonePage();
        },
      ),
      centerTitle: true,
    );
  }

  // Return "Verification Code" label
  get _getVerificationCodeLabel {
    return const Text(
      "Verification Code",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 28.0, color: Colors.black, fontWeight: FontWeight.bold),
    );
  }

  // Return "Email" label
  get _getEmailLabel {
    return Text(
      "We have sent you and SMS with a code\nto the number $phoneNumber\n\nTo complete your phone number verification process,please enter the 6-digit activation code.",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),
    );
  }

  // Return "OTP" input field
  Widget _buildInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(totalFields, (index) => createOtpField(_digitValues[index]))..insert(3, const SizedBox()),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _getVerificationCodeLabel,
        _getEmailLabel,
        _buildInputFields(),
        // _hideResendButton ? _getTimerText : _getResendButton,

        _buildSubmitButton(),
        _getOtpKeyboard,
        SizedBox(height: MediaQuery.of(context).padding.bottom)
      ],
    );
  }

  Widget _buildSubmitButton() {
    return StreamBuilder<bool>(
      stream: bloc.canSubmitOtp,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: LayoutConstants.paddingL),
          child: SimpleButton(
            content: "Next",
            isEnabled: snapshot.data ?? false,
            onTap: bloc.sendOtp,
          ),
        );
      },
    );
  }

  // Returns "Timer" label
  get _getTimerText {
    return Container(
      height: 32,
      child: Offstage(
        offstage: !_hideResendButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.access_time),
            const SizedBox(width: 5.0),
            OtpTimer(_controller, 15.0, Colors.black)
          ],
        ),
      ),
    );
  }

  // Returns "Resend" button
  get _getResendButton {
    return InkWell(
      child: Container(
        height: 32,
        width: 120,
        decoration:
            BoxDecoration(color: Colors.black, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(32)),
        alignment: Alignment.center,
        child: Text(
          "Resend OTP",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      onTap: () {
        // Resend you OTP via API or anything
      },
    );
  }

  // Returns "Otp" keyboard
  get _getOtpKeyboard {
    return SizedBox(
        height: _screenSize!.width - 80,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "1",
                      onPressed: () {
                        _setCurrentDigit(1);
                      }),
                  _otpKeyboardInputButton(
                      label: "2",
                      onPressed: () {
                        _setCurrentDigit(2);
                      }),
                  _otpKeyboardInputButton(
                      label: "3",
                      onPressed: () {
                        _setCurrentDigit(3);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "4",
                      onPressed: () {
                        _setCurrentDigit(4);
                      }),
                  _otpKeyboardInputButton(
                      label: "5",
                      onPressed: () {
                        _setCurrentDigit(5);
                      }),
                  _otpKeyboardInputButton(
                      label: "6",
                      onPressed: () {
                        _setCurrentDigit(6);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "7",
                      onPressed: () {
                        _setCurrentDigit(7);
                      }),
                  _otpKeyboardInputButton(
                      label: "8",
                      onPressed: () {
                        _setCurrentDigit(8);
                      }),
                  _otpKeyboardInputButton(
                      label: "9",
                      onPressed: () {
                        _setCurrentDigit(9);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 80.0,
                  ),
                  _otpKeyboardInputButton(
                      label: "0",
                      onPressed: () {
                        _setCurrentDigit(0);
                      }),
                  _otpKeyboardActionButton(
                      label: Icon(
                        Icons.backspace,
                        color: Colors.black,
                      ),
                      onPressed: _onClearBtn),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: time))
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            _hideResendButton = !_hideResendButton;
          });
        }
      });
    _controller.reverse(from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _getAppbar,
      // extendBody: true,
      backgroundColor: Colors.white,
      body: _buildBodyWithBusy(),
    );
  }

  Widget _buildBodyWithBusy() {
    return StreamBuilder_all<bool>(
      stream: bloc.busyStream,
      onSuccess: (_, data) {
        if (data == false) {
          return _buildBody();
        }

        //TODO custom sending validation otp code
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // Returns "Otp custom text field"
  Widget createOtpField(int? digit) {
    return Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 2.0,
        color: Colors.black,
      ))),
      child: Text(
        digit != null ? digit.toString() : "",
        style: const TextStyle(
          fontSize: 30.0,
          color: Colors.black,
        ),
      ),
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({required String label, required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(40.0),
        child: Container(
          height: 80.0,
          width: 80.0,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({required Widget label, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40.0),
      child: Container(
        height: 80.0,
        width: 80.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: label,
        ),
      ),
    );
  }

  void _setCurrentDigit(int i) {
    int index = _digitValues.indexWhere((element) => element == null);

    if (index != -1) {
      _currentDigit = i;
      _digitValues[index] = _currentDigit;

      _onOtpChanged();
      setState(() {});
    }
  }

  void _onClearBtn() {
    final index = _digitValues.reversed.toList().indexWhere((element) => element != null);
    if (index != -1) {
      _digitValues[_digitValues.length - index - 1] = null;
      _onOtpChanged();
      setState(() {});
    }
  }

  void _onOtpChanged() {
    final String t = _getOtpEnteredValue();
    // print("otpp $t");
    bloc.changeOtpCode(t);
  }

  String _getOtpEnteredValue() {
    return _digitValues.join("").replaceAll("null", "");
  }

  Future _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  void clearOtp() {
    _digitValues.forEach((element) {
      element = null;
    });
    _onOtpChanged();
    setState(() {});
  }
}

class OtpTimer extends StatelessWidget {
  final AnimationController controller;
  double fontSize;
  Color timeColor = Colors.black;

  OtpTimer(this.controller, this.fontSize, this.timeColor);

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration? get duration => controller.duration;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return Text(
            timerString,
            style: TextStyle(fontSize: fontSize, color: timeColor, fontWeight: FontWeight.w600),
          );
        });
  }
}
