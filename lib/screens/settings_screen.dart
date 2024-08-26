import 'package:flutter/material.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _lockScreenEnabled = false;
  String _pattern = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lockScreenEnabled = prefs.getBool('lockScreenEnabled') ?? false;
      _pattern = prefs.getString('lockPattern') ?? '';
    });
  }

  _saveLockScreenSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lockScreenEnabled', value);
    setState(() {
      _lockScreenEnabled = value;
    });
    if (value && _pattern.isEmpty) {
      _showSetPatternDialog();
    }
  }

  _savePattern(String pattern) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lockPattern', pattern);
    setState(() {
      _pattern = pattern;
    });
  }

  void _showSetPatternDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Lock Pattern'),
          content: Container(
            width: 300,
            height: 300,
            child: PatternLock(
              selectedColor: Colors.blue,
              pointRadius: 8,
              showInput: true,
              dimension: 3,
              relativePadding: 0.7,
              selectThreshold: 25,
              fillPoints: true,
              onInputComplete: (List<int> input) {
                String pattern = input.join();
                _savePattern(pattern);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Lock Screen'),
            subtitle: const Text('Secure the app with a pattern lock'),
            value: _lockScreenEnabled,
            onChanged: (bool value) {
              _saveLockScreenSetting(value);
            },
          ),
          if (_lockScreenEnabled)
            ListTile(
              title: const Text('Change Lock Pattern'),
              onTap: _showSetPatternDialog,
            ),
        ],
      ),
    );
  }
}