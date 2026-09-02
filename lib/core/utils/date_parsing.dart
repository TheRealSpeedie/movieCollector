DateTime? parseIsoDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  return DateTime.tryParse(raw);
}

int? yearFromDate(DateTime? date) => date?.year;
