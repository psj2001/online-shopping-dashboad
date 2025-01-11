import 'package:flutter/material.dart';
import 'package:online_shopping_dashboad/Controller/Category%20controller.dart';
import 'package:online_shopping_dashboad/model/category%20model.dart';

class Categorywidget extends StatefulWidget {
  const Categorywidget({super.key});

  @override
  State<Categorywidget> createState() => _CategorywidgetState();
}

class _CategorywidgetState extends State<Categorywidget> {
  //A Future that will hold the list of categories once loaded from the api
  late Future<List<Category>> futureCategories;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    // height: 200,
    // width:  double.infinity,
      child: FutureBuilder(
          future: futureCategories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Handle the data here
              return Center(child: Text('No Categories'));
            } else {
              final categories = snapshot.data!;
              return GridView.builder(shrinkWrap: true,
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                ),
             itemBuilder: (context, index) {
                final category = categories[index];
                return Container(height: 100,
                  width: 100,
                  child: Column(
                    children: [
                      Image.network(category.image, height: 100, width: 100),
                      Text(category.name),
                    ],
                  ),
                );
             }, );
            }
          }),
    );
  }
} 
