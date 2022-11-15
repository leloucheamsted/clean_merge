import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/common/constants/constants.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/widget/buttons/login_button.dart';
import 'package:tello_social_app/modules/common/widget/tello_social_widget.dart';
import 'package:tello_social_app/modules/core/presentation/streambuilder_all.dart';

import '../bloc/auth_bloc.dart';

class OtpPage extends StatefulWidget {
  static const String routeName = "/otp";

  const OtpPage({
    Key? key,
  }) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with SingleTickerProviderStateMixin {
  // late String phoneNumber = Modular.args.data?["phone"] ?? "";
  // late String phoneNumber = Modular.args.data?["phone"] ?? "";

  final AuthBloc bloc = Modular.get();

  final TextEditingController _otpTxtCtrl = TextEditingController();

  @override
  void initState() {
    _otpTxtCtrl.text = Modular.args.data?["otp"];
    super.initState();
  }

  @override
  void dispose() {
    _otpTxtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      appBar: _buildAppBar(),

      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: ColorPalette.telloBgColor,
      elevation: 0.0,
      leading: GestureDetector(
          // borderRadius: BorderRadius.circular(30.0),
          onTap: bloc.gotoPhonePage,
          child: const Icon(Icons.arrow_back, color: ColorPalette.btnDisable)),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    final double sizeH = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          const TelloSocialWidget(),
          SizedBox(height: sizeH * .05),
          _buildBodyWithBusy(),
        ],
      ),
    );
  }

  Widget _buildBodyWithBusy() {
    return StreamBuilder_all<bool>(
      stream: bloc.busyStream,
      onSuccess: (_, data) {
        if (data == false) {
          return _buildBody2();
        }
        //TODO custom sending validation otp code
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildOtpInputTextField() {
    return Container(
      decoration: BoxDecoration(
        border: Constants.border,
        borderRadius: BorderRadius.circular(LayoutConstants.radiusM),
      ),
      child: TextField(
        autofocus: true,
        controller: _otpTxtCtrl,
        onChanged: bloc.changeOtpCode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 6,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        decoration: const InputDecoration(counterText: ""),
      ),
    );
  }

  Widget _buildBody2() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildOtpInputTextField(),
            const SizedBox(height: LayoutConstants.spaceL),
            _buildSubmitButton(),
            SizedBox(height: MediaQuery.of(context).padding.top),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return StreamBuilder<bool>(
      stream: bloc.canSubmitOtp,
      builder: (context, snapshot) {
        return LoginButton(onTap: bloc.sendOtp);
      },
    );
  }

  void _onOtpChanged() {
    final String t = _getOtpEnteredValue();
    // print("otpp $t");
    bloc.changeOtpCode(t);
  }

  String _getOtpEnteredValue() {
    return "todo";
  }
}
