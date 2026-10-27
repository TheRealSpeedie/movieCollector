import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/errors/app_exception.dart';
import '../../../shared/widgets/error_view.dart';
import '../data/playback_api.dart';

const _languages = {
  'de': 'Deutsch',
  'en': 'Englisch',
  'fr': 'Französisch',
  'es': 'Spanisch',
  'it': 'Italienisch',
};

/// Searches the server's subtitle provider for this file and downloads the
/// chosen subtitles. Returns the new subtitle file.
class SubtitleSearchSheet extends StatefulWidget {
  const SubtitleSearchSheet({
    super.key,
    required this.api,
    required this.fileId,
    required this.language,
  });

  final PlaybackApi api;
  final int fileId;
  final String language;

  @override
  State<SubtitleSearchSheet> createState() => _SubtitleSearchSheetState();
}

class _SubtitleSearchSheetState extends State<SubtitleSearchSheet> {
  late String _language = _languages.containsKey(widget.language)
      ? widget.language
      : 'de';
  List<SubtitleOffer>? _offers;
  String? _error;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _search();
  }

  Future<void> _search() async {
    setState(() {
      _offers = null;
      _error = null;
    });
    try {
      final offers = await widget.api.searchSubtitles(widget.fileId, _language);
      if (mounted) setState(() => _offers = offers);
    } on AppException catch (e) {
      if (mounted) setState(() => _error = describeError(e));
    }
  }

  Future<void> _download(SubtitleOffer offer) async {
    setState(() => _busy = true);
    try {
      final subtitle = await widget.api.downloadSubtitle(widget.fileId, offer);
      if (mounted) Navigator.of(context).pop(subtitle);
    } on AppException catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = describeError(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final offers = _offers;
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            ListTile(
              title: const Text('Untertitel suchen'),
              trailing: DropdownButton<String>(
                value: _language,
                items: [
                  for (final e in _languages.entries)
                    DropdownMenuItem(value: e.key, child: Text(e.value)),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  _language = value;
                  _search();
                },
              ),
            ),
            if (_busy) const LinearProgressIndicator(),
            Expanded(
              child: _error != null
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(_error!, textAlign: TextAlign.center),
                    )
                  : offers == null
                  ? const Center(child: CircularProgressIndicator())
                  : offers.isEmpty
                  ? const Center(child: Text('Keine Untertitel gefunden.'))
                  : ListView(
                      children: [
                        for (final offer in offers)
                          ListTile(
                            enabled: !_busy,
                            leading: Icon(
                              offer.hashMatch
                                  ? Icons.verified
                                  : Icons.subtitles_outlined,
                              color: offer.hashMatch
                                  ? AppColors.sage
                                  : AppColors.neutralGray,
                            ),
                            title: Text(
                              offer.release.isEmpty
                                  ? offer.language
                                  : offer.release,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              [
                                if (offer.hashMatch)
                                  'Passt genau zu dieser Datei',
                                if (offer.hearingImpaired) 'für Hörgeschädigte',
                                if (offer.forced) 'nur fremdsprachige Stellen',
                                '${offer.downloads} Downloads',
                              ].join(' · '),
                            ),
                            onTap: () => _download(offer),
                          ),
                      ],
                    ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Untertitel von OpenSubtitles über deinen Server.',
                style: TextStyle(color: AppColors.neutralGray, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Moves subtitles earlier or later. Returns the new offset in seconds.
class SubtitleDelaySheet extends StatefulWidget {
  const SubtitleDelaySheet({super.key, required this.delay});

  final double delay;

  @override
  State<SubtitleDelaySheet> createState() => _SubtitleDelaySheetState();
}

class _SubtitleDelaySheetState extends State<SubtitleDelaySheet> {
  late double _delay = widget.delay;

  @override
  Widget build(BuildContext context) {
    final label = _delay == 0
        ? 'Synchron'
        : '${_delay > 0 ? 'Später' : 'Früher'} um ${_delay.abs().toStringAsFixed(1)} s';
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Untertitel verschieben',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  tooltip: 'Früher',
                  onPressed: () => setState(() => _delay -= 0.5),
                  icon: const Icon(Icons.fast_rewind),
                ),
                SizedBox(
                  width: 180,
                  child: Text(label, textAlign: TextAlign.center),
                ),
                IconButton.filledTonal(
                  tooltip: 'Später',
                  onPressed: () => setState(() => _delay += 0.5),
                  icon: const Icon(Icons.fast_forward),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => setState(() => _delay = 0),
                  child: const Text('Zurücksetzen'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(_delay),
                  child: const Text('Übernehmen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
