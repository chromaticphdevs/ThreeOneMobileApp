import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';


class ImageService {

  final ImagePicker _picker = ImagePicker();
  final _uuid = const Uuid();

  Future<File?> loadPhoto(String storage, String key) async{
    final box = Hive.box(storage);
    final fileName = box.get(key);

    if(fileName == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final file = File(path.join(dir.path, fileName));

    return await file.exists() ? file : null;
  }

  Future<XFile?> pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if(picked == null) return null;
    return picked;
  }


  Future<File?> saveImage(File? file, String storage, String key) async {
    if(file == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final extension = path.extension(file.path);
    final randomName = '${_uuid.v4()}$extension';

    final savedPath = path.join(dir.path, randomName);
    final savedFile = await File(file.path).copy(savedPath);

    final box = Hive.box(storage);
    final oldFileName = box.get(key);
    await box.put(key, randomName);

    // optional cleanup
    if (oldFileName != null && oldFileName != randomName) {
      final oldFile = File(path.join(dir.path, oldFileName));
      if (await oldFile.exists()) {
        await oldFile.delete();
      }
    }
    return savedFile;
  }

  Future<void> deleteFile(File? file) async {
    if(file != null) {
      if(await file.exists()) {
        await file.delete();
      }
    }
  }

}