import 'package:flutter/material.dart';

void main() {
  runApp(const SaroChatApp());
}

class SaroChatApp extends StatelessWidget {
  const SaroChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saro Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const PhoneLoginScreen(),
    );
  }
}

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _continueToChat() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('እባክዎ የስልክ ቁጥር ያስገቡ')),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ChatHomeScreen(userPhone: phone)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saro Chat - መግቢያ')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_rounded, size: 72, color: Colors.teal),
            const SizedBox(height: 16),
            const Text(
              'በስልክ ቁጥርዎ ይግቡ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'ስልክ ቁጥር (ለምሳሌ +2519...)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _continueToChat,
                child: const Text('ቀጥል'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatHomeScreen extends StatefulWidget {
  final String userPhone;
  const ChatHomeScreen({super.key, required this.userPhone});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [
    'እንኳን ወደ Saro Chat በደህና መጡ!',
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(text);
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saro Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('የድምጽ ጥሪ ሞጁል (Agora) ገና ይገናኛል')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('የቪዲዮ ጥሪ ሞጁል (Agora) ገና ይገናኛል')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('ተመርጧል፦ $value')),
              );
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Block', child: Text('ብሎክ አድርግ (Block)')),
              PopupMenuItem(value: 'Report', child: Text('ሪፖርት አድርግ (Report)')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_messages[index]),
                    subtitle: Text('ከ፦ ${widget.userPhone}'),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'መልእክት ይጻፉ...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
