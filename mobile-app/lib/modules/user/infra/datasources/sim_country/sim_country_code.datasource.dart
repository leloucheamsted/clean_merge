import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:tello_social_app/modules/user/infra/datasources/i_sim_country.datasource.dart';

class SimCountryCodeDataSource implements ISimCountryDataSource {
  @override
  Future<String?> getSIMCountryCode() {
    return FlutterSimCountryCode.simCountryCode;
  }
}
