import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    MyAppState state = context.findAncestorStateOfType<MyAppState>()!;
    state.setLocale(newLocale);
  }

  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class LanguageInfo {
  late String key;
  late String iconName;
  late String label;

  LanguageInfo(this.key, this.iconName, this.label);
}

class MyAppState extends State<MyApp> {
  final String defaultLanguage = "ja";
  final String languageSettingsKey = "languageCode";

  static final List<LanguageInfo> supportLanguages = <LanguageInfo>[
    LanguageInfo("ja", "ntf_131.png", "日本語"),
    LanguageInfo("en", "ntf_401.png", "English"),
    LanguageInfo("vi", "ntf_140.png", "Tiếng Việt"),
    LanguageInfo("ne", "ntf_132.png", "Nepali"),
  ];

  String selectLanguage = supportLanguages.first.key;
  Locale? locale;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  void setLocale(Locale newLocale) {
    setState(() {
      locale = newLocale;
    });
  }

  void _loadSavedLanguage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? savedLanguageCode = pref.getString(languageSettingsKey);
    if (savedLanguageCode == null) {
      // デフォルトは日本語
      setLocale(Locale(defaultLanguage));
    } else {
      setLocale(Locale(savedLanguageCode));
    }
  }

  void _changeLanguage(BuildContext context, String languageCode) async {
    Locale newLocale = Locale(languageCode);

    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(languageSettingsKey, languageCode);

    setLocale(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeeDoc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: Builder(builder: (context) {
        return Scaffold(appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context)!.title),
          actions: [
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    selectLanguage = newValue!;
                    _changeLanguage(context, selectLanguage);
                  });
                },
                items: supportLanguages.map<DropdownMenuItem<String>>((LanguageInfo info) {
                  return DropdownMenuItem<String>(
                    value: info.key,
                    child: Row(children: [
                      Image.asset(info.iconName),
                      const SizedBox(width: 8),
                      Text(info.label),
                    ]),
                  );
                }).toList(),
              ),
            ),
          ],
        ));
      }),
    );
  }
}
