import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../data/player_model.dart';

final playersProvider =
    NotifierProvider<PlayerController, List<Player>>(PlayerController.new);

class PlayerController extends Notifier<List<Player>> {
  static const _key = 'players_v1';
  final _uuid = const Uuid();

  @override
  List<Player> build() {
    _load(); // carrega automaticamente ao inicializar
    return [];
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    state = list.map((s) => Player.fromJson(jsonDecode(s))).toList();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final list = state.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_key, list);
  }

  Future<void> add(String name, int level) async {
    final player = Player(id: _uuid.v4(), name: name, level: level);
    state = [...state, player];
    await _save();
  }

  Future<void> remove(String id) async {
    state = state.where((p) => p.id != id).toList();
    await _save();
  }

  Future<void> clear() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
