import 'package:flutter/material.dart';

/// Simple role selection chip used on LoginScreen
class RoleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const RoleChip({Key? key, required this.label, this.selected = false, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Role: $label',
      selected: selected,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ChoiceChip(
          label: Text(label, style: const TextStyle(fontSize: 14)),
          selected: selected,
          onSelected: (_) => onTap?.call(),
        ),
      ),
    );
  }
}
