import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Currently lack a better name
class SmallSquareWidget extends HookConsumerWidget {
  const SmallSquareWidget({
    super.key,
    this.icon,
    this.shortLabel,
    this.content,
    this.onTap,
  });
  final IconData? icon;
  final Function()? onTap;
  final String? shortLabel;
  final String? content;

  static Size preferredSize(BuildContext context) {
    final iconSize = Theme.of(context).textTheme.titleLarge?.fontSize ?? 24.0;
    final prefferedWidth =
        3 * iconSize + paddingBetweenIconAndContent + 2 * paddingAround;
    return Size(prefferedWidth, prefferedWidth);
  }

  static const paddingAround = 8.0;
  static const paddingBetweenIconAndContent = 8.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labelStyle = Theme.of(context).textTheme.labelMedium;
    final contentStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        );
    final iconSize = Theme.of(context).textTheme.titleLarge?.fontSize ?? 24.0;

    return SizedBox(
      width: preferredSize(context).width,
      height: preferredSize(context).height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(paddingAround),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null)
                        Icon(
                          icon,
                          size: iconSize,
                        ),
                      SizedBox(width: paddingBetweenIconAndContent),
                      if (content != null)
                        Text(
                          content!,
                          style: contentStyle,
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                  if (shortLabel != null)
                    Text(
                      shortLabel!.toUpperCase(),
                      style: labelStyle,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
