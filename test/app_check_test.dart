// Verify AppCheck is not using debug provider for release
//
// run with `flutter test test/app_check_test.dart`
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:httapp/services/firebase/app_check_config.dart';

void main() {
  group('AppCheck provider selection', () {
    test('should use Play Integrity provider in release mode (Android)', () {
      final provider = AppCheckConfig.getAndroidProvider(isDebug: false);
      
      // Check the exact runtime type
      expect(provider.runtimeType, equals(AndroidPlayIntegrityProvider));
    });

    test('should use Debug provider in debug mode (Android)', () {
      final provider = AppCheckConfig.getAndroidProvider(isDebug: true);
      
      expect(provider.runtimeType, equals(AndroidDebugProvider));
    });

    test('should use App Attest provider in release mode (iOS)', () {
      final provider = AppCheckConfig.getAppleProvider(isDebug: false);
      
      expect(provider.runtimeType, equals(AppleAppAttestProvider));
      expect(provider, isNot(isA<AppleDebugProvider>()));
    });

    test('should use Debug provider in debug mode (iOS)', () {
      final provider = AppCheckConfig.getAppleProvider(isDebug: true);
      
      expect(provider.runtimeType, equals(AppleDebugProvider));
    });
  });
}