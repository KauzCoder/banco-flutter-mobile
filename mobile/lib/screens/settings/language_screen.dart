import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/controllers/profile_controller.dart';
import 'package:flutter_aplication_bank/screens/settings/settings_widgets.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final _searchController = TextEditingController();

  final List<_LanguageOption> _languages = const [
    _LanguageOption(code: 'pt-BR', label: 'Português', flag: '🇧🇷'),
    _LanguageOption(code: 'en-AU', label: 'Austrália', flag: '🇦🇺'),
    _LanguageOption(code: 'fr-FR', label: 'Francês', flag: '🇫🇷'),
    _LanguageOption(code: 'es-ES', label: 'Espanhol', flag: '🇪🇸'),
    _LanguageOption(code: 'hy-AM', label: 'América', flag: '🇦🇲'),
    _LanguageOption(code: 'vi-VN', label: 'Vietnã', flag: '🇻🇳'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<ProfileController>().loadProfileDataIfNeeded();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        final query = _searchController.text.toLowerCase();
        final filtered = _languages
            .where((language) => language.label.toLowerCase().contains(query))
            .toList();

        return ProfileScaffold(
          title: 'Idioma',
          child: Column(
            children: [
              if (controller.isLoading && controller.settings == null) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: CircularProgressIndicator(color: profileBlue),
                ),
              ] else ...[
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  cursorColor: profileBlue,
                  style: const TextStyle(color: profileText, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Pesquisar Idioma',
                    hintStyle: const TextStyle(
                      color: profileMutedText,
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: profileMutedText,
                      size: 32,
                    ),
                    filled: true,
                    fillColor: profileInput,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: profileBlue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 42),
                ...filtered.map(
                  (language) => _LanguageRow(
                    language: language,
                    isSelected: controller.settings?.idioma == language.code,
                    onTap: controller.isSubmitting
                        ? null
                        : () async {
                            await controller.updateLanguage(language.code);
                            if (context.mounted) {
                              Navigator.maybePop(context);
                            }
                          },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  final _LanguageOption language;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 96,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: profileDivider)),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.antiAlias,
              child: Text(language.flag, style: const TextStyle(fontSize: 44)),
            ),
            const SizedBox(width: 28),
            Expanded(
              child: Text(
                language.label,
                style: const TextStyle(
                  color: profileText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: profileBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: profileText,
                  size: 26,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({
    required this.code,
    required this.label,
    required this.flag,
  });

  final String code;
  final String label;
  final String flag;
}
