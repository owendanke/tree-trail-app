import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

/// Automated test that scans all Dart files for asset usage
/// and validates them against pubspec.yaml
void main() {
  group('Automated Asset Validation', () {
    late Set<String> declaredAssets;
    late Set<String> usedAssets;

    setUpAll(() async {
      print('Starting asset validation...');
      
      // Load pubspec.yaml
      print('Loading pubspec.yaml...');
      final pubspecFile = File('pubspec.yaml');
      final pubspecContent = pubspecFile.readAsStringSync();
      final pubspec = loadYaml(pubspecContent) as YamlMap;
      
      print('Extracting declared assets...');
      declaredAssets = _extractDeclaredAssets(pubspec);
      print('Found ${declaredAssets.length} declared assets');

      if (declaredAssets.isNotEmpty) {
        print('\nDeclared assets:');
        for (final asset in declaredAssets) {
          print('  - $asset');
        }
      }

      // Scan all Dart files for asset usage
      print('Scanning Dart files for asset usage...');
      usedAssets = await _scanProjectForAssets();
      print('Found ${usedAssets.length} used assets in code');
      //print(usedAssets);
      
      if (usedAssets.isNotEmpty) {
        print('\nUsed assets:');
        for (final asset in usedAssets) {
          print('  - $asset');
        }
      }
    });

    test('all used assets should be declared in pubspec.yaml', () {
      final undeclaredAssets = <String>[];

      for (final assetPath in usedAssets) {
        if (!_isAssetDeclared(assetPath, declaredAssets)) {
          undeclaredAssets.add(assetPath);
        }
      }

      if (undeclaredAssets.isNotEmpty) {
        fail(
          'The following assets are used in code but NOT declared in pubspec.yaml:\n'
          '${undeclaredAssets.map((a) => '  - $a').join('\n')}\n\n'
        );
      }
    });

    test('report unused declared assets', () {
      final unusedAssets = <String>[];

      for (final declaredPath in declaredAssets) {
        // Skip directory declarations
        if (declaredPath.endsWith('/')) continue;
        
        if (!usedAssets.contains(declaredPath) && 
            !_isUsedInDirectory(declaredPath, usedAssets)) {
          unusedAssets.add(declaredPath);
        }
      }

      if (unusedAssets.isNotEmpty) {
        print(
          'INFO: The following declared assets are not used in code:\n'
          '${unusedAssets.map((a) => '  - $a').join('\n')}\n'
          'Consider removing them from pubspec.yaml if they are truly unused.',
        );
      }
    }, skip: false); // Set to true if you don't want this warning
  });
}

/// Extract all asset paths from pubspec.yaml
Set<String> _extractDeclaredAssets(YamlMap pubspec) {
  final assets = <String>{};
  
  final flutter = pubspec['flutter'];
  if (flutter is YamlMap) {
    final assetsList = flutter['assets'];
    if (assetsList is YamlList) {
      for (final asset in assetsList) {
        if (asset is String) {
          assets.add(asset);
          
          // If directory declaration, add all files in it
          if (asset.endsWith('/')) {
            try {
              final dir = Directory(asset);
              if (dir.existsSync()) {
                final files = dir.listSync(recursive: true);
                for (final file in files) {
                  if (file is File) {
                    // Normalize path separators
                    final normalizedPath = file.path.replaceAll('\\', '/');
                    assets.add(normalizedPath);
                  }
                }
              }
            } catch (e) {
              // Skip if directory can't be read
              print('Warning: Could not read directory $asset: $e');
            }
          }
        }
      }
    }
  }
  
  return assets;
}

/// Check if an asset is declared (directly or via directory)
bool _isAssetDeclared(String assetPath, Set<String> declaredAssets) {
  // Normalize the path (replace any backslashes with forward slash)
  final normalizedPath = assetPath.replaceAll('\\', '/');
  
  // Direct match
  if (declaredAssets.contains(normalizedPath)) {
    return true;
  }
  
  // Check directory-based declarations
  for (final declared in declaredAssets) {
    // for every string in declaredAssets
    
    if (declared.endsWith('/')) {
      // if declared is a direcory (string ending with '/')

      if (normalizedPath.startsWith(declared)) {
        // declared and asset directories match

        if (File(normalizedPath).existsSync()) {
          // the file exists in the stated directory

          return true;
        }
        else {
          // the file DOES NOT exist in the stated directory

          return false;
        }
      }
    }
  }
  
  // Check if any parent directory is declared
  String currentPath = normalizedPath;
  while (currentPath.contains('/')) {
    currentPath = currentPath.substring(0, currentPath.lastIndexOf('/'));

    if (currentPath.isEmpty) break;
    
    if (declaredAssets.contains('$currentPath/')) {
      return true;
    }
  }
    
  return false;
}

/// Check if a declared asset is used (for directory-based usage)
bool _isUsedInDirectory(String declaredPath, Set<String> usedAssets) {
  for (final used in usedAssets) {
    if (used.startsWith(declaredPath)) {
      return true;
    }
  }
  return false;
}

/// Scan all Dart files in the project for asset string literals
Future<Set<String>> _scanProjectForAssets() async {
  final allAssets = <String>{};
  final libDir = Directory('lib');
  
  if (!libDir.existsSync()) {
    return allAssets;
  }
  
  // Common patterns for asset usage in Flutter
  final patterns = [
    // AssetImage
    RegExp(r'''AssetImage\s*\(\s*['"]([^'"]+)['"]\s*[,)]'''),
    // Image.asset
    RegExp(r'''Image\.asset\s*\(\s*['"]([^'"]+)['"]\s*[,)]'''),
    // rootBundle.loadString
    RegExp(r'''rootBundle\.loadString\s*\(\s*['"]([^'"]+)['"]\s*[,)]'''),
    // rootBundle.load
    RegExp(r'''rootBundle\.load\s*\(\s*['"]([^'"]+)['"]\s*[,)]'''),
    // rootBundle.loadStructuredData
    RegExp(r'''rootBundle\.loadStructuredData\s*\(\s*['"]([^'"]+)['"]\s*,'''),
    // DefaultAssetBundle.of(...).loadString
    RegExp(r'''DefaultAssetBundle\.of\([^)]+\)\.loadString\s*\(\s*['"]([^'"]+)['"]\s*[,)]'''),
    // DefaultAssetBundle.of(...).load
    RegExp(r'''DefaultAssetBundle\.of\([^)]+\)\.load\s*\(\s*['"]([^'"]+)['"]\s*[,)]'''),
    // AssetManifest
    RegExp(r'''AssetManifest\.loadFromAssetBundle\s*\(\s*['"]([^'"]+)['"]\s*[,)]'''),
    // SvgPicture.asset (flutter_svg)
    RegExp(r'''SvgPicture\.asset\s*\(\s*['"]([^'"]+)['"]\s*[,)]'''),
    // Lottie.asset (lottie)
    RegExp(r'''Lottie\.asset\s*\(\s*['"]([^'"]+)['"]\s*[,)]'''),
    // VideoPlayerController.asset (video_player)
    RegExp(r'''VideoPlayerController\.asset\s*\(\s*['"]([^'"]+)['"]\s*[,)]'''),
    // AudioPlayer().setAsset (just_audio)
    RegExp(r'''\.setAsset\s*\(\s*['"]([^'"]+)['"]\s*[,)]'''),
  ];
  
  try {
    // Add timeout to prevent hanging on large projects or slow file systems
    await for (final entity in libDir.list(recursive: true).timeout(
      const Duration(seconds: 30),
      onTimeout: (sink) {
        print('Warning: Directory listing timed out after 30 seconds');
        sink.close();
      },
    )) {
      if (entity is File && entity.path.endsWith('.dart')) {
        try {
          // Add timeout for individual file reads
          final content = await entity.readAsString().timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              print('Warning: Timed out reading ${entity.path}');
              return '';
            },
          );
          
          if (content.isEmpty) continue;
          
          for (final pattern in patterns) {
            try {
              final matches = pattern.allMatches(content);
              for (final match in matches) {
                if (match.groupCount >= 1) {
                  final assetPath = match.group(1);
                  if (assetPath != null && 
                      assetPath.isNotEmpty &&
                      !assetPath.startsWith('package:') &&
                      !assetPath.contains(r'$')) {  // Skip string interpolations
                    // Normalize path
                    final normalized = assetPath.replaceAll('\\', '/');
                    allAssets.add(normalized);
                  }
                }
              }
            } catch (e) {
              print('Warning: Pattern matching failed for ${entity.path}: $e');
            }
          }
        } catch (e) {
          print('Warning: Could not read file ${entity.path}: $e');
        }
      }
    }
  } catch (e) {
    print('Warning: Error scanning project: $e');
  }
  
  return allAssets;
}