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

class MyAppState extends State<MyApp> {
  final String languageSettingsKey = "languageCode";

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
      setLocale(const Locale("ja"));
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
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(AppLocalizations.of(context)!.title),
          ),

          body: Center(child:
          DropdownButton(
            items: const[
              DropdownMenuItem(
                value: 'あ',
                child: Text('あ'),
              ),
              DropdownMenuItem(
                  value: 'い',
                  child: Text('い'),
              ),
              DropdownMenuItem(
                  value: 'う',
                  child: Text('う'),
              ),
              DropdownMenuItem(
                  value: 'え',
                  child: Text('え'),
              ),
              DropdownMenuItem(
                  value: 'お',
                  child: Text('お'),
              ),
            ],
            value: isSelectedValue,
            onChanged: (String? value) {
              setState(() {
                isSelectedValue = value!;
              });
          )
            },
        );
      }),
    );
  }
}
