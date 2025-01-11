// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

List<BannerModel> bannerModelFromJson(String str) => List<BannerModel>.from(json.decode(str).map((x) => BannerModel.fromJson(x)));

String bannerModelToJson(List<BannerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BannerModel {
    String id;
    String image;
   

    BannerModel({
        required this.id,
        required this.image,
       
    });

    factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json["_id"],
        image: json["Image"],
       
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "Image": image,
       
    };
}
