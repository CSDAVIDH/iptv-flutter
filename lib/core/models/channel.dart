class Channel {
  final String name;
  final String url;
  final String? logo;
  final String? group;
  final String? tvgId;
  final String? tvgName;
  final bool isFavorite;

  Channel({
    required this.name,
    required this.url,
    this.logo,
    this.group,
    this.tvgId,
    this.tvgName,
    this.isFavorite = false,
  });

  Channel copyWith({
    String? name,
    String? url,
    String? logo,
    String? group,
    String? tvgId,
    String? tvgName,
    bool? isFavorite,
  }) {
    return Channel(
      name: name ?? this.name,
      url: url ?? this.url,
      logo: logo ?? this.logo,
      group: group ?? this.group,
      tvgId: tvgId ?? this.tvgId,
      tvgName: tvgName ?? this.tvgName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
