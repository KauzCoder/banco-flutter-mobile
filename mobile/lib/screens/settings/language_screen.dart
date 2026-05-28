import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'Português';

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'name': 'Português', 'flag': '🇧🇷'},
      {'name': 'English', 'flag': '🇺🇸'},
      {'name': 'Español', 'flag': '🇪🇸'},
      {'name': 'Français', 'flag': '🇫🇷'},
      {'name': 'Deutsch', 'flag': '🇩🇪'},
      {'name': '中文', 'flag': '🇨🇳'},
      {'name': '日本語', 'flag': '🇯🇵'},
      {'name': '한국어', 'flag': '🇰🇷'},
    ];

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: AppColors.darkText),
        ),
        title: const Text(
          'Idioma',
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          final isSelected = _selectedLanguage == language['name'];

          return GestureDetector(
            onTap: () {
              setState(() => _selectedLanguage = language['name']!);
              final navigator = Navigator.of(context);
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  navigator.pop();
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withAlpha((0.2 * 255).round()) : AppColors.darkBgSecondary,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.darkBorder,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        language['flag']!,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        language['name']!,
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : AppColors.darkText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (isSelected)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
