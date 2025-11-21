import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../data/position_player_model.dart';

final positionPlayersProvider =
    NotifierProvider<PositionPlayerController, List<PositionPlayer>>(
        PositionPlayerController.new);

class PositionPlayerController extends Notifier<List<PositionPlayer>> {
  static const _key = 'position_players_v1';
  final _uuid = const Uuid();

  @override
  List<PositionPlayer> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    state = list.map((s) => PositionPlayer.fromJson(jsonDecode(s))).toList();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final list = state.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_key, list);
  }

  Future<void> add(String name, int level, VolleyballPosition position) async {
    final player = PositionPlayer(
      id: _uuid.v4(),
      name: name,
      level: level,
      position: position,
    );
    state = [...state, player];
    await _save();
  }

  Future<void> remove(String id) async {
    state = state.where((p) => p.id != id).toList();
    await _save();
  }

  Future<void> update(PositionPlayer player) async {
    state = state.map((p) => p.id == player.id ? player : p).toList();
    await _save();
  }

  Future<void> clear() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
