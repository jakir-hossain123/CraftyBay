import 'package:flutter/widgets.dart';

ImageProvider imageProviderFor(String path) {
  return path.startsWith('http') ? NetworkImage(path) : AssetImage(path);
}
