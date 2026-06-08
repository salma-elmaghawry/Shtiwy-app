import 'package:flutter/material.dart';
import 'package:shtiwy/core/injection/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shtiwy/core/routes/routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _chooseEveryKey = 'choose_every_time';
  bool _chooseEvery = false;

  @override
  void initState() {
    super.initState();
    final prefs = getIt<SharedPreferences>();
    _chooseEvery = prefs.getBool(_chooseEveryKey) ?? false;
  }

  Future<void> _setChooseEvery(bool value) async {
    final prefs = getIt<SharedPreferences>();
    await prefs.setBool(_chooseEveryKey, value);
    setState(() => _chooseEvery = value);
  }

  void _openLanguageSelection() {
    Navigator.of(context).pushNamed(Routes.languageSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Choose language & theme at startup'),
              subtitle: const Text('Show selection screen every launch'),
              value: _chooseEvery,
              onChanged: _setChooseEvery,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _openLanguageSelection,
              icon: const Icon(Icons.edit),
              label: const Text('Edit language & theme'),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            // Placeholder for other settings
            const Text('Other settings will go here'),
          ],
        ),
      ),
    );
  }
}
