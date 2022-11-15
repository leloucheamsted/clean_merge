T getValueOrDefault<T>(dynamic value, T defaultValue) {
  return value == null ? defaultValue : value as T;
}
