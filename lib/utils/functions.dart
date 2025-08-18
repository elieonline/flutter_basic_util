import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Uint8List base64ToImage(String? image) {
  return base64Decode((image ?? "").split("base64,").last);
}

Future<String> imageFileToBase64(File imageFile) async {
  try {
    // Read the file as bytes
    Uint8List imageBytes = await imageFile.readAsBytes();

    // Encode the bytes to Base64
    String base64Image = base64Encode(imageBytes);

    return base64Image;
  } catch (e) {
    throw Exception("Error converting image to base64: $e");
  }
}

Future<File?> compressImage(File imageFile, {int maxSize = 1}) async {
  int maxSizeInBytes = maxSize * 1024 * 1024; // Convert MB to bytes

  // check if image size is less than maxSize allowed before compression
  if (imageFile.lengthSync() < maxSizeInBytes) {
    return imageFile;
  }

  var compressedBytes = await FlutterImageCompress.compressWithFile(
    imageFile.absolute.path,
    minWidth: 800, // Adjust based on your requirements
    minHeight: 800,
    quality: 90, // Adjust quality (1-100)
  );
  if (compressedBytes == null) {
    return null; // Compression failed
  }

  // Check size and iterate if needed
  while (compressedBytes!.length > maxSizeInBytes) {
    // Reduce quality further if necessary
    compressedBytes = await FlutterImageCompress.compressWithList(compressedBytes, quality: 75);
  }

  // Convert to file: Uint8List to File
  return File(imageFile.path).writeAsBytes(compressedBytes);
}
