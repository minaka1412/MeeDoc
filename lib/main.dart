import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meedoc/language.dart';
import 'package:meedoc/restart_page.dart';
import 'package:meedoc/start_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _MainPage());
}

class _MainPage extends StatefulWidget {
  const _MainPage({super.key});

  @override
  State<_MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
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
      setLocale(const Locale(defaultLanguage));
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
    String title = "MeeDoc";
    ThemeData theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    );

    Builder builder = Builder(builder: (context) {
      Color backgroundColor = Theme.of(context).colorScheme.inversePrimary;
      Text titleText = Text(AppLocalizations.of(context)!.title);

      onChangedDropdown(String? newValue) {
        setState(() {
          selectLanguage = newValue!;
          _changeLanguage(context, selectLanguage);
        });
      }

      AppBar appBar = AppBar(backgroundColor: backgroundColor, title: titleText, actions: [
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectLanguage,
            onChanged: onChangedDropdown,
            items: supportLanguageMenuItems,
          ),
        ),
      ]);

      final pageTab = <Tab>[
        Tab(text: AppLocalizations.of(context)!.tab_start, icon: const Icon(Icons.login)),
        Tab(text: AppLocalizations.of(context)!.tab_restart, icon: const Icon(Icons.refresh)),
      ];

      return Scaffold(
        appBar: appBar,
        body: DefaultTabController(
          length: pageTab.length,
          child: Scaffold(
            appBar: TabBar(
              tabs: pageTab,
            ),
            body: const TabBarView(children: <Widget>[
              StartPage(),
              RestartPage(),
            ]),
          ),
        ),
      );
    });

    return MaterialApp(
      title: title,
      theme: theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: builder,
    );
  }
}
