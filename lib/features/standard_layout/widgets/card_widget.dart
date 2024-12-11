import 'package:char_creator/features/standard_layout/basic_view_model.dart';
import 'package:flutter/material.dart';

import '../../../utils/image_automatic.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.basicViewModel,
    this.imagePlaceholder,
  });
  final BasicViewModel basicViewModel;
  final Widget? imagePlaceholder;

  @override
  Widget build(BuildContext context) {
    final Widget image;
    if (basicViewModel.imagePath != null) {
      final imageType = ImageAutomatic.getImageType(
        basicViewModel.imagePath!,
      );
      image = switch (imageType) {
        ImageType.svg => FractionallySizedBox(
            alignment: Alignment.center,
            widthFactor: 0.5,
            child: ImageAutomatic.build(
              path: basicViewModel.imagePath!,
            ),
          ),
        _ => ImageAutomatic.build(
            path: basicViewModel.imagePath!,
          ),
      };
    } else {
      image = imagePlaceholder ?? Container();
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.zero,
              child: image,
            ),
          ),
          if (basicViewModel.title != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: basicViewModel.title!,
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    basicViewModel.title!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
          if (basicViewModel.description != null) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: basicViewModel.description!,
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    basicViewModel.description!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
