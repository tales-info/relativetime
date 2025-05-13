import 'package:relativetime/relativetime.dart';

void main() {
  final now = DateTime.now();
  final earlier = now.subtract(Duration(minutes: 5));

  final result = relativeTime(earlier, reference: now);
  print(result); // e.g. "5 minutes ago"
}
