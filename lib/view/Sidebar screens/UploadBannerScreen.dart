import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_shopping_dashboad/Controller/Banner%20controller.dart';
import 'package:online_shopping_dashboad/view/Sidebar%20screens/widgets/banner%20widget.dart';

class Uploadbannerscreen extends StatefulWidget {
  static const String id = 'upload_banner_screen';
  const Uploadbannerscreen({super.key});

  @override
  State<Uploadbannerscreen> createState() => _UploadbannerscreenState();
}

class _UploadbannerscreenState extends State<Uploadbannerscreen> {
  File? _imageFile;
  Uint8List? _imageBytes;
  
final BannerController _bannerController = BannerController();
  late String name;

  pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        if (kIsWeb) {
          // For Web: Use bytes
          setState(() {
            _imageBytes = result.files.single.bytes;
          });
        } else {
          // For Mobile/Desktop: Use file path
          setState(() {
            _imageFile = File(result.files.single.path!);
          });
        }
      } else {
        print("File picking cancelled");
      }
    } on PlatformException catch (e) {
      print("Unsupported operation: $e");
    } catch (e) {
      print("Error picking file: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Banner",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
            ),
          ),
          Divider(color: Colors.grey),
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: _imageBytes != null
                            ? Image.memory(
                                _imageBytes!,
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              )
                            : _imageFile != null
                                ? Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 150,
                                  )
                                : Text(
                                    "Category Image",
                                    style: TextStyle(color: Colors.white),
                                  ),
                      ),
                    ),
                  ),
             
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  _bannerController.uploadBanner(
                    pickedImage: kIsWeb ? _imageBytes : _imageFile,
                    context: context,
                  );

                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ), ],
            ),
             Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                pickImage(); 
              },
              child: Text(
                "Pick image",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ), 
          Divider(color: Colors.grey),
          BannerWidget()
      ],
    );
  }
} 