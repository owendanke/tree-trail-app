import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

/// Handles chosing the correct AppCheck provider
class AppCheckConfig {
  /// Reads the debug token injected at build time via --dart-define.
  /// Returns null if not set (the SDK will auto-generate one and log it).
  static const String? _debugToken = String.fromEnvironment('APP_CHECK_DEBUG_TOKEN') == ''
    ? null
    : String.fromEnvironment('APP_CHECK_DEBUG_TOKEN');

  /// Get an AppCheck provider for Android device
  /// 
  /// [isDebug] is set to kDebugMode by default and is true for debug builds.
  /// 
  /// In debug mode, returns `AndroidDebugProvider()`.
  /// 
  /// In release builds and/or when [isDebug] is `false`,
  /// `AndroidPlayIntegrityProvider()` is returned.
  static AndroidAppCheckProvider getAndroidProvider({bool isDebug = kDebugMode}) {
    return isDebug ? AndroidDebugProvider(debugToken: _debugToken) : AndroidPlayIntegrityProvider();
  }
  
  /// Get an AppCheck provider for Apple device
  /// 
  /// [isDebug] is set to kDebugMode by default and is true for debug builds.
  /// 
  /// In debug mode, returns `AppleDebugProvider()`.
  /// 
  /// In release builds and/or when [isDebug] is `false`,
  /// `AppleAppAttestProvider()` is returned.
  static AppleAppCheckProvider getAppleProvider({bool isDebug = kDebugMode}) {
    return isDebug ? AppleDebugProvider(debugToken: _debugToken) : AppleAppAttestProvider();
  }
  
  /// Activates the FirebaseAppCheck instance with Apple and Android providers.
  static Future<void> activate() async {
    await FirebaseAppCheck.instance.activate(
      providerAndroid: getAndroidProvider(),
      providerApple: getAppleProvider(),
    );
  }
}