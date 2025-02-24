import 'package:flutter/material.dart';
import 'package:piecloud/MapPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // Default to "Cloud" tab (index 2)

  // Sample pages
  static final List<Widget> _pages = <Widget>[
    const MapPage(),
    Center(child: Text('Cameras Page')),
    Center(child: Text('Empty', style: TextStyle(fontSize: 24))),
    Center(child: Text('Account Page')),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Set a solid background color
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Cameras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Cloud',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),

    );
  }
}
