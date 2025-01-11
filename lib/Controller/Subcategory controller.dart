import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:online_shopping_dashboad/Services/manage%20http%20response.dart';
import 'package:online_shopping_dashboad/global%20variable.dart';
import 'package:online_shopping_dashboad/model/Subcategory%20model.dart';

class SubCategoryController {
uploadSubcategory({
  required String categoryId,
  required String categoryName,
  required dynamic pickedImage,
  required String subCategoryName,
  required BuildContext context,
}) async {
  try {
    if (pickedImage == null) {
      throw Exception("No image selected");
    }

    final cloudinary = CloudinaryPublic("dzp3hv4fy", "geuhgz9u");
    String imageUrl = '';

    // Convert Uint8List to ByteData if necessary
    ByteData imageData;
    if (pickedImage is Uint8List) {
      imageData = ByteData.view(pickedImage.buffer);
    } else {
      throw Exception("Invalid image format");
    }

    // Upload category image
    final imageResponse = await cloudinary.uploadFile(
      CloudinaryFile.fromByteData(
        imageData,
        identifier: 'pickedImage',
        folder: 'categoryImages',
      ),
    );
    imageUrl = imageResponse.secureUrl;
    log("Image Subcategory: ${imageResponse.secureUrl}");

    SubcategoryModel subcategory = SubcategoryModel(
      id: '',
      categoryId: categoryId,
      categoryName: categoryName,
      image: imageUrl,
      subCategoryName: subCategoryName,
    );

    // Send category data to the server
    http.Response response = await http.post(
      Uri.parse('$uri/api/sub_categories'),
      body: json.encode(subcategory.toJson()), // Convert to JSON string
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    manageHttpResponse(
      response: response,
      context: context,
      onSuccess: () {
        Fluttertoast.showToast(
          msg: "Subcategory added successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        log('Subcategory uploaded successfully');
      },
    );
  } catch (e) {
    log("Error uploading subcategory: $e");
  }
}

  //load the uploaded category

  Future<List<SubcategoryModel>> loadsubcategories() async {
  try {
    http.Response response = await http.get(Uri.parse('$uri/api/subcategories'));
    log('response: ${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<SubcategoryModel> subcategory = data.map((dynamic item) => SubcategoryModel.fromJson(item)).toList();
      return subcategory;
    } else {
      throw "Failed to load Subcategories";
    }
  } catch (e) {
    print("Error fetching Subcategories: $e");
    return [];
  }
  }
}
