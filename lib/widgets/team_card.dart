import 'package:flutter/material.dart';
import 'package:monta_timeV2/features/player/data/player_model.dart';

class TeamCard extends StatelessWidget {
  final List<Player> team;
  final int index;

  const TeamCard({
    super.key,
    required this.team,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Time ${index + 1}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            if (team.isEmpty)
              const Text(
                "Nenhum jogador neste time",
                style: TextStyle(fontSize: 16),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: team
                    .map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          "${p.name} (Nível ${p.level})",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
