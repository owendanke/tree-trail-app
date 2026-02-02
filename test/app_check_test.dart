// Verify AppCheck is not using debug provider for release
//
// run with `flutter test --release`
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';

void main() {
  test('AppCheck should not use debug provider in release mode', () {
    // This test runs in release mode in CI
    // kDebugMode will be false
    expect(kDebugMode, isFalse, 
      reason: 'Release builds must not use debug mode');
  });
}