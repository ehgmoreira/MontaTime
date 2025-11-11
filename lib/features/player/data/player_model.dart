class Player {
  final String id;
  final String name;
  final int level;

  Player({
    required this.id,
    required this.name,
    required this.level,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
      };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json['id'],
        name: json['name'],
        level: json['level'],
      );
}
