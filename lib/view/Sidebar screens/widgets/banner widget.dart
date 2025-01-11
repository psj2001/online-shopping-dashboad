import 'package:flutter/material.dart';
import 'package:online_shopping_dashboad/Controller/Banner%20controller.dart';
import 'package:online_shopping_dashboad/model/Banner%20models.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  //A Future that will hold the list of banner from the  API
  late Future<List<BannerModel>> futureBanners;
  @override
  void initState() {
    super.initState();
    futureBanners = BannerController().loadBanners();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureBanners,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No Banners'),
            );
          } else {
            final banners = snapshot.data!;
            // return SizedBox(height: 100,width: double.infinity,
            //   child: ListView.builder(
            //     itemCount: banners.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       final banner = banners[index];
            //       return Image.network(banner.image,width: 40,height: 40,);
            //     },
            //   ),
            // ); 
            return GridView.builder(shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (BuildContext context, int index) {
                final banner = banners[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    banner.image,
                    width: 100,
                    height: 100,
                  ),
                );
              },
              itemCount: banners.length,
            );
          }
        });
  }
}
