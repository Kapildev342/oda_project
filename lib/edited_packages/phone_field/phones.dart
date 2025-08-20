class PhoneNumber {
  String countryISOCode;
  String countryCode;
  String number;
  int maxLength;

  PhoneNumber({
    required this.countryISOCode,
    required this.countryCode,
    required this.number,
    required this.maxLength
  });

  String get completeNumber {
    return countryCode + number;
  }

  @override
  String toString() =>
      'PhoneNumber(countryISOCode: $countryISOCode, countryCode: $countryCode, number: $number)';
}
