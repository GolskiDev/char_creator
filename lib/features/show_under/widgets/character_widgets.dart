import 'package:flutter/material.dart';

class ListTileThemeWrapper extends StatelessWidget {
  final Widget child;
  const ListTileThemeWrapper({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: ListTileThemeData(
          titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          subtitleTextStyle: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      child: child,
    );
  }
}

class TraitBuilder extends StatelessWidget {
  final String tag;
  final IconData icon;
  final String title;
  final String subtitle;
  final Function()? onTap;
  const TraitBuilder({
    super.key,
    required this.tag,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(icon),
          onTap: onTap,
          subtitle: Text(subtitle),
          title: Text(title),
        ),
      ),
    );
  }
}

class GroupBuilder extends StatelessWidget {
  final IconData? grupIcon;
  final String groupTitle;
  final List<Widget> children;
  final int abilityScoresLength;
  final Widget Function({required Widget child}) listTileThemeWrapper;
  final double? preferredWidth;
  const GroupBuilder({
    super.key,
    this.grupIcon,
    required this.groupTitle,
    required this.children,
    required this.abilityScoresLength,
    required this.listTileThemeWrapper,
    this.preferredWidth,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: grupIcon == null ? null : Icon(grupIcon),
          titleAlignment: ListTileTitleAlignment.center,
          title: Text(groupTitle),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Use a more reasonable preferredWidth for ability scores
              final double width = preferredWidth ?? 100.0;
              var maxItemsInRow = 6;
              final crossAxisCount = () {
                if (abilityScoresLength % 2 != 0) {
                  return (constraints.maxWidth / width)
                      .floor()
                      .clamp(1, maxItemsInRow);
                } else {
                  maxItemsInRow = (constraints.maxWidth / width)
                      .floor()
                      .clamp(1, maxItemsInRow);
                  for (var i = maxItemsInRow; i >= 1; i--) {
                    if (abilityScoresLength % i == 0) {
                      return i;
                    }
                  }
                  return 1;
                }
              }();
              return listTileThemeWrapper(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 16 / 9,
                  physics: const NeverScrollableScrollPhysics(),
                  children: children,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class OthersBuilder extends StatelessWidget {
  final Widget Function() ageBuilder;
  final Widget Function() alignmentBuilder;
  final Widget Function() sizeBuilder;
  final Widget Function() speedBuilder;
  final Widget Function() visionBuilder;
  final Widget Function() proficienciesBuilder;
  final Widget Function() languagesBuilder;
  final Widget Function({required Widget child}) listTileThemeWrapper;
  const OthersBuilder({
    super.key,
    required this.ageBuilder,
    required this.alignmentBuilder,
    required this.sizeBuilder,
    required this.speedBuilder,
    required this.visionBuilder,
    required this.proficienciesBuilder,
    required this.languagesBuilder,
    required this.listTileThemeWrapper,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.list),
          title: Text('Other Properties'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: listTileThemeWrapper(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ageBuilder(),
                alignmentBuilder(),
                sizeBuilder(),
                speedBuilder(),
                visionBuilder(),
                proficienciesBuilder(),
                languagesBuilder(),
              ]
                  .map(
                    (e) => Card(
                      clipBehavior: Clip.antiAlias,
                      child: e,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
