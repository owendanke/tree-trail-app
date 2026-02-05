/*
  Definitions for remote paths
  Must match in Storage
  No trailing slash as to match local_path.dart
*/

final _remoteTextPath = 'text';
final _remoteDescriptionPath = 'descriptions';
final _remoteImagePath = 'images';
final _remoteThumbnailPath = '$_remoteImagePath/thumbnails';


String get remoteTextPath {
  return _remoteTextPath;
}

String get remoteDescriptionPath {
  return _remoteDescriptionPath;
}

String get remoteImagePath {
  return _remoteImagePath;
}

String get remoteThumbnailPath {
  return _remoteThumbnailPath;
}