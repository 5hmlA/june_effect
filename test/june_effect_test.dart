import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:june_effect/june_effect.dart';

void main() {
  const MethodChannel channel = MethodChannel('june_effect');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
  });
}
