enum VolleyballPosition {
  levantador('Levantador'),
  ponteiro('Ponteiro'),
  oposto('Oposto'),
  central('Central'),
  libero('Líbero');

  final String label;
  const VolleyballPosition(this.label);

  static VolleyballPosition fromString(String str) {
    return VolleyballPosition.values.firstWhere(
      (p) => p.name == str,
      orElse: () => VolleyballPosition.ponteiro,
    );
  }
}

class PositionPlayer {
  final String id;
  final String name;
  final int level;
  final VolleyballPosition position;

  PositionPlayer({
    required this.id,
    required this.name,
    required this.level,
    required this.position,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
        'position': position.name,
      };

  factory PositionPlayer.fromJson(Map<String, dynamic> json) => PositionPlayer(
        id: json['id'],
        name: json['name'],
        level: json['level'],
        position: VolleyballPosition.fromString(json['position']),
      );

  PositionPlayer copyWith({
    String? id,
    String? name,
    int? level,
    VolleyballPosition? position,
  }) {
    return PositionPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      position: position ?? this.position,
    );
  }
}
