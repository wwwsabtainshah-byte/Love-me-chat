import 'package:flutter/material.dart';

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
                Navigator.push(context, MaterialPageRoute(builder: (_) => const UserRegistrationScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserRegistrationScreen extends StatelessWidget {
  const UserRegistrationScreen({super.key});

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
            const TextField(decoration: InputDecoration(labelText: 'Nickname', labelStyle: TextStyle(color: Colors.white70))),
            const SizedBox(height: 15),
            const TextField(decoration: InputDecoration(labelText: 'Birthday (YYYY/MM/DD)', labelStyle: TextStyle(color: Colors.white70))),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), minimumSize: const Size(double.infinity, 50)),
              child: const Text('Next', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}

// 📱 2. MAIN BOTTOM NAVIGATION (4 Butons: Live, Party, Moments, Me)
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
      const Center(child: Text('Live Videos (TikTok Style)', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Party Audio Rooms', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Moments Stream', style: TextStyle(color: Colors.white))),
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

// 👤 3. AWAN STYLE ME TAB
class MeProfileTabScreen extends StatelessWidget {
  final String agencyId;
  final Function(String) onAgencyLinked;

  const MeProfileTabScreen({super.key, required this.agencyId, required this.onAgencyLinked});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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
            TextButton(child: const Text('Join', style: TextStyle(color: Color(0xFFFFD700))), onPressed: () {
              if (controller.text.isNotEmpty) {
                onAgencyLinked(controller.text);
                Navigator.pop(context);
              }
            })
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
