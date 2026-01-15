import 'package:flutter/material.dart';

/// ShowUnder is a system, where you have some Data and would like to present it under another target widget.
/// The target widget has it's name.

abstract interface class ShowUnderTarget {
  String get targetName;
}

/// This would be a cool idea, but we should probably separate it even more.
class TargetWidget extends StatelessWidget implements ShowUnderTarget {
  const TargetWidget({super.key});

  static const String _targetName = "FunWidget";

  @override
  String get targetName => _targetName;

  @override
  Widget build(BuildContext context) {
    final List<Widget> allTheWidgetsWithTheTargetName;

    return Column(
      children: const [
        Text(
          'This is the target widget.',
        ),
        Icon(
          Icons.star,
          size: 50,
          color: Colors.amber,
        ),
      ],
    );
  }
}
