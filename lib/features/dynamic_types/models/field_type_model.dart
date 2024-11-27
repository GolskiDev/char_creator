class FieldTypeModel {
  final String name;
  final String label;

  FieldTypeModel({
    required this.name,
    required this.label,
  });

  factory FieldTypeModel.fromMap(Map<String, dynamic> map) {
    return FieldTypeModel(
      name: map['name'],
      label: map['label'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'label': label,
    };
  }
}
