import 'package:cheapnear/message/chatListPage.dart';
import 'package:cheapnear/profile/profilePage.dart';
import 'package:cheapnear/screens/login.dart';
import 'package:cheapnear/screens/pages/all_services.dart';
import 'package:cheapnear/screens/pages/home_page.dart';
import 'package:cheapnear/screens/pages/post_service.dart';
import 'package:cheapnear/states/appState.dart';
import 'package:cheapnear/states/authState.dart';
import 'package:cheapnear/states/chats/chatState.dart';
import 'package:cheapnear/states/searchState.dart';
import 'package:cheapnear/states/servicesState.dart';
import 'package:cheapnear/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String,Object>> _pages;
  int _selectedPageIndex = 0;


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void _selectPage(int index){
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = Provider.of<AppState>(context, listen: false);
      state.setpageIndex = 0;
      initProfile();
      initServices();
      initSearch();
      initChat();
    });
    // TODO: implement initState
    super.initState();
    _pages = [
      {'page': HomePage(), 'title': 'Home'},
      {'page': ChatListPage(scaffoldKey: _scaffoldKey), 'title': 'Chats'},
      {'page': PostServicesPage(), 'title': 'Post'},
      {'page': ServicesPage(), 'title': 'All Services'},
      {'page': ProfilePage(), 'title': 'Profile'}
    ];

  }
  void initServices(){

    var servicestate = Provider.of<Servicestate>(context, listen: false);
   servicestate.getDataFromDatabase();

  //  servicestate.getFavouritesFromDatabase(authstate.user.uid);
  }
  void initProfile() {
    var state = Provider.of<AuthState>(context, listen: false);
    state.databaseInit();
  }

  void initSearch() {
    var searchState = Provider.of<SearchState>(context, listen: false);
    searchState.getDataFromDatabase();
  }


  void initChat() {
    final chatState = Provider.of<ChatState>(context, listen: false);
    final state = Provider.of<AuthState>(context, listen: false);
    chatState.databaseInit(state.userId, state.userId);

    /// It will update fcm token in database
    /// fcm token is required to send firebase notification
    state.updateFCMToken();

    /// It get fcm server key
    /// Server key is required to configure firebase notification
    /// Without fcm server notification can not be sent
    chatState.getFCMServerKey();
  }
  @override
  Widget build(BuildContext context) {

    var authstate = Provider.of<AuthState>(context);
    return Scaffold(
      key: _scaffoldKey,
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
          GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Cheapnear"),
                    content: Text("Do you want to logout?"),
                    actions: [
                      FlatButton(
                        child: Text("Yes"),
                        onPressed: () {
                          authstate.logoutCallback();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Login()),
                                  (Route<dynamic> route) => false);
                          // exit(0);
                        },
                      ),
                      FlatButton(
                        child: Text("No"),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
              child: IconButton(icon: Icon(Icons.exit_to_app,color: Colors.white,), onPressed: (){}))
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
