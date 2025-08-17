import 'package:flutter_test/flutter_test.dart';
import '../lib/core/models/channel.dart';

void main() {
  group('Channel Model Tests', () {
    test('should create channel with required fields', () {
      // Act
      final channel = Channel(
        name: 'Test Channel',
        url: 'http://example.com/stream',
      );
      
      // Assert
      expect(channel.name, 'Test Channel');
      expect(channel.url, 'http://example.com/stream');
      expect(channel.logo, null);
    });

    test('should create channel with logo', () {
      // Act
      final channel = Channel(
        name: 'Test Channel',
        url: 'http://example.com/stream',
        logo: 'http://example.com/logo.png',
      );
      
      // Assert
      expect(channel.name, 'Test Channel');
      expect(channel.url, 'http://example.com/stream');
      expect(channel.logo, 'http://example.com/logo.png');
    });
  });
}