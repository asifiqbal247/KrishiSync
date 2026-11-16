import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../core/config/app_secrets.dart';

/// Result of an image upload. Store [url] in Firestore.
class UploadedImage {
  const UploadedImage({
    required this.url,
    required this.publicId,
    required this.width,
    required this.height,
  });

  final String url;
  final String publicId;
  final int width;
  final int height;

  Map<String, dynamic> toMap() => {
    'url': url,
    'publicId': publicId,
    'w': width,
    'h': height,
  };
}

/// What kind of image is being uploaded. Used for tags and size limits.
enum ImageKind {
  profile,
  listing,
  delivery,
  verification,
  report,
  chat,
  tradeDoc,
}

class ImageUploadException implements Exception {
  ImageUploadException(this.message);
  final String message;
  @override
  String toString() => 'ImageUploadException: $message';
}

/// Swappable image backend. Today: Cloudinary (Firebase Storage needs Blaze).
/// Switching to Firebase Storage later = new implementation of this class.
abstract interface class ImageStorageService {
  Future<UploadedImage> upload(
    File file, {
    required ImageKind kind,
    required String ownerUid,
  });

  /// Returns a smaller/cropped delivery URL for lists and thumbnails.
  String thumbnail(String url, {int size = 200});

  /// Short voice message (chat). Returns the file's URL.
  Future<String> uploadAudio(File file, {required String ownerUid});

  /// Chat video or PDF document (216). Returns the file's URL.
  Future<String> uploadFile(
    File file, {
    required bool video,
    required String ownerUid,
  });
}

class CloudinaryImageStorageService implements ImageStorageService {
  CloudinaryImageStorageService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  static const _maxSide = 1280;
  static const _quality = 75;
  static const _maxBytes = 5 * 1024 * 1024;
  static const _maxVideoBytes = 30 * 1024 * 1024;

  Uri get _endpoint => Uri.parse(
    'https://api.cloudinary.com/v1_1/${AppSecrets.cloudinaryCloudName}/image/upload',
  );

  @override
  Future<UploadedImage> upload(
    File file, {
    required ImageKind kind,
    required String ownerUid,
  }) async {
    final compressed = await _compress(file);
    if (await compressed.length() > _maxBytes) {
      throw ImageUploadException('too_large');
    }

    final req = http.MultipartRequest('POST', _endpoint)
      ..fields['upload_preset'] = AppSecrets.cloudinaryUploadPreset
      ..fields['tags'] = 'krishisync,${kind.name},$ownerUid'
      ..files.add(await http.MultipartFile.fromPath('file', compressed.path));

    final http.StreamedResponse streamed;
    try {
      streamed = await _client.send(req).timeout(const Duration(seconds: 60));
    } on SocketException {
      throw ImageUploadException('network');
    }
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode != 200) {
      throw ImageUploadException('http_${streamed.statusCode}');
    }
    final json = jsonDecode(body) as Map<String, dynamic>;
    return UploadedImage(
      url: json['secure_url'] as String,
      publicId: json['public_id'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
    );
  }

  /// Voice messages are small AAC files (~30 KB per 10 s), so no
  /// compression step. Cloudinary keeps audio under the "video" type
  /// (/video/upload) with the audio preset (krishisync/voice folder).
  @override
  Future<String> uploadAudio(File file, {required String ownerUid}) async {
    if (await file.length() > _maxBytes) {
      throw ImageUploadException('too_large');
    }
    final req =
        http.MultipartRequest(
            'POST',
            Uri.parse(
              'https://api.cloudinary.com/v1_1/'
              '${AppSecrets.cloudinaryCloudName}/video/upload',
            ),
          )
          // Separate audio-only preset; the image preset stays images-only.
          ..fields['upload_preset'] = AppSecrets.cloudinaryAudioPreset
          ..fields['tags'] = 'krishisync,voice,$ownerUid'
          ..files.add(await http.MultipartFile.fromPath('file', file.path));
    final http.StreamedResponse streamed;
    try {
      streamed = await _client.send(req).timeout(const Duration(seconds: 60));
    } on SocketException {
      throw ImageUploadException('network');
    }
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode != 200) {
      throw ImageUploadException('http_${streamed.statusCode}');
    }
    return (jsonDecode(body) as Map<String, dynamic>)['secure_url'] as String;
  }

  /// Videos (max [_maxVideoBytes]) go to /video/upload, PDFs to
  /// /raw/upload so they open as plain files. Own preset; the image preset
  /// stays images-only.
  @override
  Future<String> uploadFile(
    File file, {
    required bool video,
    required String ownerUid,
  }) async {
    if (await file.length() > (video ? _maxVideoBytes : _maxBytes)) {
      throw ImageUploadException('too_large');
    }
    final type = video ? 'video' : 'raw';
    final req =
        http.MultipartRequest(
            'POST',
            Uri.parse(
              'https://api.cloudinary.com/v1_1/'
              '${AppSecrets.cloudinaryCloudName}/$type/upload',
            ),
          )
          ..fields['upload_preset'] = AppSecrets.cloudinaryFilesPreset
          ..fields['tags'] = 'krishisync,${video ? 'video' : 'doc'},$ownerUid'
          ..files.add(await http.MultipartFile.fromPath('file', file.path));
    final http.StreamedResponse streamed;
    try {
      streamed = await _client.send(req).timeout(const Duration(minutes: 3));
    } on SocketException {
      throw ImageUploadException('network');
    }
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode != 200) {
      throw ImageUploadException('http_${streamed.statusCode}');
    }
    return (jsonDecode(body) as Map<String, dynamic>)['secure_url'] as String;
  }

  Future<File> _compress(File file) async {
    final dir = Directory.systemTemp; // app cache dir on Android
    final target =
        '${dir.path}/ks_${DateTime.now().microsecondsSinceEpoch}.jpg';
    final out = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      target,
      minWidth: _maxSide,
      minHeight: _maxSide,
      quality: _quality,
      format: CompressFormat.jpeg,
    );
    return out == null ? file : File(out.path);
  }

  @override
  String thumbnail(String url, {int size = 200}) {
    const marker = '/image/upload/';
    final i = url.indexOf(marker);
    if (i < 0) return url;
    final t = 'c_fill,w_$size,h_$size,q_auto,f_auto/';
    return url.replaceRange(i + marker.length, i + marker.length, t);
  }
}

final imageStorageProvider = Provider<ImageStorageService>(
  (ref) => CloudinaryImageStorageService(),
);
