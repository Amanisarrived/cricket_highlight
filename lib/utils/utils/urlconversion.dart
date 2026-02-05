/// Convert YouTube Shorts URLs to normal watch?v=VIDEOID format
String convertShortsToWatchUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return '';

  // Shorts URL
  if (uri.host.contains('youtube.com')) {
    if (uri.pathSegments.contains('shorts') && uri.pathSegments.length >= 2) {
      final id = uri.pathSegments[1];
      return 'https://www.youtube.com/watch?v=$id';
    } else if (uri.queryParameters.containsKey('v')) {
      return url; // already in watch?v format
    }
  } else if (uri.host.contains('youtu.be')) {
    final id = uri.pathSegments[0];
    return 'https://www.youtube.com/watch?v=$id';
  }

  return '';
}

/// Extract video ID from YouTube URL
String extractYoutubeId(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return '';
  if (uri.host.contains('youtube.com')) {
    if (uri.pathSegments.contains('shorts') && uri.pathSegments.length >= 2) {
      return uri.pathSegments[1];
    } else if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    }
  } else if (uri.host.contains('youtu.be')) {
    return uri.pathSegments[0];
  }
  return '';
}
