// lib/util/web_download_web.dart
// Implementation for web platforms using universal_html (or dart:html)

import 'dart:html' as html;

void triggerDownload(String href) {
  try {
    final anchor = html.AnchorElement(href: href)
      ..setAttribute('download', href.split('/').last)
      ..click();
  } catch (e) {
    // In case of failure, fallback to no-op.
    // You could log if needed.
    print('Web download failed: $e');
  }
}
