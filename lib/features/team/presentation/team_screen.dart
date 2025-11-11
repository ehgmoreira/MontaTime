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

  @override
  void initState() {
    super.initState();
    _build();
  }

  void _build() {
    final players = ref.read(playersProvider);
    teams = TeamBalancer.makeBalancedTeams(players, widget.teamCount);
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
            Text('Jogadores: ${players.length}  •  Times: ${widget.teamCount}'),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: teams.length,
                itemBuilder: (ctx, i) => TeamCard(team: teams[i], index: i),
              ),
            ),
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
