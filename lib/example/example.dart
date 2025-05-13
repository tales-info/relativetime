import 'package:relativetimeago/relativetime.dart';

void main() {
  final now = DateTime.now();

  final fiveMinutesAgo = now.subtract(Duration(minutes: 5));
  final twoDaysLater = now.add(Duration(days: 2));

  print(relativeTime(fiveMinutesAgo)); // "5 minutes ago"
  print(relativeTime(twoDaysLater)); // "in 2 days"

  // Using abbreviations
  print(
    relativeTime(fiveMinutesAgo, config: RelativeTimeConfig(abbreviated: true)),
  ); // "5m ago"

  // Using custom "now" threshold
  print(
    relativeTime(
      now.subtract(Duration(seconds: 3)),
      config: RelativeTimeConfig(nowThresholdSeconds: 5),
    ),
  ); // "now"

  // Capitalized output
  print(
    relativeTime(fiveMinutesAgo, config: RelativeTimeConfig(capitalize: true)),
  ); // "5 minutes ago"

  // Using "today" label
  final todayAtMorning = DateTime(now.year, now.month, now.day, 9);
  print(
    relativeTime(todayAtMorning, config: RelativeTimeConfig(useToday: true)),
  ); // "today"
}
