import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_shopping_dashboad/view/Sidebar%20screens/widgets/SubcategoryWidget.dart';

import '../../Controller/Category controller.dart';
import '../../Controller/Subcategory controller.dart';
import '../../model/category model.dart';

class Subcategoryscreen extends StatefulWidget {
  static const String id = 'Subcategoryscreen';
  const Subcategoryscreen({super.key});

  @override
  State<Subcategoryscreen> createState() => _SubcategoryscreenState();
}

class _SubcategoryscreenState extends State<Subcategoryscreen> {
  final SubCategoryController subCategoryController = SubCategoryController();
  late Future<List<Category>> futureCategories;
  Category? selectedCategory;
  File? _imageFile;
  Uint8List? _imageBytes;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String subcategoryname;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        if (foundation.kIsWeb) {
          setState(() {
            _imageBytes = result.files.single.bytes; // Non-null for web
          });
        } else {
          setState(() {
            _imageFile =
                File(result.files.single.path!); // Non-null for non-web
          });
        }
      } else {
        log("File picking cancelled");
      }
    } on PlatformException catch (e) {
      log("Unsupported operation: $e");
    } catch (e) {
      log("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Subcategories",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
          ),
          const Divider(color: Colors.grey),
          FutureBuilder<List<Category>>(
            future: futureCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Subcategories'));
              } else {
                final categories = snapshot.data!;
                return DropdownButton<Category>(
                  hint: const Text('Select Subcategory'),
                  items: categories.map((category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                    log("Selected Subcategory: ${selectedCategory!.name}");
                  },
                );
              }
            },
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: pickImage,
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
                            : const Text(
                                "Subcategory Image",
                                style: TextStyle(color: Colors.white),
                              ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Subcategory name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          subcategoryname = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Enter Subcategory Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _imageFile = null;
                                _imageBytes = null;
                                subcategoryname = '';
                              });
                              log("Form reset");
                            },
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async{
                              if (_formKey.currentState!.validate()) {
                                log("Subcategory Name: $subcategoryname");
                            await    subCategoryController.uploadSubcategory(
                                  categoryId: selectedCategory!.id,
                                  categoryName: selectedCategory!.name,
                                  pickedImage: foundation.kIsWeb
                                      ? _imageBytes
                                      : _imageFile?.readAsBytesSync(),
                                  subCategoryName: subcategoryname,
                                  context: context,
                                );
                              setState(() {
                                _formKey.currentState!.reset();
                                _imageFile=null;
                                _imageBytes=null;
                                selectedCategory = null;
                              });
                              }
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            pickImage();
                          },
                          child: Text(
                            "Upload Photo",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          const Divider(color: Colors.grey),
          Subcategorywidget(), 
        ],
      ),
    );
  }
}
