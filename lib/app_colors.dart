import 'package:flutter/material.dart';

/// SAB COMMON COLORS YAHIN SE AAYENGE.
/// Poore app me kahin bhi Colors.xxx hardcode nahi karna,
/// hamesha AppColors.xxx use karo — taaki design consistent rahe
/// aur future me sirf ek jagah se poora theme change ho jaye.
class AppColors {
  AppColors._();

  // ---- Brand / Header ----
  static const Color headerBlack = Color(0xFF1A1A1A);
  static const Color topBarBlack = Color(0xFF0D0D0D);
  static const Color brandOrange = Color(0xFFF15A24);

  // ---- Backgrounds ----
  static const Color bgLight = Color(0xFFE9EEF3); // page background
  static const Color bgWhite = Color(0xFFFFFFFF); // card background
  static const Color bgAdPlaceholder = Color(0xFFE3E8ED);

  // ---- Text ----
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF5A6572);
  static const Color textMuted = Color(0xFF8A94A0);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color linkBlue = Color(0xFF1A73E8);

  // ---- Borders / dividers ----
  static const Color borderLight = Color(0xFFDCE1E7);
  static const Color divider = Color(0xFFE0E4E9);

  // ---- Alert severity colors (reused everywhere alerts show) ----
  static const Color alertRed = Color(0xFFD32F2F);
  static const Color alertOrange = Color(0xFFF57C00);
  static const Color alertYellow = Color(0xFFF9A825);

  // ---- Misc ----
  static const Color chevronGray = Color(0xFF9AA4AF);
  static const Color adTagBg = Color(0xFFEDEFF2);

  // ---- Status labels (Fair / Poor / Good etc. — reused in Today & Hourly) ----
  static const Color statusGood = Color(0xFF2E7D32);
  static const Color statusFair = Color(0xFF2E7D32);
  static const Color statusPoor = Color(0xFFE65100);
}

/// Common text styles — reuse instead of redefining TextStyle everywhere.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle navLink = TextStyle(
    color: AppColors.textOnDark,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle tabLink = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const TextStyle sectionTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle cardTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle cardSubtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
  );

  static const TextStyle cardMuted = TextStyle(
    color: AppColors.textMuted,
    fontSize: 11,
  );

  static const TextStyle storyCategory = TextStyle(
    color: AppColors.brandOrange,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  static const TextStyle storyTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle footerHeading = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  static const TextStyle footerLink = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
  );
}