import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../application/scan_providers.dart';
import 'recent_scans_sheet.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/loading_view.dart';
import '../application/fundstueck_controller.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController(
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.qrCode,
    ],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  PermissionStatus _permission = PermissionStatus.denied;
  bool _checkingPermission = true;
  bool _handledDetection = false;
  bool _resolving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestPermission();
    // Barcodes scanned without a connection are looked up when possible.
    unawaited(ref.read(pendingScanProcessorProvider).run());
  }

  Future<void> _showRecent() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => RecentScansSheet(onOpen: _openCode),
    );
  }

  Future<void> _openCode(String code) async {
    if (_resolving) return;
    setState(() => _resolving = true);
    try {
      await _controller.stop();
      final pending = ref
          .read(fundstueckControllerProvider.notifier)
          .scanBarcode(code);
      if (!mounted) return;
      await context.push('/fundstueck/result');
      await pending;
    } finally {
      if (mounted) {
        setState(() => _resolving = false);
        unawaited(_controller.start());
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    setState(() {
      _permission = status;
      _checkingPermission = false;
    });
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handledDetection || _resolving) return;
    final barcode = capture.barcodes.firstOrNull;
    final code = barcode?.rawValue;
    if (code == null || code.isEmpty) return;
    _handledDetection = true;
    setState(() => _resolving = true);
    try {
      await _controller.stop();
      final pending = ref
          .read(fundstueckControllerProvider.notifier)
          .scanBarcode(code, formatName: barcode?.format.name);
      if (!mounted) return;
      await context.push('/fundstueck/result');
      await pending;
    } finally {
      _handledDetection = false;
      if (mounted) {
        setState(() => _resolving = false);
        unawaited(_controller.start());
      }
    }
  }

  Future<void> _showTitleFallback() async {
    final title = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _TitleFallbackSheet(),
    );
    if (title == null || title.trim().isEmpty || _resolving) return;
    setState(() => _resolving = true);
    try {
      final pending = ref
          .read(fundstueckControllerProvider.notifier)
          .searchTitleFallback(title.trim());
      if (!mounted) return;
      await context.push('/fundstueck/result');
      await pending;
    } finally {
      if (mounted) setState(() => _resolving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(fundstueckControllerProvider, (_, _) {});
    return Scaffold(
      backgroundColor: _resolving ? AppColors.background : Colors.black,
      appBar: AppBar(
        backgroundColor: _resolving ? AppColors.background : Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Fundstück-Check'),
        actions: [
          IconButton(
            tooltip: 'Zuletzt gescannt',
            onPressed: _showRecent,
            icon: Badge(
              isLabelVisible:
                  (ref.watch(pendingScanCountProvider).valueOrNull ?? 0) > 0,
              label: Text(
                '${ref.watch(pendingScanCountProvider).valueOrNull ?? 0}',
              ),
              child: const Icon(Icons.history),
            ),
          ),
          IconButton(
            tooltip: 'Taschenlampe',
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, state, child) {
                return Icon(
                  state.torchState == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off,
                );
              },
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: _resolving
          ? LoadingView(message: ref.watch(lookupStatusProvider))
          : _checkingPermission
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _permission.isGranted
          ? _buildScanner(context)
          : _buildPermissionDenied(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _resolving
          ? null
          : FloatingActionButton.extended(
              onPressed: _showTitleFallback,
              icon: const Icon(Icons.keyboard),
              label: const Text('Titel eingeben'),
            ),
    );
  }

  Widget _buildScanner(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(controller: _controller, onDetect: _onDetect),
        _ScanOverlay(),
        Positioned(
          left: 0,
          right: 0,
          bottom: 110,
          child: Text(
            'Scanne den gestreiften Barcode auf der Rückseite\nder DVD-, Blu-ray- oder 4K-Hülle.\nEAN / UPC',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionDenied(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 56,
              color: Colors.white70,
            ),
            const SizedBox(height: 16),
            const Text(
              'Kamerazugriff wird benötigt, um Barcodes zu scannen und Filme in deiner Sammlung zu erkennen.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            if (_permission.isPermanentlyDenied)
              FilledButton(
                onPressed: openAppSettings,
                child: const Text('Einstellungen öffnen'),
              )
            else
              FilledButton(
                onPressed: _requestPermission,
                child: const Text('Berechtigung erteilen'),
              ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _showTitleFallback,
              icon: const Icon(Icons.keyboard, color: Colors.white),
              label: const Text(
                'Stattdessen Titel eingeben',
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 260,
        height: 160,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.dustyRose, width: 3),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _TitleFallbackSheet extends StatefulWidget {
  const _TitleFallbackSheet();

  @override
  State<_TitleFallbackSheet> createState() => _TitleFallbackSheetState();
}

class _TitleFallbackSheetState extends State<_TitleFallbackSheet> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filmtitel eingeben',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: 'z. B. Der Herr der Ringe',
            ),
            onSubmitted: (value) => Navigator.of(context).pop(value),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(_controller.text),
              child: const Text('Suchen'),
            ),
          ),
        ],
      ),
    );
  }
}
