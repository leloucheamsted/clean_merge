import 'package:country_list_pick/support/code_countrys.dart';
import 'package:tello_social_app/modules/common/country/country.entity.dart';
import 'package:tello_social_app/modules/common/country/i_country_data_source.dart';

class CountryNamesNativeDataSource implements ICountryDataSource {
  @override
  Future<List<CountryEntity>> fetchList() {
    // List<Map> jsonList = countriesEnglish : codes;
    List<Map> jsonList = codes;

    List<CountryEntity> elements = jsonList
        .map((s) => CountryEntity(
              name: s['name'],
              code: s['code'],
              dialCode: s['dial_code'],
              flagSrc: 'flags/${s['code'].toLowerCase()}.png',
            ))
        .toList();
    return Future.value(elements);
  }
}
