import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

IconData getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'şikayet':
      return Icons.report_problem;
    case 'öneri':
      return Icons.lightbulb;
    case 'soru':
      return Icons.help;
    case 'teşekkür':
      return Icons.thumb_up;
    case 'diğer':
      return Icons.add_box;
    default:
      return Icons.label;
  }
}

Color getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'şikayet':
      return Colors.red;
    case 'öneri':
      return Colors.orange;
    case 'soru':
      return Colors.blue;
    case 'teşekkür':
      return Colors.green;
    case 'diğer':
      return Colors.grey;
    default:
      return Colors.grey;
  }
}
