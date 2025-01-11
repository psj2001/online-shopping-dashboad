import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_shopping_dashboad/Services/manage%20http%20response.dart';
import 'package:online_shopping_dashboad/global%20variable.dart';
import 'package:online_shopping_dashboad/model/Banner%20models.dart';
import 'package:http/http.dart' as http;
class BannerController {
  uploadBanner({required dynamic pickedImage, required BuildContext context}) async {
  try {
    // Convert Uint8List to ByteData if running on the web
    ByteData? byteData;
    if (pickedImage is Uint8List) {
      byteData = ByteData.view(pickedImage.buffer);
    } else if (pickedImage is File) {
      // Read the file as bytes for mobile/desktop
      byteData = await pickedImage.readAsBytes().then((bytes) => ByteData.view(bytes.buffer));
    }

    if (byteData == null) {
      throw Exception("Invalid image data");
    }

    // Upload image to server
    final cloudinary = CloudinaryPublic("dzp3hv4fy", "geuhgz9u");

    CloudinaryResponse imageResponse = await cloudinary.uploadFile(
      CloudinaryFile.fromByteData(byteData, identifier: 'pickedImage', folder: 'banners'),
    );
    String image = imageResponse.secureUrl;

    BannerModel bannerModel = BannerModel(id: '', image: image);

    // Send banner data to the server
    http.Response response = await http.post(
      Uri.parse('$uri/api/banner'),
      body: json.encode(bannerModel.toJson()), // Convert to JSON string
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    manageHttpResponse(
      response: response,
      context: context,
      onSuccess: () {
        Fluttertoast.showToast(
          msg: "Banner added successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        log('Banner uploaded successfully');
      },
    );
  } catch (e) {
    print("Error uploading banner: $e");
  }
}
//fetch banner
Future<List<BannerModel>> loadBanners() async {
  try {
    http.Response response = await http.get(Uri.parse('$uri/api/banner'));
    log('response: ${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<BannerModel> banners = data.map((dynamic item) => BannerModel.fromJson(item)).toList();
      return banners;
    } else {
      throw "Failed to load banners";
    }
  } catch (e) {
    print("Error fetching banners: $e");
    return [];
  }
  }

}