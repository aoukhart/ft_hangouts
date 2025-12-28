import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ft_hangouts/views/Home/HomePage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ft_hangouts/Datasource/DataHelper.dart';
import 'package:ft_hangouts/Datasource/NotifService.dart';
import 'package:ft_hangouts/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'model /Contact.dart';

@pragma('vm:entry-point')
backgrounMessageHandler(SmsMessage message) {
  print(message.address);
  // DataHelper.getUsers().then((value) {
  // if (value == null) return;
  // value.forEach((e) {
  // User.fromMap(e).phone == message.address
  // ?
  // {
  Notifservice().showNotification(message);
  // }
  // : null;
  // });
  // });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Notifservice().initNotifs();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  setLocale(String language) {
    setState(() {
      _locale = Locale(language);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: [Locale("en"), Locale("fr")],
      home: SplashScreen(setLocale: setLocale, ctxt: context),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.setLocale, required this.ctxt});
  final Function(String) setLocale;
  final BuildContext ctxt;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Database db;

  @override
  void initState() {
    super.initState();
    _initDb();
    _initTelephony();
    print("DONE INIT >>>>>>>>>>>>>");
  }

  void _initTelephony() async {
    try {
      final bool? res = await DataHelper.initTelephony();
      if (res == null || res == false) {
        await Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          msg: AppLocalizations.of(context)!.telephonyInitErrorMsg,
        );
      }
    } on PlatformException catch (e) {
      print("BOOOOOOOOOOM2   " + e.message!);
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        msg: AppLocalizations.of(context)!.telephonyInitErrorMsg,
      );
    }
  }

  void _initDb() async {
    db = await DataHelper.db;
    await Future.delayed(Duration(seconds: 1, microseconds: 800));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(db: db, setLocale: widget.setLocale),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image(image: AssetImage("assets/appLogoSmall.png"))),
    );
  }
}
