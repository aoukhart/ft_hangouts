import 'package:another_telephony/telephony.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:testing/Datasource/DataHelper.dart';
import 'package:testing/main.dart';
import 'package:testing/model%20/Contact.dart';
import 'package:testing/views/Home/HomePage.dart';

interface class Message {
  late String content;
  late bool sent;
  late int date;
}

class Chatpage extends StatefulWidget {
  Chatpage({super.key, required this.user});

  User user;
  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  late List<SmsMessage> messages;

  @override
  void initState() {
    super.initState();
    // DataHelper.telephony.listenIncomingSms(
    //   onNewMessage: (message) {
    //     if (!mounted) return;
    //     print('receiveed');

    //     if (message.address != widget.user.phone) return;
    //     setState(() {
    //       widget.user.time = message.date!;
    //       DataHelper.setTime(widget.user);
    //     });
    //   },
    //   listenInBackground: false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    // ChatUser user1 = ChatUser(
    //   id: widget.user.id.toString(),
    //   firstName: widget.user.name,
    // );
    return FutureBuilder(
      future: DataHelper.getMessages(widget.user),
      builder: (context, snapshot) {
        // print(snapshot.data)
        if (snapshot.hasData) {
          return DashChat(
            ctxt: context,
            typingUsers: [],
            currentUser: ChatUser(id: "Me"),
            messageOptions: MessageOptions(
              showTime: true,
              avatarBuilder: widget.user.image != null
                  ? (user1, onPressAvatar, onLongPressAvatar) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                        left: 5,
                        right: 8,
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: Image.memory(widget.user.image!).image,
                      ),
                    )
                  : null,
            ),
            onSend: (message) async {
              final time = await DataHelper.sendMsg(widget.user, message.text);
              setState(() {
                widget.user.time = time;
                snapshot.data!.add(
                  SmsMessage.fromMap(
                    {
                      "subject": widget.user.phone,
                      "body": message.text,
                      "date": time.toString(),
                    },
                    [SmsColumn.SUBJECT, SmsColumn.BODY, SmsColumn.DATE],
                  ),
                );
              });
            },
            messages: snapshot.data!.map((e) {
              // print(e.subject.toString());
              return e.address.toString() != 'null'
                  ? ChatMessage(
                      user: ChatUser(id: widget.user.id.toString()),
                      createdAt: DateTime.fromMillisecondsSinceEpoch(e.date!),
                      text: e.body!,
                    )
                  : ChatMessage(
                      user: ChatUser(id: "Me"),
                      createdAt: DateTime.fromMillisecondsSinceEpoch(e.date!),
                      text: e.body!,
                    );
            }).toList(),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
