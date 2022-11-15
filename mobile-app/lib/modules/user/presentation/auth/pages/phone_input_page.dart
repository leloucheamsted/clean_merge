import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/common/constants/constants.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/widget/buttons/send_button.dart';
import 'package:tello_social_app/modules/common/widget/buttons/simple_button.dart';
import 'package:tello_social_app/modules/common/widget/tello_social_widget.dart';
import 'package:tello_social_app/modules/core/presentation/streambuilder_all.dart';
import 'package:tello_social_app/modules/user/presentation/auth/bloc/auth_bloc.dart';
import 'package:tello_social_app/modules/user/presentation/auth/pages/ui/country_pick_widget.dart';

class PhoneInputPage extends StatefulWidget {
  const PhoneInputPage({Key? key}) : super(key: key);

  @override
  PhoneInputPageState createState() => PhoneInputPageState();
}

class PhoneInputPageState extends State<PhoneInputPage> {
  final AuthBloc bloc = Modular.get();

  final TextEditingController _phoneTxtCtrl = TextEditingController();

  @override
  void initState() {
    final String? lastUsedPhoneNumber = bloc.lastUsedPhoneNumber;
    if (lastUsedPhoneNumber != null) {
      _phoneTxtCtrl.text = lastUsedPhoneNumber;
    }

    super.initState();
  }

  @override
  void dispose() {
    _phoneTxtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Phone Number Input'),
        elevation: 0,
        backgroundColor: ColorPalette.telloBgColor,
      ),

      body: SafeArea(top: false, child: _buildBody()),
      // body: Center(child: _buildBodyWithBusy()),
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
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _buildBody2() {
    return StreamBuilder_all<String>(
      stream: bloc.dialCode,
      onSuccess: (_, data) {
        if (data == null) {
          return const CircularProgressIndicator();
        }
        return _buildBody3();
      },
    );
  }

  Widget _buildBody3() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .7,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Constants.border,
              borderRadius: BorderRadius.circular(LayoutConstants.radiusM),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPhoneCodePart(),
                const SizedBox(height: 40, child: VerticalDivider()),
                Expanded(child: _buildPhoneInputField()),
              ],
            ),
          ),
          const SizedBox(height: LayoutConstants.marginL),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildPhoneCodePart() {
    return StreamBuilder_all<String>(
      stream: bloc.dialCode,
      onSuccess: (_, data) {
        if (data == null) {
          return const CircularProgressIndicator();
        }
        return CountryPickWidget(
          dialCode: data,
          onChangeDialCode: bloc.changeDialCode,
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return StreamBuilder<bool>(
        stream: bloc.canSubmitPhone,
        builder: (context, snapshot) {
          final bool canSubmit = snapshot.data ?? false;
          return StreamBuilder<bool>(
              stream: bloc.isPhoneNumberAlreadyValidated,
              builder: (context, snapshot) {
                final bool isPhoneNumberAlreadyValidated = snapshot.data ?? false;

                return !isPhoneNumberAlreadyValidated
                    ? SendButton(
                        onTap: bloc.signInWithPhoneNumber,
                        isEnabled: canSubmit,
                      )
                    : SimpleButton(onTap: bloc.signInWithPhoneNumber, content: "NEXT");
              });
        });
  }

  Widget _buildPhoneInputField() {
    return TextField(
      autofocus: true,
      controller: _phoneTxtCtrl,
      onChanged: bloc.changePhone,
      // onChanged: (String value)=> bloc.changePhone( value),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.left,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
    );
  }
}
