class LanguageInfo {
  late String key;
  late String iconName;
  late String label;

  LanguageInfo(this.key, this.iconName, this.label);
}

final List<LanguageInfo> supportLanguages = <LanguageInfo>[
  LanguageInfo("ja", "assets/ntf_131.png", "日本語"),
  LanguageInfo("en", "assets/ntf_401.png", "English"),
  LanguageInfo("vi", "assets/ntf_140.png", "Tiếng Việt"),
  LanguageInfo("ne", "assets/ntf_132.png", "Nepali"),
];

const String defaultLanguage = "ja";
const String languageSettingsKey = "languageCode";
