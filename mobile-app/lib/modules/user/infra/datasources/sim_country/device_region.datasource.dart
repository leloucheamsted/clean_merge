import 'package:device_region/device_region.dart';
import 'package:tello_social_app/modules/user/infra/datasources/i_sim_country.datasource.dart';

class DeviceRegionDataSource implements ISimCountryDataSource {
  @override
  Future<String?> getSIMCountryCode() {
    return DeviceRegion.getSIMCountryCode();
  }
}
