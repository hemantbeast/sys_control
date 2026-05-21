enum TemperatureUnitEnum {
  celsius('Celsius', '°C'),
  fahrenheit('Fahrenheit', '°F');

  const TemperatureUnitEnum(this.longName, this.symbol);

  final String longName;
  final String symbol;

  static TemperatureUnitEnum? tryFromName(String value) {
    for (final unit in values) {
      if (unit.longName == value || unit.name == value) {
        return unit;
      }
    }
    return null;
  }

  double toDisplay(double celsius) {
    return switch (this) {
      TemperatureUnitEnum.celsius => celsius,
      TemperatureUnitEnum.fahrenheit => celsius * 9 / 5 + 32,
    };
  }

  double fromDisplay(double display) {
    return switch (this) {
      TemperatureUnitEnum.celsius => display,
      TemperatureUnitEnum.fahrenheit => (display - 32) * 5 / 9,
    };
  }

  String format(double celsius, {int decimals = 0}) {
    return '${toDisplay(celsius).toStringAsFixed(decimals)}$symbol';
  }
}
