import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'images_repostitory.dart';

final appDirectoryProvider = FutureProvider<Directory>((ref) {
  return getApplicationDocumentsDirectory();
});

final imageRepositoryProvider = FutureProvider<ImageRepository>((ref) async {
  final appDirectory = await ref.watch(appDirectoryProvider.future);
  return ImageRepository(appDirectory);
});