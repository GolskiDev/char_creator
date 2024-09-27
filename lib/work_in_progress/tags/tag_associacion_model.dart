class TagAssociacionModel {
  final String tagId;
  final String associacionId;

  const TagAssociacionModel({
    required this.tagId,
    required this.associacionId,
  });

  //equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TagAssociacionModel &&
        other.tagId == tagId &&
        other.associacionId == associacionId;
  }

  @override
  int get hashCode => tagId.hashCode ^ associacionId.hashCode;

  TagAssociacionModel copyWith({
    String? tagId,
    String? associacionId,
  }) {
    return TagAssociacionModel(
      tagId: tagId ?? this.tagId,
      associacionId: associacionId ?? this.associacionId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'associacionId': associacionId,
    };
  }

  factory TagAssociacionModel.fromJson(Map<String, dynamic> map) {
    return TagAssociacionModel(
      tagId: map['tagId'],
      associacionId: map['associacionId'],
    );
  }
}
