enum HistoryTimeRange {
  hourly(longName: '24h'),
  daily(longName: '7d'),
  weekly(longName: '30d');

  const HistoryTimeRange({required this.longName});

  final String longName;
}
