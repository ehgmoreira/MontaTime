import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/position_player_controller.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/position_player_card.dart';
import '../../../widgets/position_player_form.dart';
import 'position_team_screen.dart';

class PositionPlayerListScreen extends ConsumerWidget {
  const PositionPlayerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(positionPlayersProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Times por Posição'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: players.isEmpty
                ? null
                : () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Limpar todos?'),
                        content: const Text('Remover todos os jogadores?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Limpar'),
                          ),
                        ],
                      ),
                    );

                    if (ok == true) {
                      ref.read(positionPlayersProvider.notifier).clear();
                    }
                  },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const PositionPlayerForm(),
            const SizedBox(height: 12),
            Expanded(
              child: players.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sports_volleyball_outlined,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum jogador adicionado.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (ctx, i) {
                        return PositionPlayerCard(player: players[i])
                            .animate()
                            .fadeIn(duration: 250.ms)
                            .slideY(begin: 0.08, curve: Curves.easeOut);
                      },
                    ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: players.length < 2
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const PositionTeamScreen(teamCount: 2),
                              ),
                            );
                          },
                    icon: const Icon(Icons.sports_volleyball),
                    label: const Text('Montar 2 Times'),
                  ),
                ),
                const SizedBox(width: 12),
                PopupMenuButton<int>(
                  onSelected: (v) {
                    if (players.length >= v) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PositionTeamScreen(teamCount: v),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Mínimo $v jogadores para $v times',
                          ),
                        ),
                      );
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 2, child: Text('2 Times')),
                    PopupMenuItem(value: 3, child: Text('3 Times')),
                    PopupMenuItem(value: 4, child: Text('4 Times')),
                  ],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
