import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../team/presentation/team_screen.dart';
import '../../player/controllers/player_controller.dart';
import '../../../widgets/player_card.dart';
import '../../../widgets/player_form.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PlayerListScreen extends ConsumerWidget {
  const PlayerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Montar Times - Vôlei'),
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
                      ref.read(playersProvider.notifier).clear();
                    }
                  },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const PlayerForm(),
            const SizedBox(height: 12),
            Expanded(
              child: players.isEmpty
                  ? const Center(child: Text('Nenhum jogador adicionado.'))
                  : ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (ctx, i) {
                        return PlayerCard(player: players[i])
                            .animate()
                            .fadeIn(duration: 250.ms)
                            .slideY(begin: 0.08, curve: Curves.easeOut);
                      },
                    ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: players.length < 2
                        ? null
                        : () {
                            // default 2 times — você pode flexibilizar
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TeamScreen(teamCount: 2),
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
                          builder: (_) => TeamScreen(teamCount: v),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Minimo $v jogadores para $v times'),
                        ),
                      );
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 2, child: Text('2 Times')),
                    const PopupMenuItem(value: 3, child: Text('3 Times')),
                    const PopupMenuItem(value: 4, child: Text('4 Times')),
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
