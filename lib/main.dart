import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 🌐 Termux Local Server Base URL (Updated to Wi-Fi IP)
const String baseUrl = "http://192.168.100.5:8000";

void main() {
  runApp(const LovelyChatApp());
}

class LovelyChatApp extends StatelessWidget {
  const LovelyChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lovely Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4B0082), // Royal Purple
        scaffoldBackgroundColor: const Color(0xFF120024), // Dark Purple BG
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4B0082),
          secondary: const Color(0xFFFFD700), // Gold
        ),
      ),
      home: const GoogleAuthScreen(),
    );
  }
}

// 🔐 1. GOOGLE REGISTRATION FLOW
class GoogleAuthScreen extends StatelessWidget {
  const GoogleAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, color: Color(0xFFFFD700), size: 100),
            const SizedBox(height: 10),
            const Text('Lovely Chat', style: TextStyle(color: Color(0xFFFFD700), fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 60),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red),
              label: const Text('Continue with Google', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () {
                // Google Auth Simulated Success -> Moving to Profile Registration
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (_) => const UserRegistrationScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  bool _isLoading = false;

  // 📡 Termux Server ko User Profile ka Data bhejney ka Function
  Future<void> _registerUserOnServer() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nickname': _nicknameController.text,
          'birthday': _dobController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Server connected: Profile saved successfully!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Server status: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connecting via Offline Mode (Termux error: $e)')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Profile'), backgroundColor: const Color(0xFF1A0033)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.camera_alt, size: 30)),
            const SizedBox(height: 20),
            TextField(
              controller: _nicknameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Nickname', labelStyle: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _dobController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Birthday (YYYY/MM/DD)', labelStyle: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), minimumSize: const Size(double.infinity, 50)),
              onPressed: _isLoading ? null : _registerUserOnServer,
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.black)
                : const Text('Next', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

// 📱 2. MAIN BOTTOM NAVIGATION (4 Buttons: Live, Party, Moments, Me)
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 3; // Default "Me" Panel Open
  String userLinkedAgency = "Not Linked Yet";

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const Center(child: Text('Live Videos (TikTok Style)', style: TextStyle(color: Colors.white, fontSize: 18))),
      const PartyVoiceRoomScreen(), // <-- 🎙️ Integrated Voice Party Room
      const Center(child: Text('Moments Stream', style: TextStyle(color: Colors.white, fontSize: 18))),
      MeProfileTabScreen(
        agencyId: userLinkedAgency,
        onAgencyLinked: (id) {
          setState(() {
            userLinkedAgency = id;
          });
        },
      ),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A0033),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white60,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Party'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Moments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

// 🎙️ 3. PARTY VOICE ROOM SCREEN (Multi-seat Audio Lounge)
class PartyVoiceRoomScreen extends StatefulWidget {
  const PartyVoiceRoomScreen({super.key});

  @override
  State<PartyVoiceRoomScreen> createState() => _PartyVoiceRoomScreenState();
}

class _PartyVoiceRoomScreenState extends State<PartyVoiceRoomScreen> {
  // Seats status: false means empty seat, true means occupied
  final List<bool> _seats = [true, false, false, false, false, false];
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16002b),
      appBar: AppBar(
        backgroundColor: const Color(0xFF250044),
        title: const Text('👑 Royal Voice Party Room', style: TextStyle(color: Color(0xFFFFD700))),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Welcome to Awan Style Voice Lounge!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Room Banner / Host Info
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2c0052),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFFFD700), width: 0.5),
            ),
            child: Row(
              children: const [
                CircleAvatar(backgroundColor: Color(0xFFFFD700), child: Icon(Icons.mic, color: Colors.black)),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shah G’s Audio Lounge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Room ID: 882201 • Online: 14', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          const Text('Mic Seats (Audio Grid)', style: TextStyle(color: Color(0xFFFFD700), fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          // 6 Audio Seats Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                bool isOccupied = _seats[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _seats[index] = !_seats[index];
                    });
                  },
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: isOccupied ? const Color(0xFFFFD700) : const Color(0xFF3b006b),
                            child: Icon(
                              isOccupied ? Icons.person : Icons.add,
                              color: isOccupied ? Colors.black : Colors.white38,
                              size: 30,
                            ),
                          ),
                          if (isOccupied && index == 0)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                child: const Icon(Icons.star, size: 12, color: Colors.white),
                              ),
                            )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        index == 0 ? 'Host (Shah G)' : (isOccupied ? 'Speaker $index' : 'Empty Seat'),
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const Spacer(),

          // Bottom Control Bar (Mute, Chat, Send Gift)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF250044),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(_isMuted ? Icons.mic_off : Icons.mic, color: _isMuted ? Colors.red : Color(0xFFFFD700)),
                  onPressed: () {
                    setState(() {
                      _isMuted = !_isMuted;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_isMuted ? 'Mic Muted' : 'Mic Unmuted')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.card_giftcard, color: Color(0xFFFFD700)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gift Gallery opened!')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  onPressed: () {
                    // Chat Sheet
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 👤 4. AWAN STYLE ME TAB
class MeProfileTabScreen extends StatelessWidget {
  final String agencyId;
  final Function(String) onAgencyLinked;

  const MeProfileTabScreen({super.key, required this.agencyId, required this.onAgencyLinked});

  // 📡 Termux Server par Agent / Agency ID link karne ka Function
  Future<void> _sendAgencyToServer(String id, BuildContext context) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/api/link-agency'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'agency_id': id}),
      );
    } catch (e) {
      print("Local Server offline, saved locally.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 20),
        const Card(
          color: Color(0xFF250044),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xFFFFD700), child: Icon(Icons.person, color: Colors.black)),
            title: Text('Shah G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text('ID: 1002370 • Level 15', style: TextStyle(color: Colors.white60)),
          ),
        ),
        const SizedBox(height: 15),
        _buildMenuTile(context, 'Wallet', Icons.account_balance_wallet),
        _buildMenuTile(context, 'Store (Frames & Locks)', Icons.store),
        
        // 🏢 HOST CENTER LOCK LOGIC
        Card(
          color: const Color(0xFF1A0033),
          shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xFFFFD700))),
          child: ListTile(
            leading: const Icon(Icons.campaign, color: Color(0xFFFFD700)),
            title: const Text('Host Center', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(agencyId.contains("Not") ? "Status: Inner Agent ID Mode" : "Agency ID: $agencyId", style: const TextStyle(color: Colors.white60)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
            onTap: () => _openHostCenterLogic(context),
          ),
        ),
        _buildMenuTile(context, 'BD Center (Salary Metrics)', Icons.business_center),
      ],
    );
  }

  void _openHostCenterLogic(BuildContext context) {
    if (agencyId.contains("Not")) {
      final controller = TextEditingController();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF250044),
          title: const Text('Enter Agent ID / Agency ID', style: TextStyle(color: Color(0xFFFFD700))),
          content: TextField(controller: controller, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Enter Agent ID to unlock")),
          actions: [
            TextButton(
              child: const Text('Join', style: TextStyle(color: Color(0xFFFFD700))), 
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onAgencyLinked(controller.text);
                  _sendAgencyToServer(controller.text, context);
                  Navigator.pop(context);
                }
              }
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Welcome to Host Portal under Agency: $agencyId')));
    }
  }

  Widget _buildMenuTile(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white30),
    );
  }
}
