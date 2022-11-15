abstract class ISimpleValidator<T> {
  Future<T> validate(T input);
}
