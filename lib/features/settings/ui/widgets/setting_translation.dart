import 'package:sys_control/generated/l10n.dart';

String settingLabel(S l10n, String label) => switch (label) {
  'General Settings' => l10n.generalSettings,
  'Display' => l10n.display,
  'Audio' => l10n.audio,
  'Network' => l10n.network,
  'Language' => l10n.language,
  'Time Zone' => l10n.timeZone,
  'Auto Update' => l10n.autoUpdate,
  'Firmware Version' => l10n.firmwareVersion,
  'Brightness' => l10n.brightness,
  'Contrast' => l10n.contrast,
  'Color Temperature' => l10n.colorTemperature,
  'Night Mode' => l10n.nightMode,
  'Temperature Unit' => l10n.temperatureUnit,
  'Master Volume' => l10n.masterVolume,
  'Audio Output' => l10n.audioOutput,
  'Audio Mode' => l10n.audioMode,
  'Wi-Fi' => l10n.wifi,
  'Hostname' => l10n.hostname,
  'DNS Timeout' => l10n.dnsTimeout,
  _ => label,
};

String settingDescription(S l10n, String description) => switch (description) {
  'App display language' => l10n.appDisplayLanguage,
  'IANA timezone identifier' => l10n.ianaTimezoneDesc,
  'Automatically install firmware updates' => l10n.autoUpdateDesc,
  'Temperature display unit' => l10n.temperatureUnitDesc,
  'Device name on the local network' => l10n.hostnameDesc,
  'Timeout for DNS resolution requests' => l10n.dnsTimeoutDesc,
  _ => description,
};
