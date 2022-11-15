import 'package:tello_social_app/modules/common/country/country.entity.dart';

abstract class ICountryDataSource {
  Future<List<CountryEntity>> fetchList();
}
