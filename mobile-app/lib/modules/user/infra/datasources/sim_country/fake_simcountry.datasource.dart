import 'package:tello_social_app/modules/user/infra/datasources/i_sim_country.datasource.dart';

class FakeSimCountryDataSource implements ISimCountryDataSource {
  @override
  Future<String?> getSIMCountryCode() {
    return Future.delayed(const Duration(seconds: 1), () => "IL");
  }
}
