import '../../player/data/player_model.dart';
import 'dart:math';

class TeamBalancer {
  /// Gera `teamCount` times tentando:
  /// 1) distribuir jogadores de cada nível entre os times (quando possível)
  /// 2) depois ajustar trocas para reduzir diferença de pontuação
  static List<List<Player>> makeBalancedTeams(
    List<Player> players,
    int teamCount,
  ) {
    if (teamCount <= 0) throw ArgumentError('teamCount must be >= 1');
    if (players.isEmpty) return List.generate(teamCount, (_) => []);

    // Agrupa por nível
    final Map<int, List<Player>> porNivel = {};
    for (var p in players) {
      porNivel.putIfAbsent(p.level, () => []).add(p);
    }

    // Inicializa teams
    final teams = List.generate(teamCount, (_) => <Player>[]);
    final rand = Random();

    // Etapa 1: para cada nível, embaralha e distribui round-robin
    for (var entry in porNivel.entries) {
      final list = List<Player>.from(entry.value);
      list.shuffle(rand);
      for (int i = 0; i < list.length; i++) {
        teams[i % teamCount].add(list[i]);
      }
    }

    // Etapa 2: se ainda houver desequilíbrio grande, tenta trocas
    _balanceByScore(teams);

    // Etapa 3: por estética, embaralha times (mantendo equilíbrio)
    teams.shuffle(rand);
    return teams;
  }

  static void _balanceByScore(List<List<Player>> teams) {
    bool improved = true;
    int attempts = 0;
    while (improved && attempts < 200) {
      attempts++;
      final scores =
          teams.map((t) => t.fold<int>(0, (s, p) => s + p.level)).toList();
      final maxScore = scores.reduce((a, b) => a > b ? a : b);
      final minScore = scores.reduce((a, b) => a < b ? a : b);
      if (maxScore - minScore <= 1) break;

      final idxMax = scores.indexOf(maxScore);
      final idxMin = scores.indexOf(minScore);
      bool swapped = false;

      // tenta encontrar a troca que reduz mais a diferença
      for (var a in List<Player>.from(teams[idxMax])) {
        for (var b in List<Player>.from(teams[idxMin])) {
          final newMax = maxScore - a.level + b.level;
          final newMin = minScore - b.level + a.level;
          if ((newMax - newMin).abs() < (maxScore - minScore)) {
            teams[idxMax].remove(a);
            teams[idxMin].remove(b);
            teams[idxMax].add(b);
            teams[idxMin].add(a);
            swapped = true;
            break;
          }
        }
        if (swapped) break;
      }
      if (!swapped) improved = false;
    }
  }
}
