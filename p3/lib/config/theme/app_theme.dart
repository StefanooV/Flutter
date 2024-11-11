import 'package:flutter/material.dart';

const Color _customColor = Color(0x00272788);

const List<Color> _colorThemes = [
  _customColor,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.deepOrange,
  Colors.yellow,
  Colors.pink,
];

class AppTheme {
  final int selectedColors;

  AppTheme({required this.selectedColors})
      : assert(selectedColors >= 0 && selectedColors <= _colorThemes.length - 1,
            'Colors must be between 0 and ${_colorThemes.length}');

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColors],
    );
  }
}
