import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/theme/speednema_colors.dart';
import '../data/pairing_link.dart';

class PairScanScreen extends StatefulWidget {
  const PairScanScreen({super.key});

  @override
  State<PairScanScreen> createState() => _PairScanScreenState();
}

class _PairScanScreenState extends State<PairScanScreen> {
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  PermissionStatus? _permission;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _request();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _request() async {
    final status = await Permission.camera.request();
    if (mounted) setState(() => _permission = status);
  }

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value != null && PairingLink.looksLikePairingLink(value)) {
        _done = true;
        context.pop(value);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: context.colors.onMedia,
        title: const Text('QR-Code scannen'),
      ),
      body: switch (_permission) {
        null => Center(
          child: CircularProgressIndicator(color: context.colors.onMedia),
        ),
        PermissionStatus.granted || PermissionStatus.limited => Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(controller: _controller, onDetect: _onDetect),
            Center(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  border: Border.all(color: context.colors.accent, width: 3),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 64,
              child: Text(
                'Öffne im Dashboard „Geräte“ und wähle „Handy verbinden“. Scanne dann den QR-Code.',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.onMedia),
              ),
            ),
          ],
        ),
        _ => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 56,
                  color: context.colors.onMedia.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  'Kamerazugriff wird benötigt, um den QR-Code zu scannen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colors.onMedia),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _permission == PermissionStatus.permanentlyDenied
                      ? openAppSettings
                      : _request,
                  child: Text(
                    _permission == PermissionStatus.permanentlyDenied
                        ? 'Einstellungen öffnen'
                        : 'Berechtigung erteilen',
                  ),
                ),
              ],
            ),
          ),
        ),
      },
    );
  }
}
