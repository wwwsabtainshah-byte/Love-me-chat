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
      home: const UserSimpleProfileScreen(),
    );
  }
}

class UserSimpleProfileScreen extends StatefulWidget {
  const UserSimpleProfileScreen({super.key});

  @override
  State<UserSimpleProfileScreen> createState() => _UserSimpleProfileScreenState();
}

class _UserSimpleProfileScreenState extends State<UserSimpleProfileScreen> {
  String linkedAgencyId = "Not Linked Yet";
  
  // 📊 CORRECTED BUSINESS METRICS (Super Admin Target adds to Manager Account)
  double currentSuperAdminEarned = 0;
  double currentManagerProgress = 0;
  
  final double superAdminTargetLimit = 100000000; // 100M Target
  final double managerSalaryTargetLimit = 500000000; // 500M Target

  void _simulateSuperAdminEarning() {
    setState(() {
      // سپر ایڈمن کا پہلا ٹارگٹ 100M مکمل ہوا
      currentSuperAdminEarned = 100000000; 
      
      // 🚀 لاجک درستگی: سپر ایڈمن کا کمایا ہوا 10M ڈائمنڈز اب مینیجر کے اکاؤنٹ میں ایڈ ہوگا
      currentManagerProgress += 10000000; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lovely Chat Portal', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A0033),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 👤 USER PROFILE CARD
            Card(
              color: const Color(0xFF250044),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFFFFD700), child: Icon(Icons.person, color: Colors.black)),
                title: const Text('User ID: LC-381992', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Password: •••••••• (Google Login Active)', style: TextStyle(color: Colors.white60)),
              ),
            ),
            const SizedBox(height: 20),

            const Text('--- Management Dashboard ---', style: TextStyle(color: Color(0xFFFFD700), fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            // 👑 SUPER ADMIN CARD
            Card(
              color: const Color(0xFF1A0033),
              shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xFFFFD700)), borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('👑 Super Admin Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Earned Target: ${(currentSuperAdminEarned / 1000000).toStringAsFixed(0)}M / 100M', style: const TextStyle(color: Colors.white70)),
                    Text(currentSuperAdminEarned >= superAdminTargetLimit ? "10M Diamonds pushed to Manager! ✅" : "10M Diamonds locked", style: const TextStyle(color: Color(0xFFFFD700), fontSize: 13)),
                  ],
                ),
              ),
            ),

            // 💼 MANAGER CARD (RECEIVES VOLUME)
            Card(
              color: const Color(0xFF1A0033),
              shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.purple), borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💼 Manager Account Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Total Progress (Including Admin Push): ${(currentManagerProgress / 1000000).toStringAsFixed(0)}M / 500M', style: const TextStyle(color: Colors.white70)),
                    Text('Salary Status: ${currentManagerProgress >= managerSalaryTargetLimit ? "100M Salary Unlocked! 💰" : "Salary Locked (Requires 500M total)"}', style: const TextStyle(color: Colors.green, fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🏢 HOST CENTER CONTROL
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
              onPressed: () => _showHostCenterDialog(),
              child: const Text('Open Host Center', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 5),
            Center(child: Text('Linked Agency ID: $linkedAgencyId', style: TextStyle(color: linkedAgencyId.contains("Not") ? Colors.red : Colors.green, fontWeight: FontWeight.bold))),
            
            const SizedBox(height: 30),
            // سیمولیشن بٹن (ٹیسٹ کرنے کے لیے کہ ایڈمن کا ڈیٹا مینیجر میں جاتا ہے)
            ElevatedButton(
              onPressed: _simulateSuperAdminEarning,
              child: const Text('Simulate Admin 100M Target (Push 10M to Manager)'),
            )
          ],
        ),
      ),
    );
  }

  void _showHostCenterDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF250044),
        title: const Text('Enter Agency Owner ID', style: TextStyle(color: Color(0xFFFFD700))),
        content: TextField(controller: controller, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(child: const Text('Join', style: TextStyle(color: Color(0xFFFFD700))), onPressed: () {
            if (controller.text.isNotEmpty) {
              setState(() {
                linkedAgencyId = controller.text;
              });
              Navigator.pop(context);
            }
          })
        ],
      ),
    );
  }
}
