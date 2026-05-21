class EnergyUsageEntity {
  const EnergyUsageEntity({required this.thisYear, required this.lastYear, required this.labels});

  final List<double> thisYear;
  final List<double> lastYear;
  final List<String> labels;
}
