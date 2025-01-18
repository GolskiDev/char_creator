import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum ImageType { svg, png, jpg, jpeg }

enum ImageSource { asset, file, web }

class ImageAutomatic {
  static Widget build({
    required String path,
    AlignmentGeometry? alignment,
    BoxFit? fit,
    double? height,
    double? width,
    Widget Function(BuildContext context)? placeholderBuilder,
  }) {
    final fileType = getImageType(path);
    final fileSource = getImageSource(path);

    if (fileType == ImageType.svg) {
      return switch (fileSource) {
        ImageSource.asset => FittedBox(
            child: SvgPicture.asset(
              path,
              alignment: alignment ?? Alignment.center,
              fit: fit ?? BoxFit.contain,
              height: height,
              width: width,
              placeholderBuilder: placeholderBuilder,
            ),
          ),
        ImageSource.file => FittedBox(
            child: SvgPicture.file(
              File(path),
              alignment: alignment ?? Alignment.center,
              fit: fit ?? BoxFit.contain,
              height: height,
              width: width,
              placeholderBuilder: placeholderBuilder,
            ),
          ),
        ImageSource.web => FittedBox(
            child: SvgPicture.network(
              path,
              alignment: alignment ?? Alignment.center,
              fit: fit ?? BoxFit.contain,
              height: height,
              width: width,
              placeholderBuilder: placeholderBuilder,
            ),
          ),
      };
    }

    return switch (fileSource) {
      ImageSource.asset => Image.asset(
          path,
          alignment: alignment ?? Alignment.center,
          fit: fit ?? BoxFit.contain,
          height: height,
          width: width,
          errorBuilder: (context, error, stackTrace) {
            return placeholderBuilder != null
                ? placeholderBuilder.call(context)
                : const SizedBox();
          },
          frameBuilder: placeholderBuilder != null
              ? (context, __, ___, ____) => placeholderBuilder.call(context)
              : null,
        ),
      ImageSource.file => Image.file(
          File(path),
          alignment: alignment ?? Alignment.center,
          fit: fit ?? BoxFit.contain,
          height: height,
          width: width,
          errorBuilder: (context, error, stackTrace) {
            return placeholderBuilder != null
                ? placeholderBuilder.call(context)
                : const SizedBox();
          },
          frameBuilder: placeholderBuilder != null
              ? (context, __, ___, ____) => placeholderBuilder.call(context)
              : null,
        ),
      ImageSource.web => Image.network(
          path,
          alignment: alignment ?? Alignment.center,
          fit: fit ?? BoxFit.contain,
          height: height,
          width: width,
          errorBuilder: (context, error, stackTrace) {
            return placeholderBuilder != null
                ? placeholderBuilder.call(context)
                : const SizedBox();
          },
          frameBuilder: placeholderBuilder != null
              ? (context, __, ___, ____) => placeholderBuilder.call(context)
              : null,
        ),
    };
  }

  static ImageType getImageType(String path) {
    switch (path.split('.').last) {
      case 'svg':
        return ImageType.svg;
      case 'png':
        return ImageType.png;
      case 'jpg':
        return ImageType.jpg;
      case 'jpeg':
        return ImageType.jpeg;
      default:
        return ImageType.svg;
    }
  }

  static ImageSource getImageSource(String path) {
    if (path.startsWith('http')) {
      return ImageSource.web;
    } else if (path.startsWith('assets')) {
      return ImageSource.asset;
    } else {
      return ImageSource.file;
    }
  }
}
