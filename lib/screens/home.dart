import 'package:cheapnear/screens/pages/all_services.dart';
import 'package:cheapnear/screens/pages/chat_screen.dart';
import 'package:cheapnear/screens/pages/home_page.dart';
import 'package:cheapnear/screens/pages/post_service.dart';
import 'package:cheapnear/screens/pages/profile.dart';
import 'package:cheapnear/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String,Object>> _pages;
  int _selectedPageIndex = 0;

  void _selectPage(int index){
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pages = [
      {'page': HomePage(), 'title': 'Home'},
      {'page': ChatPage(), 'title': 'Chats'},
      {'page': PostServicesPage(), 'title': 'Post'},
      {'page': ServicesPage(), 'title': 'All Services'},
      {'page': ProfilePage(), 'title': 'Profile'}
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset("assets/logo.png",height: 30,width: 30,),
          ),
        ),
        title: Text("Cheapnear",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),),
        actions: [
          IconButton(icon: Icon(Icons.exit_to_app,color: Colors.white,), onPressed: (){})
        ],
      ),

      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        backgroundColor: primary,
        currentIndex: _selectedPageIndex,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: primary,
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            backgroundColor: primary,
            icon: Icon(Icons.chat),
            title: Text('Chats'),
          ),
          BottomNavigationBarItem(
            backgroundColor: primary,
            icon: Icon(Icons.post_add),
            title: Text('Post Service'),
          ),
          BottomNavigationBarItem(
            backgroundColor: primary,
            icon: Icon(Icons.design_services),
            title: Text('Services'),
          ),
          BottomNavigationBarItem(
            backgroundColor: primary,
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
