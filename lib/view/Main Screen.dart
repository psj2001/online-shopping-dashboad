import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:online_shopping_dashboad/view/Sidebar%20screens/BuyersScreen.dart';
import 'package:online_shopping_dashboad/view/Sidebar%20screens/CategoryScreen.dart';
import 'package:online_shopping_dashboad/view/Sidebar%20screens/OrdersScreen.dart';
import 'package:online_shopping_dashboad/view/Sidebar%20screens/ProductScreen.dart';
import 'package:online_shopping_dashboad/view/Sidebar%20screens/UploadBannerScreen.dart';
import 'package:online_shopping_dashboad/view/Sidebar%20screens/Vesndors%20Screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = const Vesndorsscreen();

  // Screen Selector Function
  void screenSelector(String item) {
    setState(() {
      switch (item) {
        case Vesndorsscreen.id:
          _selectedScreen = const Vesndorsscreen();
          break;
        case Buyersscreen.id:
          _selectedScreen = const Buyersscreen();
          break;
        case Ordersscreen.id:
          _selectedScreen = const Ordersscreen();
          break;
        case Categoryscreen.id:
          _selectedScreen = const Categoryscreen();
          break;
        case Uploadbannerscreen.id:
          _selectedScreen = const Uploadbannerscreen();
          break;
        case ProductScreen.id:
          _selectedScreen = const ProductScreen();
          break;
        default:
          _selectedScreen = const Vesndorsscreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Admin Panel"),
        backgroundColor: Colors.blue,
      ),
      sideBar: SideBar(
        header: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Center(
              child: Text(
            "Multivendor Admin ",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.7),
          )),
        ),
        items: [
          AdminMenuItem(
            title: 'Vendors',
            route: Vesndorsscreen.id,
            icon: CupertinoIcons.person_3,
          ),
          AdminMenuItem(
            title: 'Buyers',
            route: Buyersscreen.id,
            icon: CupertinoIcons.person,
          ),
          AdminMenuItem(
            title: 'Orders',
            route: Ordersscreen.id,
            icon: CupertinoIcons.cart,
          ),
          AdminMenuItem(
            title: 'Categories',
            route: Categoryscreen.id,
            icon: Icons.category,
          ),
          AdminMenuItem(
            title: 'Upload Banners',
            route: Uploadbannerscreen.id,
            icon: CupertinoIcons.add,
          ),
          AdminMenuItem(
            title: 'Products',
            route: ProductScreen.id,
            icon: Icons.stop,
          ),
        ],
        selectedRoute: Vesndorsscreen.id,
        onSelected: (item) {
          if (item.route != null) {
            screenSelector(item.route!);
          }
        },
      ),
      body: _selectedScreen,
    );
  }
}

// Example for screen classes
