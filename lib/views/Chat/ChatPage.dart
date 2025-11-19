import 'package:another_telephony/telephony.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:ft_hangouts/Datasource/DataHelper.dart';
import 'package:ft_hangouts/model%20/Contact.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataHelper.getMessages(widget.user),
      builder: (context, snapshot) {
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
