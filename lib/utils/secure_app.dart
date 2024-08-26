import 'package:flutter/material.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';


class SecureApp extends StatefulWidget {
  final Widget child;
  const SecureApp({super.key, required this.child});
  @override
  _SecureAppState createState() => _SecureAppState();
}

class _SecureAppState extends State<SecureApp> with WidgetsBindingObserver {
  bool _isBlurred = false;
  bool _lockScreenEnabled = false;
  String _pattern = '';
  bool _needsUnlock = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lockScreenEnabled = prefs.getBool('lockScreenEnabled') ?? false;
      _pattern = prefs.getString('lockPattern') ?? '';
      _isBlurred = _lockScreenEnabled && _pattern.isNotEmpty;
      _needsUnlock = _isBlurred;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      setState(() {
        _needsUnlock = _lockScreenEnabled && _pattern.isNotEmpty;
      });
    }
    setState(() {
      _isBlurred = (state != AppLifecycleState.resumed || _needsUnlock) && _lockScreenEnabled && _pattern.isNotEmpty;
    });
  }

  Future<void> _unlockApp(String pattern) async {
    if (pattern == _pattern) {
      setState(() {
        _isBlurred = false;
        _needsUnlock = false;
      });
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect pattern. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isBlurred)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: PatternLock(
                  selectedColor: Colors.white,
                  pointRadius: 8,
                  showInput: true,
                  dimension: 3,
                  relativePadding: 0.7,
                  selectThreshold: 25,
                  fillPoints: true,
                  onInputComplete: (List<int> input) {
                    String pattern = input.join();
                    _unlockApp(pattern);
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}