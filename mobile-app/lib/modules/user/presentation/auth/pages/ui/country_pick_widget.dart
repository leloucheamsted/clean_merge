import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/common/constants/constants.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';

class CountryPickWidget extends StatelessWidget {
  final String dialCode;
  final Function(String) onChangeDialCode;
  const CountryPickWidget({
    Key? key,
    required this.dialCode,
    required this.onChangeDialCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPhoneCodePart2(dialCode);
  }

  Widget _buildPhoneCodePart2(String dialCode) {
    return CountryListPick(
      appBar: AppBar(
        title: const Text('Select your country'),
      ),
      // if you need custom picker use this
      pickerBuilder: (context, CountryCode? countryCode) {
        if (countryCode == null) {
          return Text("countryCode is null");
        }
        return _buildPickerBody(context, countryCode);
      },
      theme: CountryTheme(
        isShowFlag: true,
        isShowTitle: true,
        isShowCode: true,
        isDownIcon: true,
        showEnglishName: true,
        labelColor: ColorPalette.btnDisable,
        searchBackgroundColor: Colors.grey.shade800,
        backgroundColor: ColorPalette.backgroundBodyColor,
      ),
      initialSelection: dialCode,
      // or
      // initialSelection: 'US'
      onChanged: (CountryCode? code) {
        if (code?.dialCode != null) {
          onChangeDialCode(code!.dialCode!);
        }
      },
    );
  }

  Widget _buildPickerBody(BuildContext context, CountryCode countryCode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          countryCode.flagUri!,
          package: 'country_list_pick',
          width: 40,
        ),
        // Text(countryCode.code!),
        const SizedBox(width: LayoutConstants.marginM),
        Text(
          countryCode.dialCode!,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
        ),
        // const SizedBox(width: LayoutConstants.marginM),
      ],
    );
  }
}
