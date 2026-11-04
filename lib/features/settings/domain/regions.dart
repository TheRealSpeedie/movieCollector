/// Countries Speednema knows streaming offers and age ratings for, in the
/// order they are offered. Shared by onboarding and Einstellungen.
const supportedRegions = {
  'DE': 'Deutschland',
  'AT': 'Österreich',
  'CH': 'Schweiz',
  'US': 'USA',
  'GB': 'Großbritannien',
};

String regionName(String code) => supportedRegions[code] ?? code;
