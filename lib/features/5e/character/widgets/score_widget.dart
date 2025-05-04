import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScoreWidget extends HookConsumerWidget {
  final ValueChanged<int?>? onChanged;
  final int? initialValue;
  final IconData? icon;
  final String label;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;

  const ScoreWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.initialValue,
    this.textInputType,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController(
      text: initialValue?.toString() ?? '',
    );
    final state = useState(initialValue);

    final isSaved = initialValue == state.value;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: TextField(
          decoration: InputDecoration(
            icon: isSaved
                ? Icon(icon)
                : SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
            label: Text(
              label,
              textAlign: TextAlign.center,
            ),
            labelStyle: Theme.of(context).textTheme.labelLarge,
            border: isSaved
                ? OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.none,
                      width: 0,
                    ),
                  )
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                  ),
          ),
          textAlign: TextAlign.center,
          keyboardType: textInputType,
          controller: textController,
          inputFormatters: inputFormatters,
          onChanged: (value) {
            final intValue = int.tryParse(value);
            state.value = intValue;
          },
          onSubmitted: (_) {
            onChanged?.call(state.value);
          },
        ),
      ),
    );
  }
}
