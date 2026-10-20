import 'package:flutter/material.dart';

// 👑 SUPER ADMIN PANEL
class SuperAdminPanel extends StatelessWidget {
  final double totalBdProfit = 45000000; // فرض کریں ابھی 45M منافع ہو چکا ہے
  final double targetLimit = 100000000; // 100M Target

  const SuperAdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    double progress = totalBdProfit / targetLimit;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin Control', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A0033),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // کارڈ برائے مجموعی منافع
            Card(
              color: const Color(0xFF250044),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Color(0xFFFFD700), width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('BD Profit Count (Target Metrics)', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('${(totalBdProfit / 1000000).toStringAsFixed(0)}M / ${(targetLimit / 1000000).toStringAsFixed(0)}M', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.purple.shade900,
                      color: const Color(0xFFFFD700),
                      minHeight: 10,
                    ),
                    const SizedBox(height: 10),
                    Text('Progress: ${(progress * 100).toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // بمپر ریوارڈ اسٹیٹس
            Card(
              color: const Color(0xFF250044),
              child: ListTile(
                leading: const Icon(Icons.workspace_premium, color: Color(0xFFFFD700), size: 40),
                title: const Text('Bumper Reward Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(totalBdProfit >= targetLimit ? 'Unlocked: 25M Premium Reward Ready!' : 'Locked: Need ${(targetLimit - totalBdProfit) / 1000000}M more profit to unlock 25M', style: const TextStyle(color: Colors.white70)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 💼 BD PANEL
class BdPanel extends StatelessWidget {
  final double currentGifting = 35000000; // فرض کریں بی ڈی کی گفٹنگ 35M ہو چکی ہے
  final double giftingTarget = 50000000; // 50M Target

  const BdPanel({super.key});

  @override
  Widget build(BuildContext context) {
    double progress = currentGifting / giftingTarget;
    double currentProfit = currentGifting >= giftingTarget ? 5000000 : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BD Target Tracker', style: TextStyle(color: Color(0xFFFFD700))),
        backgroundColor: const Color(0xFF1A0033),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: const Color(0xFF250044),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Your Current Gifting Volume', style: TextStyle(color: Colors.white70)),
                    Text('${(currentGifting / 1000000).toStringAsFixed(1)}M / 50M', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(value: progress, color: Colors.purple, backgroundColor: Colors.white12),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              color: const Color(0xFF250044),
              child: ListTile(
                leading: const Icon(Icons.monetization_on, color: Colors.green),
                title: const Text('Your Unlocked Profit', style: TextStyle(color: Colors.white)),
                trailing: Text('${(currentProfit / 1000000).toStringAsFixed(0)}M', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
