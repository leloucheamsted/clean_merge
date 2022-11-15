import 'dart:math';

mixin FakerRandomMixin {
  DateTime createDateTime() {
    final Random random = Random();
    final year = DateTime.now().year;
    final month = 1 + random.nextInt(11);
    final day = 1 + random.nextInt(30);
    final hour = 1 + random.nextInt(23);
    final minute = 1 + random.nextInt(60);
    final second = 1 + random.nextInt(60);

    return DateTime(year, month, day, hour, minute, second);
  }

  Future<T> returnWithDelay<T>(dynamic data) {
    return Future.delayed(const Duration(seconds: 1), () => data);
  }
}
