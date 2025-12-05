import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Message> _messages = [
    const AssistantMessage("Hello! How can I help you today?"),
  ];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _waitingForResponse = false;
  StreamAssistantMessage? currentStreamMessage;

  void _sendMessage(String message) {
    if (message.trim().isEmpty) {
      return;
    }
    setState(() {
      _waitingForResponse = true;
      _messages.add(UserMessage(message));

      currentStreamMessage = StreamAssistantMessage(message, (result) {
        setState(() {
          _messages.remove(currentStreamMessage);
          _messages.add(AssistantMessage(result));
          _waitingForResponse = false;
        });
      }, "");
      _messages.add(currentStreamMessage!);
    });
    _textController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assistant Client")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/auth/profile');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse:
                  false, // Set to true if you want messages to appear from the bottom up
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          const Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: !_waitingForResponse,
              controller: _textController,
              focusNode: _focusNode,
              onSubmitted: (value) {
                _sendMessage(value);
                _focusNode.requestFocus();
              },
              decoration: const InputDecoration.collapsed(
                hintText: "Send a message",
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _sendMessage(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

abstract class Message extends StatelessWidget {
  final String message;

  const Message(this.message, {super.key});
}

class AssistantMessage extends Message {
  const AssistantMessage(super.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: const CircleAvatar(
              child: Text("A"),
            ), // Placeholder for assistant avatar
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Assistant",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(message),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserMessage extends Message {
  const UserMessage(super.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.end, // Align to the end for user messages
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text("You", style: Theme.of(context).textTheme.titleSmall),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(message),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: const CircleAvatar(
              child: Text("U"),
            ), // Placeholder for user avatar
          ),
        ],
      ),
    );
  }
}

class StreamAssistantMessage extends Message {
  final String userPrompt;
  final Function(String result) onFinish;
  const StreamAssistantMessage(
    this.userPrompt,
    this.onFinish,
    super.message, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: const CircleAvatar(
              child: Text("A"),
            ), // Placeholder for assistant avatar
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Assistant",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: AssistantStreamText(userPrompt, onFinish),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum ChatStatus { waiting, processing, finish }

class AssistantStreamText extends StatefulWidget {
  final String userPrompt;
  final Function(String result) onFinish;
  const AssistantStreamText(this.userPrompt, this.onFinish, {super.key});

  @override
  State<StatefulWidget> createState() => _AssistantStreamTextState();
}

class _AssistantStreamTextState extends State<AssistantStreamText> {
  _AssistantStreamTextState();

  String message = "";
  WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse("ws://127.0.0.1:8000/api/llm/ws/chat"),
  );
  ChatStatus status = ChatStatus.waiting;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: channel.stream,
      initialData: jsonEncode({
        "model": "Qwen3-0.6b",
        "user_prompt": widget.userPrompt,
        "chat_session_id": null,
      }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            "Error ${snapshot.data}",
            style: Theme.of(context).textTheme.titleSmall,
          );
        }

        var response = jsonDecode(snapshot.data as String);
        // String sessionId = response['chat_session_id'];
        String type = response['type'];

        switch (type) {
          case "error":
            String errorMessage = response["response_chunk"];
            return Text(
              errorMessage,
              style: Theme.of(context).textTheme.titleSmall,
            );
          case "message":
            String normalMessage = response["response_chunk"];
            return Text(
              normalMessage,
              style: Theme.of(context).textTheme.titleSmall,
            );
          case "chunk":
            String chunk = response["response_chunk"];
            message = message + chunk;
            return Text(message, style: Theme.of(context).textTheme.titleSmall);
          case "finish":
            var finisihMessage = "Done: $message";
            widget.onFinish(message);
            return Text(
              finisihMessage,
              style: Theme.of(context).textTheme.titleSmall,
            );
          default:
            debugPrint(response);
            return Text(
              "unknown $type error",
              style: Theme.of(context).textTheme.titleSmall,
            );
        }
      },
    );
  }
}
