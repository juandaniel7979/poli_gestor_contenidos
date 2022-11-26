import 'package:flutter/material.dart';

class Tag {
  final IconData icon;  
  final String name;
  final Color color;
  bool isSelected = false;

  Tag(this.icon, this.name, this.color, this.isSelected);
  
}