class CountryEntity {
  final String name;
  final String code;
  final String dialCode;
  final String? flagSrc;
  CountryEntity({
    required this.name,
    required this.code,
    required this.dialCode,
    this.flagSrc,
  });
}
