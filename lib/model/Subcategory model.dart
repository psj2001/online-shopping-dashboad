// To parse this JSON data, do
//
//     final subcategoryModel = subcategoryModelFromJson(jsonString);

import 'dart:convert';

List<SubcategoryModel> subcategoryModelFromJson(String str) => List<SubcategoryModel>.from(json.decode(str).map((x) => SubcategoryModel.fromJson(x)));

String subcategoryModelToJson(List<SubcategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubcategoryModel {
    String id;
    String categoryId;
    String categoryName;
    String image;
    String subCategoryName;
    

    SubcategoryModel({
        required this.id,
        required this.categoryId,
        required this.categoryName,
        required this.image,
        required this.subCategoryName,
      
    });

    factory SubcategoryModel.fromJson(Map<String, dynamic> json) => SubcategoryModel(
        id: json["_id"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        image: json["image"],
        subCategoryName: json["subCategoryName"],
        
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "image": image,
        "subCategoryName": subCategoryName,
       
    };
}
