import 'package:flutter/material.dart';

const profileBackground = Color(0xFF000000);
const profileText = Color(0xFFFFFFFF);
const profileMutedText = Color(0xFFA4A4AE);
const profileDivider = Color(0xFF242638);
const profilePurple = Color(0xFF7C3AED);
const profileBlue = Color(0xFF0D72FF);
const profileRed = Color(0xFFFF1E3C);
const profileInput = Color(0xFF252736);

class ProfileScaffold extends StatelessWidget {
  const ProfileScaffold({
    required this.title,
    required this.child,
    this.trailing,
    this.scrollable = true,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileHeader(title: title, trailing: trailing),
          const SizedBox(height: 34),
          child,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: profileBackground,
      body: SafeArea(
        child: scrollable ? SingleChildScrollView(child: content) : content,
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.title, this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ProfileRoundButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.maybePop(context),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: profileText,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (trailing != null)
            Align(alignment: Alignment.centerRight, child: trailing),
        ],
      ),
    );
  }
}

class ProfileRoundButton extends StatelessWidget {
  const ProfileRoundButton({
    required this.icon,
    required this.onTap,
    this.color = profilePurple,
    this.iconColor = profileText,
    this.borderColor,
    super.key,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color iconColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: borderColor == null
              ? null
              : Border.all(color: borderColor!, width: 2),
        ),
        child: Icon(icon, color: iconColor, size: 26),
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({this.radius = 70, this.imageUrl = '', super.key});

  final double radius;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF202020),
      backgroundImage: imageUrl.isEmpty ? null : NetworkImage(imageUrl),
      child: imageUrl.isEmpty
          ? Icon(
              Icons.person_rounded,
              color: Colors.white.withValues(alpha: 0.12),
              size: radius,
            )
          : null,
    );
  }
}

class ProfileMenuRow extends StatelessWidget {
  const ProfileMenuRow({
    required this.title,
    required this.onTap,
    this.icon,
    this.value,
    this.badge,
    this.showChevron = true,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final IconData? icon;
  final String? value;
  final int? badge;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: profileDivider)),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: profileMutedText, size: 28),
              const SizedBox(width: 22),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: profileText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: const TextStyle(
                  color: profileMutedText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (badge != null)
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: profileRed,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badge.toString(),
                  style: const TextStyle(
                    color: profileText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (showChevron) ...[
              const SizedBox(width: 18),
              const Icon(
                Icons.chevron_right_rounded,
                color: profileMutedText,
                size: 36,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String languageLabel(String code) {
  return switch (code) {
    'pt-BR' => 'Português',
    'en-AU' => 'Austrália',
    'fr-FR' => 'Francês',
    'es-ES' => 'Espanhol',
    'hy-AM' => 'América',
    'vi-VN' => 'Vietnã',
    _ => 'Português',
  };
}
