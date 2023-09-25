import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePicker extends StatefulWidget {
  const MyImagePicker({super.key});

  @override
  MyImagePickerState createState() => MyImagePickerState();
}

class MyImagePickerState extends State<MyImagePicker> {
  static File? _imageFile;
  static String? fileName;

  static final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          fileName = pickedFile.name;
        });
      }
    } catch (e) {
      log("Image picking failed: $e");
      rethrow;
    }
  }

  static Future<String?> uploadImage() async {
    try {
      if (_imageFile == null) {
        log("Image upload failed: No image selected");
        return null;
      }

      Reference ref = storage.ref().child("profileImage").child("$fileName");
      var upload = await ref.putFile(_imageFile!);
      String imageLink = await upload.ref.getDownloadURL();
      log("Image Link: $imageLink");
      return imageLink;
    } catch (e) {
      log("Image upload failed: $e");
      rethrow;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.red.shade100,
          radius: 80,
          child: _imageFile != null
              ? ClipOval(
                  child: Image.file(
                    _imageFile!,
                    width: 160, // Set a fixed width and height
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          child: IconButton(
            onPressed: () {
              _getImage();
            },
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
