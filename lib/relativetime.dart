enum TimeUnit {
  now,
  second,
  minute,
  hour,
  day,
  yesterday,
  tomorrow,
  today,
  week,
  month,
  year,
}

class RelativeTimeConfig {
  final bool abbreviated;
  final bool capitalize;
  final bool useToday;
  final int? nowThresholdSeconds;
  final String pastPrefix;
  final String futurePrefix;
  final Map<TimeUnit, String Function(int, bool abbreviated)>? formatters;

  const RelativeTimeConfig({
    this.abbreviated = false,
    this.capitalize = false,
    this.useToday = false,
    this.nowThresholdSeconds,
    this.pastPrefix = 'ago',
    this.futurePrefix = 'in',
    this.formatters,
  });
}

var enFormatters = <TimeUnit, String Function(int, bool)>{
  TimeUnit.now: (_, a) => a ? 'now' : 'just now',
  TimeUnit.today: (_, a) => a ? 'today' : 'today',
  TimeUnit.yesterday: (_, a) => a ? 'yest.' : 'yesterday',
  TimeUnit.tomorrow: (_, a) => a ? 'tom.' : 'tomorrow',
  TimeUnit.second: (v, a) => a ? '${v}s' : '$v second${v != 1 ? 's' : ''}',
  TimeUnit.minute: (v, a) => a ? '${v}m' : '$v minute${v != 1 ? 's' : ''}',
  TimeUnit.hour: (v, a) => a ? '${v}h' : '$v hour${v != 1 ? 's' : ''}',
  TimeUnit.day: (v, a) => a ? '${v}d' : '$v day${v != 1 ? 's' : ''}',
  TimeUnit.week: (v, a) => a ? '${v}w' : '$v week${v != 1 ? 's' : ''}',
  TimeUnit.month: (v, a) => a ? '${v}mo' : '$v month${v != 1 ? 's' : ''}',
  TimeUnit.year: (v, a) => a ? '${v}y' : '$v year${v != 1 ? 's' : ''}',
};

String relativeTime(
  DateTime? date, {
  DateTime? reference,
  RelativeTimeConfig config = const RelativeTimeConfig(),
}) {
  if (date == null) return '';

  final now = reference ?? DateTime.now();
  final difference = date.difference(now);
  final seconds = difference.inSeconds.abs();
  final minutes = difference.inMinutes.abs();
  final hours = difference.inHours.abs();
  final days = difference.inDays.abs();
  final weeks = (days / 7).floor();
  final months = (days / 30).floor();
  final years = (days / 365).floor();
  final isFuture = difference.inSeconds > 0;

  // Treat as "now"
  if (config.nowThresholdSeconds != null &&
      seconds <= config.nowThresholdSeconds!) {
    return _format(config, TimeUnit.now, 0, isFuture);
  }

  // Treat as "today"
  if (config.useToday &&
      date.year == now.year &&
      date.month == now.month &&
      date.day == now.day) {
    return _format(config, TimeUnit.today, 0, isFuture);
  }

  // Yesterday or Tomorrow
  if (days == 1) {
    if (!isFuture) return _format(config, TimeUnit.yesterday, 0, isFuture);
    return _format(config, TimeUnit.tomorrow, 0, isFuture);
  }

  TimeUnit unit;
  int value;

  if (seconds < 60) {
    unit = TimeUnit.second;
    value = seconds;
  } else if (minutes < 60) {
    unit = TimeUnit.minute;
    value = minutes;
  } else if (hours < 24) {
    unit = TimeUnit.hour;
    value = hours;
  } else if (days < 7) {
    unit = TimeUnit.day;
    value = days;
  } else if (days < 30) {
    unit = TimeUnit.week;
    value = weeks;
  } else if (days < 365) {
    unit = TimeUnit.month;
    value = months;
  } else {
    unit = TimeUnit.year;
    value = years;
  }

  return _format(config, unit, value, isFuture);
}

String _format(
  RelativeTimeConfig config,
  TimeUnit unit,
  int value,
  bool isFuture,
) {
  final label =
      (config.formatters ?? enFormatters)[unit]?.call(
        value,
        config.abbreviated,
      ) ??
      '';
  final result = switch (unit) {
    TimeUnit.now ||
    TimeUnit.today ||
    TimeUnit.yesterday ||
    TimeUnit.tomorrow => label,
    _ =>
      isFuture
          ? '${config.futurePrefix} $label'
          : '$label ${config.pastPrefix}',
  };

  return config.capitalize ? _capitalize(result) : result;
}

String _capitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}
