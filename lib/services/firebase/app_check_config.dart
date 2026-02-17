import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

/// Handles chosing the correct AppCheck provider
class AppCheckConfig {
  /// Get an AppCheck provider for Android device
  /// 
  /// [isDebug] is set to kDebugMode by default and is true for debug builds.
  /// 
  /// In debug mode, returns `AndroidDebugProvider()`.
  /// 
  /// In release builds and/or when [isDebug] is `false`,
  /// `AndroidPlayIntegrityProvider()` is returned.
  static AndroidAppCheckProvider getAndroidProvider({bool isDebug = kDebugMode}) {
    return isDebug ? AndroidDebugProvider() : AndroidPlayIntegrityProvider();
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
    return isDebug ? AppleDebugProvider() : AppleAppAttestProvider();
  }
  
  /// Activates the FirebaseAppCheck instance with Apple and Android providers.
  static Future<void> activate() async {
    await FirebaseAppCheck.instance.activate(
      providerAndroid: getAndroidProvider(),
      providerApple: getAppleProvider(),
    );
  }
}