import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/widgets/headers/app_screen_header.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  String _selected = 'ler';
  CameraController? _cameraController;
  Future<void>? _cameraFuture;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    _cameraFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          setState(() => _cameraError = 'Camera indisponivel neste aparelho.');
        }
        return;
      }

      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _cameraError = null;
      });
    } on CameraException catch (error) {
      if (mounted) {
        setState(() {
          _cameraError = error.code == 'CameraAccessDenied'
              ? 'Permissao da camera negada.'
              : 'Nao foi possivel abrir a camera.';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _cameraError = 'Nao foi possivel abrir a camera.');
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            AppScreenHeader(
              title: 'Scanner',
              onBackPressed: () => Navigator.maybePop(context),
              trailing: AppHeaderIconButton(
                icon: Icons.image_outlined,
                backgroundColor: Colors.transparent,
                onTap: () {},
              ),
            ),
            Expanded(child: _buildCameraArea()),
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraArea() {
    return Stack(
      fit: StackFit.expand,
      children: [
        FutureBuilder<void>(
          future: _cameraFuture,
          builder: (context, snapshot) {
            final controller = _cameraController;
            if (controller != null && controller.value.isInitialized) {
              return ClipRect(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.previewSize!.height,
                    height: controller.value.previewSize!.width,
                    child: CameraPreview(controller),
                  ),
                ),
              );
            }

            return _buildCameraFallback(snapshot.connectionState);
          },
        ),
        Container(color: Colors.black.withValues(alpha: 0.18)),
        Center(child: _buildScanFrame()),
        Positioned(
          left: 24,
          right: 24,
          bottom: 18,
          child: Text(
            _cameraError ?? 'Posicione o QR Code dentro da moldura.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _cameraError == null ? Colors.white70 : Colors.redAccent,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraFallback(ConnectionState state) {
    if (_cameraError != null) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          _cameraError!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 15),
        ),
      );
    }

    return const ColoredBox(
      color: Colors.black,
      child: Center(
        child: CircularProgressIndicator(color: Color(0xFF813DFF)),
      ),
    );
  }

  Widget _buildScanFrame() {
    final size = 220.0;
    final cornerSize = 32.0;
    final cornerWidth = 3.5;
    final color = Colors.white;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: _buildCorner(
              color,
              cornerSize,
              cornerWidth,
              top: true,
              left: true,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _buildCorner(
              color,
              cornerSize,
              cornerWidth,
              top: true,
              left: false,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: _buildCorner(
              color,
              cornerSize,
              cornerWidth,
              top: false,
              left: true,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildCorner(
              color,
              cornerSize,
              cornerWidth,
              top: false,
              left: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(
    Color color,
    double size,
    double width, {
    required bool top,
    required bool left,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border(
          top: top ? BorderSide(color: color, width: width) : BorderSide.none,
          bottom: !top
              ? BorderSide(color: color, width: width)
              : BorderSide.none,
          left: left ? BorderSide(color: color, width: width) : BorderSide.none,
          right: !left
              ? BorderSide(color: color, width: width)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(10) : Radius.zero,
          topRight: top && !left ? const Radius.circular(10) : Radius.zero,
          bottomLeft: !top && left ? const Radius.circular(10) : Radius.zero,
          bottomRight: !top && !left ? const Radius.circular(10) : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    final isLer = _selected == 'ler';
    final isMeu = _selected == 'meucodigo';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.darkBgSecondary,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.darkBorder, width: 1),
        ),
        child: Row(
          children: [
            // Botão Ler
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _selected = 'ler'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 52,
                  decoration: BoxDecoration(
                    color: isLer ? AppColors.secondary : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Ler',
                    style: TextStyle(
                      color: isLer ? const Color(0xFF552F9F) : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            // Botão Meu Codigo
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() => _selected = 'meucodigo');
                  Navigator.pushNamed(context, AppRoutes.myQrCode);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 52,
                  decoration: BoxDecoration(
                    color: isMeu ? AppColors.secondary : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Meu Codigo',
                    style: TextStyle(
                      color: isMeu ? const Color(0xFF552F9F) : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
