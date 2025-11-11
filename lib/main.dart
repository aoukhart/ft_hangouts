import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testing/Datasource/DataHelper.dart';
import 'package:testing/l10n/app_localizations.dart';
import 'package:testing/model%20/Contact.dart';
import 'package:testing/views/Contact/ChatPage.dart';
import 'package:testing/views/Contact/Utils/UserInfoDialog.dart';
import 'package:testing/views/Home/HomePage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:testing/views/Home/Utils/ContactAddDialog.dart';
import 'package:testing/views/Home/Utils/HomePageContactTile.dart';

@pragma('vm:entry-point')
backgrounMessageHandler(SmsMessage message) {
  // DataHelper.telephony.listenIncomingSms(
  // onNewMessage: (message) {
  print(message.body! + " <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
  // },
  // listenInBackground: false,
  // );
}

void main() {
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
      home: SplashScreen(setLocale: setLocale),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.setLocale});
  final Function(String) setLocale;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Database db;

  @override
  void initState() {
    super.initState();
    _initDb();
    DataHelper.initTelephony();
    // DataHelper.listenIncomingMsg();
  }

  void _initDb() async {
    db = await DataHelper.db;
    await Future.delayed(Duration(seconds: 1, microseconds: 800));
    print("<<<<<   DOOOOOONE  >>>>>");
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

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.db, required this.setLocale});
  final Database db;
  final Function(String) setLocale;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color headerColor = Colors.yellow;
  List<User> Users = [];
  bool isClicked = false;
  int contactIndex = -1;

  _getUsers() async {
    List<User> userTmp = [];
    await widget.db
        .query(
          'users',
          columns: ['id', 'name', 'phone', 'bio', 'time', 'image'],
          orderBy: 'time DESC',
        )
        .then((value) {
          if (value.isEmpty) return;
          value.forEach((element) {
            userTmp.add(User.fromMap(element));
          });
        });
    setState(() {
      print(" >>>>>>>>>>> GETTING USERS <<<<<<<<<<<<");
      if (userTmp.isEmpty) return;
      Users = userTmp;
    });
  }

  @override
  void initState() {
    super.initState();
    DataHelper.telephony.listenIncomingSms(
      onNewMessage: (message) {
        // if (isClicked) return;

        print("Message received in main page ${message.body}\n");
        setState(() {
          final index = Users.indexOf(
            Users.where((element) => element.phone == message.address).first,
          );
          updateUser(index, message);
          Users.sort((a, b) {
            return b.time.compareTo(a.time);
          });
        });
        print(">>>>> DONE ${mounted} <<<<<");
      },
      listenInBackground: false,
    );
    _getUsers();
  }

  Future updateUser(int index, SmsMessage msg) async {
    Users[index].time = msg.date!;
    Users[index].newMsg = true;
    await DataHelper.setTime(Users[index]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: !isClicked
          ? Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                    child: Container(),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        // repeat: ImageRepeat.repeatX,
                        image: AssetImage("assets/appLogo.png"),
                        fit: BoxFit.fitWidth,
                      ),
                      color: Colors.black,
                    ),
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.colorSwitch),
                    trailing: Switch(
                      value: headerColor == Colors.blue ? true : false,
                      onChanged: (value) {
                        if (value == true) {
                          setState(() {
                            headerColor = Colors.blue;
                          });
                        } else {
                          setState(() {
                            headerColor = Colors.yellow;
                          });
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.languageSwitch),
                    trailing: DropdownMenu(
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: "en", label: "EN🛢️🔫"),
                        DropdownMenuEntry(value: "fr", label: "FR🥐🥖"),
                      ],
                      width: 135,
                      initialSelection: AppLocalizations.of(
                        context,
                      )!.localeName,
                      onSelected: (value) {
                        setState(() {
                          widget.setLocale(value!);
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          : null,
      appBar: AppBar(
        backgroundColor: headerColor,
        title: isClicked
            ? TextButton(
                child: Text(
                  Users[contactIndex].name,
                  style: TextStyle(fontSize: 23, color: Colors.black),
                ),
                onPressed: () async {
                  final res = await UserInfoDialog(
                    Users[contactIndex],
                    context,
                  );
                  setState(() {
                    Users[contactIndex] = res;
                  });
                },
              )
            : Text("42 Chat app"),
        centerTitle: true,
        leading: !isClicked
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    isClicked = false;
                    Users[contactIndex].newMsg = false;
                    contactIndex = -1;
                    Users.sort((a, b) {
                      return b.time.compareTo(a.time);
                    });
                  });
                },
              ),

        actions: !isClicked
            ? [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () async {
                        final res = await ContactAddDialog(context, widget.db);
                        // setState(() {
                        if (res == null) return;
                        if (res > Users.length) _getUsers();
                        // });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.black),
                          Text(AppLocalizations.of(context)!.addContact),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.black),
                          Text(AppLocalizations.of(context)!.deleteAll),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
            : null,
      ),
      body: !isClicked
          ? Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ListView.separated(
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onLongPressStart: (details) async {
                      final res = await showMenu(
                        position: RelativeRect.fromLTRB(
                          details.globalPosition.dx,
                          details.globalPosition.dy,
                          details.globalPosition.dx,
                          details.globalPosition.dy,
                        ),
                        context: context,
                        items: [
                          PopupMenuItem(
                            child: Text("Delete"),
                            value: 'delete',
                            onTap: () {},
                          ),
                        ],
                      );
                      if (res == 'delete') {
                        print("deleting $res $index");
                        if (await DataHelper.delete(Users[index].id!) == 1) {
                          setState(() {
                            Users.removeAt(index);
                          });
                        }
                      }
                    },
                    onTap: () {
                      setState(() {
                        Users[index].newMsg = false;
                        isClicked = true;
                        contactIndex = index;
                      });
                      print(isClicked);
                    },
                    child: ContactTile(context, Users[index]),
                  ),
                ),
                separatorBuilder: (context, index) =>
                    Padding(padding: EdgeInsetsGeometry.all(7)),
                itemCount: Users.length,
              ),
            )
          : Chatpage(user: Users[contactIndex]),
    );
  }
}
