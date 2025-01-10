import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_shopping_dashboad/Services/manage%20http%20response.dart';
import 'package:online_shopping_dashboad/global%20variable.dart';
import 'package:online_shopping_dashboad/model/category%20model.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  Future<void> uploadCategory({
  required File? pickedImage,
  required File? pickedBanner,
  required Uint8List? pickedImageBytes,
  required Uint8List? pickedBannerBytes,
  required String name,
  required context,
}) async {
 try {
  final cloudinary = CloudinaryPublic("dzp3hv4fy", "geuhgz9u");

  String imageUrl = '';
  String bannerUrl = '';

  // Upload category image
  if (pickedImageBytes != null || pickedImage != null) {
    final imageResponse = await cloudinary.uploadFile(
      CloudinaryFile.fromByteData(
        pickedImageBytes != null
            ? ByteData.view(pickedImageBytes.buffer)
            : ByteData.view((await pickedImage!.readAsBytes()).buffer),
        identifier: 'pickedImage',
        folder: 'categoryImages',
      ),
    );
    imageUrl = imageResponse.secureUrl;
    log("Image Uploaded: ${imageResponse.secureUrl}");
  }

  // Upload banner image
  if (pickedBannerBytes != null || pickedBanner != null) {
    final bannerResponse = await cloudinary.uploadFile(
      CloudinaryFile.fromByteData(
        pickedBannerBytes != null
            ? ByteData.view(pickedBannerBytes.buffer)
            : ByteData.view((await pickedBanner!.readAsBytes()).buffer),
        identifier: 'pickedBanner',
        folder: 'categoryBanners',
      ),
    );
    bannerUrl = bannerResponse.secureUrl;
    log("Banner Uploaded: ${bannerResponse.secureUrl}");
  }

  // Create category object
  Category category = Category(
    id: '',
    name: name,
    image: imageUrl,
    banner: bannerUrl,
  );

  // Send category data to the server
  http.Response response = await http.post(
    Uri.parse('$uri/api/categories'),
    body: json.encode(category.toJson()), // Convert to JSON string
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  manageHttpResponse(
    response: response,
    context: context,
    onSuccess: () {
    Fluttertoast.showToast(
      msg: "Category added successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
      log('Category uploaded successfully');
    },
  );
} catch (e) {
  log("Error uploading image to Cloudinary: $e");
}
}
}
