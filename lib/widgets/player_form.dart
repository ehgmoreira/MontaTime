import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/player/controllers/player_controller.dart';

class PlayerForm extends ConsumerStatefulWidget {
  const PlayerForm({super.key});
  @override
  ConsumerState<PlayerForm> createState() => _PlayerFormState();
}

class _PlayerFormState extends ConsumerState<PlayerForm> {
  final _nameCtrl = TextEditingController();
  int _level = 2;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(playersProvider.notifier);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nome do jogador'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Nível:'),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: _level,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Iniciante')),
                    DropdownMenuItem(value: 2, child: Text('Básico')),
                    DropdownMenuItem(value: 3, child: Text('Intermediário')),
                    DropdownMenuItem(value: 4, child: Text('Avançado')),
                  ],
                  onChanged: (v) => setState(() => _level = v ?? 2),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Jogador'),
              onPressed: () {
                final name = _nameCtrl.text.trim();
                if (name.isEmpty) return;
                controller.add(name, _level);
                _nameCtrl.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jogador adicionado')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
