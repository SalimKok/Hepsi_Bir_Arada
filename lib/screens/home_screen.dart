import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hesapyonetim/screens/login_screen.dart';
import 'package:hesapyonetim/services/message_service.dart';
import 'package:hesapyonetim/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  void _logout(BuildContext context) async {
    final authService = AuthService();
    await authService.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
    );
  }
  void connectInstagram() async {
    final Uri authUri = Uri.parse('http://127.0.0.1:5000/webhook');
    if (await canLaunchUrl(authUri)) {
      await launchUrl(authUri, mode: LaunchMode.externalApplication);
    } else {
      print('canLaunchUrl false döndü. Bağlantı açılamadı: $authUri');
    }
  }

  final MessageService _messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gelen Mesajlar'),
        centerTitle: true,
        backgroundColor:const Color.fromARGB(255, 245, 245, 220),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout(context);
              } else if (value == 'connect_instagram') {
                connectInstagram();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'connect_instagram',
                  child: Row(
                    children: [
                      Icon(Icons.link, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Instagram Bağla',style: TextStyle(color: Colors.blue),),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(color: const Color.fromARGB(255, 245, 245, 220),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _messageService.getMessages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Hiç mesaj yok.'));
            }

            final messages = snapshot.data!;

            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final sender = message['sender'] ?? '' ;
                final text = message['text'] ?? '';
                final type = message['type'] ?? '';
                final object = message['object'] ?? '';
                final timestamp = message['timestamp'] as Timestamp?;
                final timeText = timestamp != null
                    ? DateTime.fromMillisecondsSinceEpoch(
                    timestamp.millisecondsSinceEpoch)
                    .toLocal()
                    .toString()
                    : '';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 48.0),
                        child: ListTile(
                          title: Text(text),
                          subtitle: Text('From: $object'),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.info_outline, color: Colors.grey[700]),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('📨 Mesaj Detayı'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Gönderen: $sender'),
                                    SizedBox(height: 8),
                                    Text('Zaman: $timeText'),
                                    SizedBox(height: 8),
                                    Text('Tür: $type'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
