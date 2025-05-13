import 'package:test/test.dart';
import 'package:relativetimeago/relativetime.dart';

void main() {
  final reference = DateTime(
    2025,
    5,
    12,
    12,
    0,
    0,
  ); // fixed datetime for consistency

  group('relativeTime', () {
    test('Returns "just now" for small differences', () {
      final date = reference.subtract(Duration(seconds: 3));
      final result = relativeTime(
        date,
        reference: reference,
        config: RelativeTimeConfig(nowThresholdSeconds: 5),
      );
      expect(result, 'just now');
    });

    test('Returns "today" when same day and useToday is true', () {
      final date = DateTime(2025, 5, 12, 9, 30);
      final result = relativeTime(
        date,
        reference: reference,
        config: RelativeTimeConfig(useToday: true),
      );
      expect(result, 'today');
    });

    test('Returns "yesterday"', () {
      final date = reference.subtract(Duration(days: 1));
      final result = relativeTime(date, reference: reference);
      expect(result, 'yesterday');
    });

    test('Returns "tomorrow"', () {
      final date = reference.add(Duration(days: 1));
      final result = relativeTime(date, reference: reference);
      expect(result, 'tomorrow');
    });

    test('Returns in seconds', () {
      final date = reference.subtract(Duration(seconds: 50));
      final result = relativeTime(date, reference: reference);
      expect(result, '50 seconds ago');
    });

    test('Returns in minutes', () {
      final date = reference.subtract(Duration(minutes: 30));
      final result = relativeTime(date, reference: reference);
      expect(result, '30 minutes ago');
    });

    test('Returns in hours', () {
      final date = reference.subtract(Duration(hours: 5));
      final result = relativeTime(date, reference: reference);
      expect(result, '5 hours ago');
    });

    test('Returns in days', () {
      final date = reference.subtract(Duration(days: 3));
      final result = relativeTime(date, reference: reference);
      expect(result, '3 days ago');
    });

    test('Returns in weeks', () {
      final date = reference.subtract(Duration(days: 14));
      final result = relativeTime(date, reference: reference);
      expect(result, '2 weeks ago');
    });

    test('Returns in months', () {
      final date = reference.subtract(Duration(days: 90));
      final result = relativeTime(date, reference: reference);
      expect(result, '3 months ago');
    });

    test('Returns in years', () {
      final date = reference.subtract(Duration(days: 365 * 2));
      final result = relativeTime(date, reference: reference);
      expect(result, '2 years ago');
    });

    test('Handles future time correctly', () {
      final date = reference.add(Duration(hours: 4));
      final result = relativeTime(date, reference: reference);
      expect(result, 'in 4 hours');
    });

    test('Returns abbreviated output', () {
      final date = reference.subtract(Duration(hours: 3));
      final result = relativeTime(
        date,
        reference: reference,
        config: RelativeTimeConfig(abbreviated: true),
      );
      expect(result, '3h ago');
    });

    test('Capitalizes the result', () {
      final date = reference.subtract(Duration(days: 2));
      final result = relativeTime(
        date,
        reference: reference,
        config: RelativeTimeConfig(capitalize: true),
      );

      final firstChar = result[0];
      expect(
        firstChar,
        firstChar.toUpperCase(),
        reason: 'First letter should be uppercase',
      );
    });

    test('Uses custom prefixes', () {
      final date = reference.add(Duration(minutes: 10));
      final result = relativeTime(
        date,
        reference: reference,
        config: RelativeTimeConfig(
          futurePrefix: 'in about',
          pastPrefix: 'ago from now',
        ),
      );
      expect(result, 'in about 10 minutes');
    });

    test('Returns empty string if date is null', () {
      final result = relativeTime(null);
      expect(result, '');
    });

    test('Combines multiple settings: abbreviated + capitalize + today', () {
      final result = relativeTime(
        reference,
        reference: reference,
        config: RelativeTimeConfig(
          abbreviated: true,
          capitalize: true,
          useToday: true,
        ),
      );
      expect(result, 'Today');
    });
  });
}
