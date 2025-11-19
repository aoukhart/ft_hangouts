import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ft_hangouts/Datasource/DataHelper.dart';
import 'package:ft_hangouts/l10n/app_localizations.dart';
import 'package:ft_hangouts/main.dart';
import 'package:ft_hangouts/model%20/Contact.dart';
import 'package:ft_hangouts/views/Chat/ChatPage.dart';
import 'package:ft_hangouts/views/Chat/Utils/UserInfoDialog.dart';
import 'package:ft_hangouts/views/Home/Utils/ContactAddDialog.dart';
import 'package:ft_hangouts/views/Home/Utils/HomePageContactTile.dart';
import 'package:lottie/lottie.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.db, required this.setLocale});
  final Database db;
  final Function(String) setLocale;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Color headerColor = Colors.yellow;
  List<User> Users = [];
  bool isClicked = false;
  int contactIndex = -1;
  DateTime? lastBackgrounded;

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
      // print(" >>>>>>>>>>> GETTING USERS <<<<<<<<<<<<");
      if (userTmp.isEmpty) return;
      Users = userTmp;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    DataHelper.telephony.listenIncomingSms(
      onNewMessage: (message) {
        // print("Message received in main page ${message.body}\n");
        setState(() {
          final index = Users.indexOf(
            Users.where((element) => element.phone == message.address).first,
          );
          updateUser(index, message);
          Users.sort((a, b) {
            return b.time.compareTo(a.time);
          });
        });
        // print(">>>>> DONE ${mounted} <<<<<");
      },
      onBackgroundMessage: backgrounMessageHandler,
    );
    _getUsers();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String _formatTime() {
    final diff = DateTime.now().difference(lastBackgrounded!);
    // seconds > if less than a minute
    // minutes seconds > if less than a hour
    // hour minutes > if less than a day
    //
    if (diff.inSeconds < 60) {
      return "${diff.inSeconds} ${AppLocalizations.of(context)!.seconds}";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} minutes ${diff.inSeconds % 60} ${AppLocalizations.of(context)!.seconds}";
    } else {
      return "${diff.inHours} ${AppLocalizations.of(context)!.hours} ${diff.inMinutes % 60} minutes";
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      lastBackgrounded = DateTime.now();
    }
    if (state == AppLifecycleState.resumed && lastBackgrounded != null) {
      //toast
      // print("Toastaaaa Last time app backgrounded ${_formatTime()}");
      Fluttertoast.showToast(
        msg:
            "${AppLocalizations.of(context)!.lastTimeBackgroundMsg} ${_formatTime()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future updateUser(int index, SmsMessage msg) async {
    Users[index].time = msg.date!;
    Users[index].newMsg = true;
    await DataHelper.setTime(Users[index]);
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
              child: Users.length == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 30,
                              right: 30,
                              top: 10,
                              bottom: 35,
                            ),
                            child: Lottie.asset("assets/EmptyState.json"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: Text(
                              textAlign: TextAlign.center,
                              AppLocalizations.of(context)!.noContactText,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
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
                                  value: 'delete',
                                  onTap: () {},
                                  child: Text(
                                    AppLocalizations.of(context)!.deleteContact,
                                  ),
                                ),
                              ],
                            );
                            if (res == 'delete') {
                              print("deleting $res $index");
                              if (await DataHelper.delete(Users[index].id!) ==
                                  1) {
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
