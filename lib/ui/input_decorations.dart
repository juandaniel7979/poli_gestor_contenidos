import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/providers/theme_provider.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String label,
    IconData? prefixIcon,
    required Color color
  }) {
    return InputDecoration(
                fillColor: color,
                filled: true,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTheme.primary
                    )
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.primary
                    )
                  ),
                  hintText: hintText,
                  label: Text(label),
                  labelStyle: const TextStyle(
                    color: Colors.black
                  ),
                  prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: AppTheme.primary,)
                  : null
              );
  }
}