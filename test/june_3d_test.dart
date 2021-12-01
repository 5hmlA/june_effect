import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:june_3d/june_3d.dart';

void main() {
  const MethodChannel channel = MethodChannel('june_3d');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

}
