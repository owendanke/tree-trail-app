/*
  LocalCatalog manages local_catalog.json - the app's index of what asset files
  are confirmed present on disk, along with their md5 hashes.

  Structure of local_catalog.json:
  {
    "lastSyncHash": "<master md5 hash from the last successful sync>",
    "lastSyncTime": "<ISO 8601 timestamp>",
    "files": {
      "trees/1-18/thumbnail.jpg": {
        "md5Hash": "SpRK8pQWWev9+7J+DjtdRg==",
        "lastModified": "2026-03-26T03:41:25.563Z"
      },
      ...
    }
  }

  Only files that have been confirmed written to disk are recorded here.
  A file present in remote_catalog.json but absent from local_catalog.json
  (or with a differing md5Hash) will be downloaded on the next sync.
*/

import 'package:httapp/models/catalog/local_file_entry.dart';

/// In-memory representation of local_catalog.json.
class LocalCatalog {
  /// The master md5 hash from the remote catalog at the time of the last sync.
  /// Empty string if no sync has occurred.
  String lastSyncHash;

  /// ISO 8601 timestamp of the last successful sync.
  /// Empty string if no sync has occurred.
  String lastSyncTime;

  /// Map of catalog-relative file keys to their local file entries.
  /// Keys match remote catalog format: e.g. 'trees/1-18/thumbnail.jpg'
  Map<String, LocalFileEntry> files;

  LocalCatalog({
    this.lastSyncHash = '',
    this.lastSyncTime = '',
    Map<String, LocalFileEntry>? files,
  }) : files = files ?? {};

  factory LocalCatalog.fromJson(Map<String, dynamic> json) => LocalCatalog(
        lastSyncHash: json['lastSyncHash'] as String? ?? '',
        lastSyncTime: json['lastSyncTime'] as String? ?? '',
        files: (json['files'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(
            key,
            LocalFileEntry.fromJson(value as Map<String, dynamic>),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        'lastSyncHash': lastSyncHash,
        'lastSyncTime': lastSyncTime,
        'files': files.map((key, entry) => MapEntry(key, entry.toJson())),
      };

  /// Returns true if this key exists in the local catalog with the given hash.
  bool hasFile(String key, String md5Hash) {
    final entry = files[key];
    return entry != null && entry.md5Hash == md5Hash;
  }

  /// Returns true if this key exists in the local catalog at all,
  /// regardless of hash. Used to detect files that need re-download
  /// due to hash mismatch vs files that are simply missing.
  bool hasKey(String key) => files.containsKey(key);
}