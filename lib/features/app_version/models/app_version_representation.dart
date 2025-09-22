class AppVersionRepresentation implements Comparable<AppVersionRepresentation> {
  final int major;
  final int minor;
  final int patch;

  const AppVersionRepresentation({
    required this.major,
    required this.minor,
    required this.patch,
  })  : assert(major >= 0 && major <= 999,
            'Major version must be between 0 and 999'),
        assert(minor >= 0 && minor <= 999,
            'Minor version must be between 0 and 999'),
        assert(patch >= 0 && patch <= 999,
            'Patch version must be between 0 and 999');

  factory AppVersionRepresentation.parse(String version) {
    final parts = version.split('.');
    if (parts.length != 3) {
      throw FormatException('Version must be in x.x.x format');
    }
    final major = int.parse(parts[0]);
    final minor = int.parse(parts[1]);
    final patch = int.parse(parts[2]);
    return AppVersionRepresentation(
      major: major,
      minor: minor,
      patch: patch,
    );
  }

  factory AppVersionRepresentation.fromJson(Map<String, dynamic> json) {
    return AppVersionRepresentation(
      major: json['major'] ?? 0,
      minor: json['minor'] ?? 0,
      patch: json['patch'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'major': major,
        'minor': minor,
        'patch': patch,
      };

  @override
  int compareTo(AppVersionRepresentation other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    return patch.compareTo(other.patch);
  }

  @override
  String toString() => '$major.$minor.$patch';
}
