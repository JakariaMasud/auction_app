import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  ImagePickerService._privateConstructor();

  static final ImagePickerService instance =
      ImagePickerService._privateConstructor();
  final imagePicker = ImagePicker();

  // Returns a [File] object pointing to the image that was picked.
  Future<File> pickImage({@required ImageSource source}) async {
    final pickedFile = await imagePicker.getImage(source: source);
    return File(pickedFile.path);
  }
}
