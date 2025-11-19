abstract interface class UserPreferenceInterface<T> {
  String get key {
    throw UnimplementedError();
  }

  final T _value;

  UserPreferenceInterface({
    required T value,
  }) : _value = value;

  factory UserPreferenceInterface.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() => {
        key: _value,
      };
}
