/// Represents a single entry from the remote catalog's 'files' map.
class RemoteFileEntry {
  final String md5Hash;
  final String lastModified;

  const RemoteFileEntry({required this.md5Hash, required this.lastModified});

  factory RemoteFileEntry.fromJson(Map<String, dynamic> json) => RemoteFileEntry(
        md5Hash: json['md5Hash'] as String,
        lastModified: json['lastModified'] as String,
      );
}