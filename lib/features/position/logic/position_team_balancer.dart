import '../data/position_player_model.dart';
import 'dart:math';

class PositionTeamBalancer {
  /// Monta times balanceados considerando posições específicas
  /// Formação ideal: 1 Levantador, 2 Centrais, 2 Pontas, 1 Oposto (+ Líbero opcional)
  static List<List<PositionPlayer>> makeBalancedTeams(
    List<PositionPlayer> players,
    int teamCount,
  ) {
    if (teamCount <= 0) throw ArgumentError('teamCount must be >= 1');
    if (players.isEmpty) return List.generate(teamCount, (_) => []);

    final teams = List.generate(teamCount, (_) => <PositionPlayer>[]);
    final outside = <PositionPlayer>[];
    final rand = Random();

    // Separa jogadores por posição
    final byPosition = <VolleyballPosition, List<PositionPlayer>>{};
    for (var pos in VolleyballPosition.values) {
      byPosition[pos] = players.where((p) => p.position == pos).toList()
        ..shuffle(rand);
    }

    // ETAPA 1: Distribuição por posição (prioridade)
    // Ideal: 1 levantador por time
    _distributePosition(
      byPosition[VolleyballPosition.levantador]!,
      teams,
      outside,
      maxPerTeam: 1,
    );

    // 2 centrais por time
    _distributePosition(
      byPosition[VolleyballPosition.central]!,
      teams,
      outside,
      maxPerTeam: 2,
    );

    // 2 pontas por time
    _distributePosition(
      byPosition[VolleyballPosition.ponteiro]!,
      teams,
      outside,
      maxPerTeam: 2,
    );

    // 1 oposto por time
    _distributePosition(
      byPosition[VolleyballPosition.oposto]!,
      teams,
      outside,
      maxPerTeam: 1,
    );

    // Líberos (opcional, máximo 1 por time)
    _distributePosition(
      byPosition[VolleyballPosition.libero]!,
      teams,
      outside,
      maxPerTeam: 1,
    );

    // ETAPA 2: Balanceamento de nível entre times
    _balanceByLevel(teams);

    return [...teams, outside];
  }

  /// Distribui jogadores de uma posição específica entre os times
  static void _distributePosition(
    List<PositionPlayer> players,
    List<List<PositionPlayer>> teams,
    List<PositionPlayer> outside, {
    required int maxPerTeam,
  }) {
    for (var player in players) {
      // Ordena times por quantidade de jogadores nessa posição
      teams.sort((a, b) {
        final countA = a.where((p) => p.position == player.position).length;
        final countB = b.where((p) => p.position == player.position).length;
        return countA.compareTo(countB);
      });

      final currentCount =
          teams.first.where((p) => p.position == player.position).length;

      if (currentCount >= maxPerTeam &&
          teams.every((t) =>
              t.where((p) => p.position == player.position).length >=
              maxPerTeam)) {
        outside.add(player);
      } else {
        teams.first.add(player);
      }
    }
  }

  /// Balanceia os times por nível de habilidade através de trocas
  static void _balanceByLevel(List<List<PositionPlayer>> teams) {
    bool improved = true;
    int attempts = 0;

    while (improved && attempts < 200) {
      attempts++;

      final scores =
          teams.map((t) => t.fold<int>(0, (sum, p) => sum + p.level)).toList();

      final maxScore = scores.reduce(max);
      final minScore = scores.reduce(min);

      if (maxScore - minScore <= 1) break;

      final strongIndex = scores.indexOf(maxScore);
      final weakIndex = scores.indexOf(minScore);

      bool swapped = false;

      // Tenta trocar jogadores da MESMA posição entre times forte e fraco
      for (var strongPlayer in List<PositionPlayer>.from(teams[strongIndex])) {
        for (var weakPlayer in List<PositionPlayer>.from(teams[weakIndex])) {
          // Só troca se for da mesma posição
          if (strongPlayer.position != weakPlayer.position) continue;

          final newStrongScore =
              maxScore - strongPlayer.level + weakPlayer.level;
          final newWeakScore = minScore - weakPlayer.level + strongPlayer.level;

          final improves = (newStrongScore - newWeakScore).abs() <
              (maxScore - minScore).abs();

          if (improves) {
            teams[strongIndex].remove(strongPlayer);
            teams[weakIndex].remove(weakPlayer);
            teams[strongIndex].add(weakPlayer);
            teams[weakIndex].add(strongPlayer);
            swapped = true;
            break;
          }
        }
        if (swapped) break;
      }

      if (!swapped) improved = false;
    }
  }

  /// Retorna estatísticas sobre a distribuição dos times
  static Map<String, dynamic> getTeamStats(List<PositionPlayer> team) {
    final positionCount = <VolleyballPosition, int>{};
    for (var pos in VolleyballPosition.values) {
      positionCount[pos] = team.where((p) => p.position == pos).length;
    }

    final totalLevel = team.fold<int>(0, (sum, p) => sum + p.level);
    final avgLevel = team.isEmpty ? 0.0 : totalLevel / team.length;

    return {
      'positions': positionCount,
      'totalLevel': totalLevel,
      'avgLevel': avgLevel,
      'playerCount': team.length,
    };
  }
}
