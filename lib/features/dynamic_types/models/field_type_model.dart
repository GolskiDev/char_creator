class FieldTypeModel {
  final String name;
  final String label;
  final String? iconPath;

  FieldTypeModel({
    required this.name,
    required this.label,
    this.iconPath,
  });

  factory FieldTypeModel.fromMap(Map<String, dynamic> map) {
    return FieldTypeModel(
      name: map['name'],
      label: map['label'],
      iconPath: map['iconPath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'label': label,
      'iconPath': iconPath,
    };
  }
}
