import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _userMessage = TextEditingController();

  // Access the API key using dotenv.env
  // Make sure to add a null-check or provide a default if it might not be found

  late final GenerativeModel _model;
  late final ChatSession _chatSession; // For multi-turn conversations

  final List<Message> _messages = [];
  bool _isLoading = false; // To show loading indicator
  final ScrollController _scrollController = ScrollController(); // For auto-scrolling

  @override
  void initState() {
    super.initState();

      _model = GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: "AIzaSyDUX0rodyjVb1LTbSvoZMP-J84fvUvzYF0", // Use the non-nullable version after checking
      );
      _chatSession = _model.startChat(); // Start a new chat session
    
  }

  // ... rest of your ChatbotPage code (sendMessage, build, etc.)
  // Make sure to adapt the sendMessage function to use _chatSession.sendMessage
  // and include loading indicators and scroll to bottom as discussed previously.

  Future<void> sendMessage() async {
    final messageText = _userMessage.text.trim();
    if (messageText.isEmpty ) return; // Prevent sending if API key is missing

    _userMessage.clear();
    FocusScope.of(context).unfocus(); // Dismiss keyboard

    setState(() {
      _messages.add(Message(isUser: true, message: messageText, date: DateTime.now()));
      _isLoading = true; // Show loading indicator
    });

    _scrollToBottom();

    try {
      final response = await _chatSession.sendMessage(Content.text(messageText));

      setState(() {
        _messages.add(Message(
          isUser: false,
          message: response.text ?? "No response from Gemini.",
          date: DateTime.now(),
        ));
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(
          isUser: false,
          message: "Error: ${e.toString()}",
          date: DateTime.now(),
        ));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending message: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      _scrollToBottom();
    }
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

  @override
  void dispose() {
    _userMessage.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Messages(
                  isUser: message.isUser,
                  message: message.message,
                  date: DateFormat('HH:mm').format(message.date),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 15,
                  child: TextFormField(
                    controller: _userMessage,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepOrange),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      label: const Text("Ask Gemini..."),
                    ),
                    onFieldSubmitted: (value) => sendMessage(),
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: const EdgeInsets.all(15),
                  iconSize: 30,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(const CircleBorder()),
                  ),
                  onPressed: _isLoading ? null : sendMessage, // Disable if loading or no API key
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Your Message and Messages classes should be defined below or in separate files.
// For example:
class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isUser ? 100 : 10,
        right: isUser ? 10 : 100,
      ),
      decoration: BoxDecoration(
        color: isUser ? Colors.deepPurple : Colors.grey.shade200,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(30),
          bottomLeft: isUser ? const Radius.circular(30) : Radius.zero,
          topRight: const Radius.circular(30),
          bottomRight: isUser ? Radius.zero : const Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(color: isUser ? Colors.white : Colors.black),
          ),
          Text(
            date,
            style: TextStyle(color: isUser ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({
    required this.isUser,
    required this.message,
    required this.date,
  });
}