import 'package:flutter/material.dart';

class VoiceRoomSeatManager {
  int currentAllowedSeats = 10; // شروع میں صرف 10 سیٹیں اوپن ہوں گی
  final List<int> validTiers =;
  
  // ٹریکر: کونسی کپیسٹی پہلے سے ہی خریدی جا چکی ہے (صرف ایک بار کوائنز چارج کرنے کے لیے)
  final Map<int, bool> _unlockedTiers = {
    10: true,  // 10 سیٹیں ہمیشہ فری اور انلاک ہیں
    15: false,
    20: false,
    25: false,
    30: false,
  };

  /// روم مالک کے لیے اگلا پریمیم لیول (5 سیٹیں مزید) انلاک کرنے کا لاجک
  String unlockNextFiveSeats(int targetSeats, double userCoinsWallet) {
    if (!validTiers.contains(targetSeats)) {
      return "Invalid seat capacity option.";
    }

    if (targetSeats <= currentAllowedSeats) {
      return "This capacity is already available or lower than current.";
    }

    // اگر وہ لیول پہلے ہی خریدا جا چکا ہے تو بالکل فری سوئچ ہوگا
    if (_unlockedTiers[targetSeats] == true) {
      currentAllowedSeats = targetSeats;
      return "Switched to $targetSeats seats successfully! (Already unlocked)";
    }

    // اگر لاک ہے تو 1M کوائنز چارج ہوں گے (صرف ایک بار)
    if (userCoinsWallet >= 1000000) {
      _unlockedTiers[targetSeats] = true; // ہمیشہ کے لیے انلاک ہو گیا
      currentAllowedSeats = targetSeats;  // لائیو کپیسٹی بڑھ گئی
      return "Success: Unlocked up to $targetSeats seats for 1M Coins! (One-time charge)";
    } else {
      return "Error: You need 1M Coins to upgrade room to $targetSeats seats.";
    }
  }

  /// یہ چیک کرنے کے لیے کہ کونسی سیٹ لائیو روم میں نظر آئے گی
  bool isSeatVisible(int seatNumber) {
    return seatNumber <= currentAllowedSeats;
  }
}
