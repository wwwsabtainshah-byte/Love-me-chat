import 'package:flutter/foundation.dart';

/// Lovely Chat App - Profit & Target System Logic
class TargetCalculator {
  // بنیادی کانسٹنٹس اور لمیٹس
  static const double bdGiftingTarget = 50000000; // 50M Gifting Volume
  static const double bdProfitReward = 5000000;   // 5M Profit for BD
  static const double superAdminTargetLimit = 100000000; // 100M Profit Target
  static const double superAdminBumperReward = 25000000; // 25M Reward

  // لائیو ڈیٹا ٹریک کرنے کے لیے ویری ایبلز
  double currentBdGiftingVolume = 0;
  double totalBdProfitsEarned = 0; // یہ سپر ایڈمن کے اکاؤنٹ میں کاؤنٹ ہوگا
  bool isSuperAdminRewardUnlocked = false;

  /// جب ایپ میں گفٹنگ ہوگی تو یہ فنکشن چلے گا
  void addGiftingVolume(double volume) {
    currentBdGiftingVolume += volume;
    _calculateProfits();
  }

  /// بی ڈی کے منافع اور سپر ایڈمن کے ٹارگٹ کی خودکار کیلکولیشن
  void _calculateProfits() {
    // چیک کریں کہ بی ڈی نے 50M کا ٹارگٹ کتنی بار مکمل کیا ہے
    if (currentBdGiftingVolume >= bdGiftingTarget) {
      int completedCycles = (currentBdGiftingVolume / bdGiftingTarget).floor();
      
      // ہر سائیکل پر 5M منافع سپر ایڈمن کے اکاؤنٹ میں پش ہوگا
      totalBdProfitsEarned = completedCycles * bdProfitReward;

      // اگر مجموعی منافع 100M یا اس سے زیادہ ہو جائے تو سپر ایڈمن کا ریوارڈ انلاک ہوگا
      if (totalBdProfitsEarned >= superAdminTargetLimit) {
        isSuperAdminRewardUnlocked = true;
      } else {
        isSuperAdminRewardUnlocked = false;
      }
    }
  }

  /// لائیو پروگریس رپورٹ دیکھنے کے لیے (پرسنٹائل میں)
  double getSuperAdminProgressPercentage() {
    if (totalBdProfitsEarned >= superAdminTargetLimit) return 100.0;
    return (totalBdProfitsEarned / superAdminTargetLimit) * 100;
  }
}
