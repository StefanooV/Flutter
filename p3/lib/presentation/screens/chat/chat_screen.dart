import 'package:flutter/material.dart';
import 'package:p3/domain/entitites/message.dart';
import 'package:p3/presentation/providers/chat_provider.dart';
import 'package:p3/presentation/widgets/chat/her_message_bubble.dart';
import 'package:p3/presentation/widgets/chat/my_message_bubble.dart';
import 'package:p3/presentation/widgets/shared/message_field_box.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqjCk24yQP4yhUMFhFfcXZb_X_w0qAQJ2gnA&s'),
          ),
        ),
        title: const Text('❤ Angie ❤'),
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  controller: chatProvider.chatScrollController,
                  itemCount: chatProvider.messageList.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messageList[index];

                    return (message.fromWho == FromWho.her)
                        ? HerMessageBubble(message: message)
                        : MyMessageBubble(message: message);
                  }),
            ),
            MessageFieldBox(
              onValue: (value) => chatProvider.sendMessage(value),
            ),
          ],
        ),
      ),
    );
  }
}
