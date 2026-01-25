import 'package:flutter/material.dart';

/// A reusable integer editor widget styled as a ListTile.
/// Compatible with EditPropertyPageBuilder's editorWidgetBuilder.
class IntEditor extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;
  final String? label;
  final String? description;
  final IconData? icon;

  const IntEditor({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final String labelText = label ?? '';
    final String? descriptionText = description;
    final IconData? iconData = icon;
    final TextEditingController controller =
        TextEditingController(text: value?.toString() ?? '');

    return ListTile(
      leading: iconData != null ? Icon(iconData) : null,
      title: Text(labelText),
      subtitle: descriptionText != null ? Text(descriptionText) : null,
      trailing: SizedBox(
        width: 100,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (text) {
            onChanged(int.tryParse(text));
          },
        ),
      ),
    );
  }
}
