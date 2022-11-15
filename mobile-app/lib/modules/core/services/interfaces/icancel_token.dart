abstract class ICancelToken {
  bool get isCanceled;
  void cancel([dynamic reason]);
}
