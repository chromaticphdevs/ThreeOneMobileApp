import 'dart:io' as io;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path_provider/path_provider.dart' as pathx;
import 'package:http/http.dart' as httpx;
class GoogleDriveService {
  final _googleSignIn = GoogleSignIn(
      scopes: ['https://www.googleapis.com/auth/drive.file']
  );

  Future<void> _authenticate() async {

  }

  Future<void> _loadVideos() async {}

  Future<void> _uploadVideos() async {}
}