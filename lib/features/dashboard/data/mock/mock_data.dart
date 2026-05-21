const String energyMockData = '''
{
  "cost": 1.12,
  "efficiency": 84,
  "usage": 2.4,
  "outdoor_temp": 28
}
''';

const String zonesMockData = '''
[
  {
    "name": "Living Room",
    "is_on": true,
    "is_eco": false,
    "temp": 22.5,
    "humidity": 45,
    "mode": 2,
    "fan_speed": 2
  },
  {
    "name": "Master Bedroom",
    "is_on": true,
    "is_eco": false,
    "temp": 24.2,
    "humidity": 38,
    "mode": 1,
    "fan_speed": 0
  },
  {
    "name": "Kitchen",
    "is_on": true,
    "is_eco": true,
    "temp": 21.8,
    "humidity": 52,
    "mode": 2,
    "fan_speed": 1
  },
  {
    "name": "Study",
    "is_on": false,
    "is_eco": false,
    "temp": 19.5,
    "humidity": 42,
    "mode": 1,
    "fan_speed": 2
  },
  {
    "name": "Garage",
    "is_on": false,
    "is_eco": false,
    "temp": 16.0,
    "humidity": 61,
    "mode": 2,
    "fan_speed": 2
  }
]
''';
