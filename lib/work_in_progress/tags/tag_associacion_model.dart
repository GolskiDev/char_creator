class TagAssociacionModel {
  final int id;
  final int tagId;
  final int associacionId;

  TagAssociacionModel({
    required this.id,
    required this.tagId,
    required this.associacionId,
  });

  TagAssociacionModel copyWith({
    int? id,
    int? tagId,
    int? associacionId,
  }) {
    return TagAssociacionModel(
      id: id ?? this.id,
      tagId: tagId ?? this.tagId,
      associacionId: associacionId ?? this.associacionId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tagId': tagId,
      'associacionId': associacionId,
    };
  }

  factory TagAssociacionModel.fromJson(Map<String, dynamic> map) {
    return TagAssociacionModel(
      id: map['id'],
      tagId: map['tagId'],
      associacionId: map['associacionId'],
    );
  }
}
