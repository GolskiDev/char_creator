import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScoreWidget extends HookConsumerWidget {
  final AsyncValueSetter<int?>? onChanged;
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

    final focusNode = useFocusNode();

    useEffect(() {
      focusNode.addListener(() async {
        if (!focusNode.hasFocus) {
          final currentValue = textController.text;

          final intValue = int.tryParse(currentValue);
          await onChanged?.call(intValue);
        }
      });
      return null;
    }, [focusNode]);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: TextField(
        focusNode: focusNode,
        decoration: InputDecoration(
          icon: Icon(icon),
          hintText: label,
          labelText: label,
          labelStyle: Theme.of(context).textTheme.labelLarge,
        ),
        textAlign: TextAlign.center,
        keyboardType: textInputType,
        controller: textController,
        inputFormatters: inputFormatters,
      ),
    );
  }
}
