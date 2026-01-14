class GoogledriveSourceConverter {
  String extractDriveFileId(String url) {
    final pattern = RegExp(r'/d/([a-zA-Z0-9_-]+)');
    final match = pattern.firstMatch(url);

    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    }

    // Fallback: try query‑param style (in case Google uses ?id=...)
    final altPattern = RegExp(r'[?&]id=([a-zA-Z0-9_-]+)');
    final altMatch = altPattern.firstMatch(url);

    if (altMatch != null && altMatch.groupCount >= 1) {
      return altMatch.group(1)!;
    }

    throw FormatException('No Drive file ID found in URL: $url');
  }

  String convertedDriveLink(String url) {
    String driveID = extractDriveFileId(url);
    return 'https://drive.google.com/thumbnail?id=$driveID';
  }
}