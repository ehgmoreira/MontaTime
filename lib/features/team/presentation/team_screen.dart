import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monta_timeV2/features/player/data/player_model.dart';

import '../../player/controllers/player_controller.dart';
import '../logic/team_balancer.dart';
import '../../../widgets/team_card.dart';

class TeamScreen extends ConsumerStatefulWidget {
  final int teamCount;

  const TeamScreen({super.key, this.teamCount = 2});

  @override
  ConsumerState<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends ConsumerState<TeamScreen> {
  late List<List<Player>> teams;
  List<Player> outsidePlayers = [];

  @override
  void initState() {
    super.initState();
    _build();
  }

  void _build() {
    final players = ref.read(playersProvider);

    /// TeamBalancer retorna N times + jogadores de fora
    final result = TeamBalancer.makeBalancedTeams(players, widget.teamCount);

    teams = result.sublist(0, widget.teamCount);
    outsidePlayers = result.last;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Times Gerados')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Jogadores: ${players.length} • Times: ${widget.teamCount}'),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: [
                  /// ---- LISTA DOS TIMES ----
                  for (int i = 0; i < teams.length; i++)
                    TeamCard(team: teams[i], index: i),

                  const SizedBox(height: 16),

                  /// ---- CARD DE "JOGADORES DE FORA" ----
                  if (outsidePlayers.isNotEmpty)
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Jogadores de Fora",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              outsidePlayers
                                  .map((p) => "${p.name} (Nível ${p.level})")
                                  .join(", "),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// Botão de refazer
            ElevatedButton.icon(
              onPressed: _build,
              icon: const Icon(Icons.refresh),
              label: const Text('Refazer Balanceamento'),
            ),
          ],
        ),
      ),
    );
  }
}
