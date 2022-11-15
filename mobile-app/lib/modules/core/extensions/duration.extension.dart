extension DurationExtensions on Duration {
  /// Converts the duration into a readable string
  /// 05:15
  String toHoursMinutes() {
    String twoDigitMinutes = _formatDigits(inMinutes.remainder(60));
    return "${_formatDigits(inHours)}:$twoDigitMinutes";
  }

  /// Converts the duration into a readable string
  /// 05:15:35
  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _formatDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _formatDigits(inSeconds.remainder(60));
    return "${_formatDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _formatDigits(int n) => n >= 10 ? "$n" : "0$n";
}
