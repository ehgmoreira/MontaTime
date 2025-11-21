import '../../player/data/player_model.dart';
import 'dart:math';

class TeamBalancer {
  /// Algoritmo final:
  /// - Times com máximo de 6 jogadores
  /// - Usuário escolhe quantos times quer
  /// - Excedente vai para "jogadores de fora" SEM criar time extra
  /// - Balanceamento inteligente (score + quantidade)
  static List<List<Player>> makeBalancedTeams(
    List<Player> players,
    int teamCount,
  ) {
    if (teamCount <= 0) throw ArgumentError('teamCount must be >= 1');
    if (players.isEmpty) return List.generate(teamCount, (_) => []);

    final teams = List.generate(teamCount, (_) => <Player>[]);
    final outside = <Player>[];
    final rand = Random();

    // Embaralha para evitar times sempre iguais
    final shuffled = List<Player>.from(players)..shuffle(rand);

    // ----------------------------------------------------------
    // ETAPA 1 — DISTRIBUIR GARANTINDO LIMITE DE 6 POR TIME
    // ----------------------------------------------------------
    for (var player in shuffled) {
      teams.sort((a, b) => a.length.compareTo(b.length));

      // Se todos já têm 6 → vai para fora
      if (teams.first.length >= 6) {
        outside.add(player);
      } else {
        teams.first.add(player);
      }
    }

    // ----------------------------------------------------------
    // ETAPA 2 — BALANCEAMENTO DE NÍVEL + QUANTIDADE
    // Sem ultrapassar o limite definido
    // ----------------------------------------------------------
    _balanceWithLimits(teams, maxSize: 6);

    return [...teams, outside];
  }

  /// Balanceamento por troca entre o time mais forte e mais fraco.
  /// Mantém limite máximo e não deixa time ficar com menos de 1 jogador.
  static void _balanceWithLimits(
    List<List<Player>> teams, {
    required int maxSize,
  }) {
    bool improved = true;
    int attempts = 0;

    while (improved && attempts < 300) {
      attempts++;

      final scores =
          teams.map((t) => t.fold<int>(0, (s, p) => s + p.level)).toList();

      int maxScore = scores.reduce(max);
      int minScore = scores.reduce(min);

      if (maxScore - minScore <= 1) break;

      final strongIndex = scores.indexOf(maxScore);
      final weakIndex = scores.indexOf(minScore);

      final strong = teams[strongIndex];
      final weak = teams[weakIndex];

      bool swapped = false;

      for (var a in List<Player>.from(strong)) {
        for (var b in List<Player>.from(weak)) {
          if (weak.length >= maxSize) continue;
          if (strong.length <= 1) continue;

          final newStrongScore = maxScore - a.level + b.level;
          final newWeakScore = minScore - b.level + a.level;

          bool improves = (newStrongScore - newWeakScore).abs() <
              (maxScore - minScore).abs();

          if (improves) {
            strong.remove(a);
            weak.remove(b);
            strong.add(b);
            weak.add(a);
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
