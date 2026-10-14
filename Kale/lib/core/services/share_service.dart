import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Hands a file to the system share sheet (save, send, open in another
/// app).
abstract class ShareService {
  /// Writes [content] to a temporary file named [fileName] and opens the
  /// share sheet with it.
  Future<void> shareTextFile({
    required String fileName,
    required String content,
    required String mimeType,
  });
}

/// [ShareService] with `share_plus`.
class PlatformShareService implements ShareService {
  /// Creates a [PlatformShareService].
  const PlatformShareService();

  @override
  Future<void> shareTextFile({
    required String fileName,
    required String content,
    required String mimeType,
  }) async {
    final directory = await getTemporaryDirectory();
    final file = File(p.join(directory.path, fileName));
    await file.writeAsString(content, flush: true);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path, mimeType: mimeType)]),
    );
  }
}
