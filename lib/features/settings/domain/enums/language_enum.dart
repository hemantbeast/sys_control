enum LanguageEnum {
  english('English', 'en'),
  korean('한국어', 'ko'),
  french('Français', 'fr'),
  italian('Italiano', 'it'),
  german('Deutsch', 'de'),
  spanish('Español', 'es');

  const LanguageEnum(this.longName, this.code);

  final String longName;
  final String code;

  static LanguageEnum fromCode(String code) {
    return values.firstWhere(
      (e) => e.code == code,
      orElse: () => LanguageEnum.english,
    );
  }

  static LanguageEnum? tryFromName(String value) {
    for (final language in values) {
      if (language.longName == value || language.code == value || language.name == value) {
        return language;
      }
    }
    return null;
  }
}
