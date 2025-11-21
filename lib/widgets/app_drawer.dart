import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.sports_volleyball,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  'Monta Times ⚡',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Montagem Simples'),
            subtitle: const Text('Balanceamento por nível'),
            onTap: () {
              Navigator.pop(context);
              context.go('/players');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.sports),
            title: const Text('Montagem por Posição'),
            subtitle: const Text('Considerar posições específicas'),
            onTap: () {
              Navigator.pop(context);
              context.go('/position-players');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'Monta Times',
                applicationVersion: '2.0',
                applicationIcon: const Icon(Icons.sports_volleyball, size: 48),
                children: [
                  const Text(
                    'Aplicativo para montagem inteligente de times de vôlei.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
