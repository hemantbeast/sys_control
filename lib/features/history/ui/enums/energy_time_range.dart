enum EnergyTimeRange {
  weekly(longName: 'Weekly'),
  monthly(longName: 'Monthly'),
  yearly(longName: 'Yearly');

  const EnergyTimeRange({required this.longName});

  final String longName;
}
