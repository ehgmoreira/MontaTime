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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF1E1B2E),
      hintStyle: const TextStyle(color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(playersProvider.notifier);
    final players = ref.watch(playersProvider);

    return Card(
      elevation: 6,
      color: const Color(0xFF14121F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Campo Nome
            TextField(
              controller: _nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Nome do jogador'),
              onEditingComplete: () => FocusScope.of(context).unfocus(),
            ),

            const SizedBox(height: 16),

            /// Dropdown com estilo premium
            Row(
              children: [
                const Text(
                  'Nível:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _level,
                    dropdownColor: const Color(0xFF1E1B2E),
                    iconEnabledColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(''),
                    items: const [
                      DropdownMenuItem(
                          value: 1,
                          child: Text('Iniciante',
                              style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(
                          value: 2,
                          child: Text('Básico',
                              style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(
                          value: 3,
                          child: Text('Intermediário',
                              style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(
                          value: 4,
                          child: Text('Avançado',
                              style: TextStyle(color: Colors.white))),
                    ],
                    onChanged: (v) => setState(() => _level = v ?? 2),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Botão premium lilás
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB388F8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text(
                  'Adicionar Jogador',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                onPressed: () {
                  final name = _nameCtrl.text.trim();
                  if (name.isEmpty) return;

                  final exists = players.any(
                    (p) => p.name.toLowerCase() == name.toLowerCase(),
                  );

                  if (exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Esse nome já foi adicionado.'),
                      ),
                    );
                    return;
                  }

                  controller.add(name, _level);
                  FocusScope.of(context).unfocus();
                  _nameCtrl.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
