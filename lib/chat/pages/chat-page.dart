import 'dart:convert';

import 'package:finflex/api/chat-api.dart';
import 'package:finflex/chat/dto/message-dto.dart';
import 'package:finflex/handles/button-widgets/primary-button.dart';
import 'package:finflex/handles/data-widgets/profile-data-widget.dart';
import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:finflex/styles/button-styles.dart';
import 'package:finflex/styles/colors.dart';
import 'package:finflex/styles/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  _chatState createState() => _chatState();
}

class _chatState extends State<ChatBotPage> {
  List<MessageDTO> messagesList = [];

  Future<List<MessageDTO>> loadChatHistory(ProfileData profileData) async {
    var userId = profileData.userId!;
    var token = profileData.token!;

    var request = await ChatApiService.GetChatHistory(userId, token);
    List<dynamic> rawMessagesList = json.decode(request.body);
    List<MessageDTO> messagesList = [];
    for (int i = 0; i < rawMessagesList.length; i++) {
      messagesList.add(MessageDTO.fromJson(rawMessagesList[i]));
    }

    return messagesList;
  }

  void updateMessagesHandler(MessageDTO newMessage){
    setState(() {
      messagesList.add(newMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: messagesList.isEmpty ? loadChatHistory(AppProcessDataProvider.of(context)!.profileData) : Future.value(messagesList),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Ошибка ${snapshot.error}');
          } else {
            messagesList = snapshot.data!;
            return Column(children: [
              Expanded(
              //     child: GroupedListView<MessageDTO, DateTime>(
              //       reverse: true,
              //       order: GroupedListOrder.DESC,
              //       itemBuilder: (context, message) {
              //       return Column(
              //       children: [
              //         const SizedBox(height: 20),
              //         Align(
              //             alignment: message.isReply
              //                 ? Alignment.centerLeft
              //                 : Alignment.centerRight,
              //             child: MessageWidget(messageData: message))
              //       ],
              //     );
              //   },
              //   elements: messagesList,
              //   groupBy: (message) => DateTime(
              //       message.date.year),
              //   groupHeaderBuilder: (MessageDTO message) =>
              //       MessageDateGroup(date: message.date),
              // )
              child: Scrollbar(
                thumbVisibility: true,
                interactive: true,
                thickness: 10,
                radius: Radius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index){
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          Align(
                              alignment: messagesList[messagesList.length - index - 1].isReply
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: MessageWidget(messageData: messagesList[messagesList.length - index - 1]))
                        ],
                      );
                    }
                  ),
                ),
              )
              ),
              SizedBox(height: 20),
              MessageInputsWidget(chatCallback: updateMessagesHandler)
            ]);
          }
        });
  }
}

class MessageInputsWidget extends StatefulWidget {
  final Function(MessageDTO) chatCallback;

  const MessageInputsWidget({super.key, required this.chatCallback});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _messageInputsState(chatCallback: chatCallback);
}

class _messageInputsState extends State<MessageInputsWidget> {
  final TextEditingController _controller = TextEditingController(text: '');
  final Function(MessageDTO) _chatCallback;

  _messageInputsState({required Function(MessageDTO) chatCallback}) : _chatCallback = chatCallback;

  Future<MessageDTO> sendMessage(String message, ProfileData profileData) async {
    var userId = profileData.userId!;
    var token = profileData.token!;

    var request = await ChatApiService.SendMessage(message, userId, token);
    var messageDTO = MessageDTO.fromJson(json.decode(request.body));
    return messageDTO;
  }

  void sendMessageInvoker() async {
    _chatCallback(MessageDTO(date: DateTime.now(), message: _controller.text, isReply: false));
    var result = await sendMessage(_controller.text, AppProcessDataProvider.of(context)!.profileData);
    _controller.text = '';
    _chatCallback(result);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: Theme.of(context).textTheme.labelLarge,
              controller: _controller,
              decoration: CustomDecorations.MainInputDecoration('Напишите сообщение...')
              ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            style: ButtonStyles.mainButtonStyle,
            onPressed: sendMessageInvoker,
            child: Image.asset('assets/icons/bot-nav-icon.png'))
        ],
      ),
    );
  }
}

class MessageDateGroup extends StatelessWidget {
  final DateTime date;

  const MessageDateGroup({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const ShapeDecoration(
              color: ColorStyles.messageGroupColor,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)))),
          child: Text(DateFormat.yMMMd().format(date),
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final MessageDTO messageData;

  const MessageWidget({super.key, required this.messageData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: ShapeDecoration(
          color: messageData.isReply
              ? ColorStyles.userMessageColor
              : ColorStyles.botMessageColor,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(40),
                  topRight: const Radius.circular(40),
                  bottomLeft: messageData.isReply
                      ? const Radius.circular(5)
                      : const Radius.circular(40),
                  bottomRight: messageData.isReply
                      ? const Radius.circular(40)
                      : const Radius.circular(5)))),
      child: Column(
          crossAxisAlignment: messageData.isReply
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Text(messageData.message,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 5),
            Text(DateFormat('E, HH:mm').format(messageData.date),
                style: Theme.of(context).textTheme.bodySmall)
          ]),
    );
  }
}
