class ScanTrace {
  final lines = <String>[];

  void add(String line) => lines.add(line);

  String get text => lines.join('\n');
}
