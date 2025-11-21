import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/position_player_model.dart';
import '../controllers/position_player_controller.dart';
import '../logic/position_team_balancer.dart';
import '../../../widgets/position_team_card.dart';

class PositionTeamScreen extends ConsumerStatefulWidget {
  final int teamCount;

  const PositionTeamScreen({super.key, this.teamCount = 2});

  @override
  ConsumerState<PositionTeamScreen> createState() => _PositionTeamScreenState();
}

class _PositionTeamScreenState extends ConsumerState<PositionTeamScreen> {
  late List<List<PositionPlayer>> teams;
  List<PositionPlayer> outsidePlayers = [];

  @override
  void initState() {
    super.initState();
    _build();
  }

  void _build() {
    final players = ref.read(positionPlayersProvider);

    final result =
        PositionTeamBalancer.makeBalancedTeams(players, widget.teamCount);

    teams = result.sublist(0, widget.teamCount);
    outsidePlayers = result.last;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(positionPlayersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Times por Posição'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 2,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${players.length}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Jogadores'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${widget.teamCount}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Times'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${outsidePlayers.length}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Reservas'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  for (int i = 0; i < teams.length; i++)
                    PositionTeamCard(team: teams[i], index: i),
                  const SizedBox(height: 16),
                  if (outsidePlayers.isNotEmpty)
                    Card(
                      elevation: 2,
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person_off,
                                    color: Colors.orange.shade700),
                                const SizedBox(width: 8),
                                Text(
                                  "Jogadores Reservas",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.orange.shade900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...outsidePlayers.map((p) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    "• ${p.name} (${p.position.label} - Nível ${p.level})",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: _build,
              icon: const Icon(Icons.refresh),
              label: const Text('Refazer Balanceamento'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
