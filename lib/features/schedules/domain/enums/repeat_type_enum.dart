enum RepeatTypeEnum {
  once(longName: 'Once'),
  daily(longName: 'Daily'),
  weekly(longName: 'Weekly'),
  monthly(longName: 'Monthly');

  const RepeatTypeEnum({required this.longName});

  final String longName;
}
