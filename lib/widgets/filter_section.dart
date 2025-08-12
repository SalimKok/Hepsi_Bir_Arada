// lib/widgets/filter_section.dart
import 'package:flutter/material.dart';

class FilterSection extends StatelessWidget {
  final String? selectedPlatform;
  final String? selectedCategory;
  final Function(String?) onPlatformChanged;
  final Function(String?) onCategoryChanged;

  const FilterSection({
    super.key,
    required this.selectedPlatform,
    required this.selectedCategory,
    required this.onPlatformChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return const ExpansionTile(
      title: Text("Filtrele"),
      leading: Icon(Icons.filter_list),
    );
  }
}
