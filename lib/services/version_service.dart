import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Service for getting app version from pubspec.yaml
class VersionService {
  static final VersionService _instance = VersionService._internal();
  factory VersionService() => _instance;
  VersionService._internal();

  PackageInfo? _packageInfo;
  bool _initialized = false;

  /// Initialize the service by loading package info
  Future<void> init() async {
    if (_initialized) return;
    
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      _initialized = true;
      debugPrint('[VersionService] Loaded version: ${_packageInfo!.version}');
    } catch (e) {
      debugPrint('[VersionService] Failed to load package info: $e');
      _initialized = false;
    }
  }

  /// Check if properly initialized
  bool get isInitialized => _initialized && _packageInfo != null;

  /// Get the app version
  String get version {
    if (!_initialized || _packageInfo == null) {
      debugPrint('[VersionService] Warning: Service not initialized, returning fallback version');
      return 'unknown';
    }
    return _packageInfo!.version;
  }

  /// Get the app name
  String get appName {
    if (!_initialized || _packageInfo == null) {
      debugPrint('[VersionService] Warning: Service not initialized or package info is null, returning fallback version');
      return 'Holcomb Tree Tail';
    }
    return _packageInfo!.appName;
  }

  /// Get the package name or bundle ID
  String get packageName {
    if (!_initialized || _packageInfo == null) {
      debugPrint('[VersionService] Warning: Service not initialized or package info is null, returning fallback version');
      return 'org.odanke.HTTapp';
    }
    return _packageInfo!.packageName;
  }
}