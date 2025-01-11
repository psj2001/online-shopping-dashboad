import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/services.dart';
import 'package:online_shopping_dashboad/Controller/Category%20controller.dart';
import 'package:online_shopping_dashboad/view/Sidebar%20screens/widgets/CategoryWidget.dart';

class Categoryscreen extends StatefulWidget {
  static const String id = 'category_screen';
  const Categoryscreen({super.key});

  @override
  State<Categoryscreen> createState() => _CategoryscreenState();
}

class _CategoryscreenState extends State<Categoryscreen> {
  File? _imageFile;
  Uint8List? _imageBytes;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final CategoryController _categorycontroller = CategoryController();

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

///////
  File? _imageFile2;
  Uint8List? _imageBytes2;

  pickBannerImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        if (kIsWeb) {
          // For Web: Use bytes
          setState(() {
            _imageBytes2 = result.files.single.bytes;
          });
        } else {
          // For Mobile/Desktop: Use file path
          setState(() {
            _imageFile2 = File(result.files.single.path!);
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
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Categories",
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return 'Please enter category name';
                        }
                      },
                      onChanged: (value) {
                        name = value;
                      },
                      decoration:
                          InputDecoration(labelText: 'Enter Category Name'),
                    ),
                  ),
                ),
                TextButton(onPressed: () {}, child: Text("Cancel")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _categorycontroller.uploadCategory(
                        pickedImage: _imageFile,
                        pickedBanner: _imageFile2,
                        pickedImageBytes: _imageBytes,
                        pickedBannerBytes: _imageBytes2, name: name, context: context,
                      );
                      print("Category Name: $name");
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  pickImage();
                },
                child: Text(
                  "Upload Photo",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: _imageBytes2 != null
                      ? Image.memory(
                          _imageBytes2!,
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        )
                      : _imageFile2 != null
                          ? Image.file(
                              _imageFile2!,
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            )
                          : Text(
                              "Category Banner",
                              style: TextStyle(color: Colors.white),
                            ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  pickBannerImage();
                },
                child: Text(
                  "Pick image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(color: Colors.grey),
            ),
            Categorywidget(),
          ],
        ),
      ),
    );
  }
}
  