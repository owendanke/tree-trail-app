/*
  LocalFileEntry represents a single record, or entry, in the local_catalog.json file.

  {
    "trees/1-18/thumbnail.jpg": {
    "md5Hash": "SpRK8pQWWev9+7J+DjtdRg==",
    "lastModified": "2026-03-26T03:41:25.563Z"
  }

*/

/// Represents a single file entry in local_catalog.json.
class LocalFileEntry {
  final String md5Hash;
  final String lastModified;

  const LocalFileEntry({required this.md5Hash, required this.lastModified});

  factory LocalFileEntry.fromJson(Map<String, dynamic> json) => LocalFileEntry(
        md5Hash: json['md5Hash'] as String,
        lastModified: json['lastModified'] as String,
      );

  Map<String, dynamic> toJson() => {
        'md5Hash': md5Hash,
        'lastModified': lastModified,
      };
}