// lib/services/image_storage_service.dart
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageStorageService {
  ImageStorageService._internal();
  static final ImageStorageService instance = ImageStorageService._internal();

  static const String _scansFolderName = "scans";

  /// Copies [sourcePath] into a permanent "scans" folder inside the app's

  Future<String> copyToPermanentStorage(String sourcePath) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final scansDir = Directory(p.join(docsDir.path, _scansFolderName));

    if (!await scansDir.exists()) {
      await scansDir.create(recursive: true);
    }

    final extension = p.extension(sourcePath);
    final uniqueName =
        "scan_${DateTime.now().millisecondsSinceEpoch}$extension";
    final destinationPath = p.join(scansDir.path, uniqueName);

    final sourceFile = File(sourcePath);
    final copiedFile = await sourceFile.copy(destinationPath);

    return copiedFile.path;
  }

  Future<void> deleteStoredImage(String permanentPath) async {
    final file = File(permanentPath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
