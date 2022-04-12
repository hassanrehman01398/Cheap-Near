import 'dart:convert';
import 'dart:io';

import 'package:cheapnear/screens/home.dart';
import 'package:cheapnear/screens/pages/home_page.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:cheapnear/animations/bottomAnimation.dart';
import 'package:cheapnear/helper/constant.dart';
import 'package:cheapnear/helper/utility.dart';
import 'package:cheapnear/model/services_model.dart';
import 'package:cheapnear/model/user.dart';
import 'package:cheapnear/states/authState.dart';
import 'package:cheapnear/states/servicesState.dart';
import 'package:cheapnear/utils/constants.dart';
import 'package:cheapnear/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PostServicesPage extends StatefulWidget {
  @override
  _PostServicesPageState createState() => _PostServicesPageState();
}

class _PostServicesPageState extends State<PostServicesPage> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController description = TextEditingController();
  var uuid = new Uuid();
  String _sessionToken;

  List<dynamic> _placeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    location.addListener(() {
      _onChanged();
    });
  }

  void _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(location.text);
  }

  void getSuggestion(String input) async {

    String kPLACES_API_KEY = "${mapapikey}";

    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(request);
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {

        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeNotifier>(builder: (context, notifier, value) {
        return ListView(
          children: [
            WidgetAnimator(
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 5,
                      child: _image != null
                          ? Image.file(_image, height: 200, width: 200)
                          : Image.asset("assets/placeholder-image.png",
                              height: 200, width: 200)),
                ),
              ),
            ),
            WidgetAnimator(
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: notifier.darkTheme ? Colors.white : primary,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: notifier.darkTheme ? Colors.white : primary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Enter Service Name",
                    )),
              ),
            ),
            WidgetAnimator(
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                    controller: price,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: notifier.darkTheme ? Colors.white : primary,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: notifier.darkTheme ? Colors.white : primary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Enter Service Price",
                    )),
              ),
            ),
            WidgetAnimator(
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  decoration: BoxDecoration(

                    border: Border.all(
                      color: notifier.darkTheme ? Colors.white : primary,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  height: 50,
                  width: double.infinity,
                  child: DropDown(
                    showUnderline: false,

                    items: service_types,

                    // initialValue: user_customer_remainder_date.text,
                    hint: Text(
                      "Select Service Type",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,

                          fontSize: 15),
                    ),
                    onChanged: (value) {
                      setState(() {
                        type.text = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            WidgetAnimator(
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                    controller: description,
                    maxLines: 3,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: notifier.darkTheme ? Colors.white : primary,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: notifier.darkTheme ? Colors.white : primary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Enter description",
                    )),
              ),
            ),
            WidgetAnimator(
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                    controller: location,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: notifier.darkTheme ? Colors.white : primary,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: notifier.darkTheme ? Colors.white : primary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Enter Service Location",
                    )),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      location.text = _placeList[index]["description"];
                      _placeList.clear();
                    });
                  },
                  child: Container(

                    decoration: BoxDecoration(

                      border: Border.all(
                        color: notifier.darkTheme ? Colors.white : primary,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    height: 50,
                    width: double.infinity,
                    child: ListTile(

                      title: Text(_placeList[index]["description"]),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            WidgetAnimator(
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    color: primary,
                    onPressed: () {
                      _submitButton();
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Post Service",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    )),
              ),
            )
          ],
        );
      }),
    );
  }

  Future<ServicesModel> createserviceModel() async {
    var authState = Provider.of<AuthState>(context, listen: false);
    var myUser = authState.userModel;
    var profilePic = myUser.profilePic ?? dummyProfilePic;

    var addresses = await Geocoder.local.findAddressesFromQuery(location.text);
    var first = addresses.first;
    double lat = first.coordinates.latitude;
    double long = first.coordinates.longitude;
    var commentedUser = UserModel(
        displayName: myUser.displayName ?? myUser.email.split('@')[0],
        profilePic: profilePic,
        userId: myUser.userId,
        isVerified: authState.userModel.isVerified,
        userName: authState.userModel.userName);
    //(id, image, name, price, lat, long, type, description, user)Model
    ServicesModel service = ServicesModel(
        "",
        name.text,
        price.text,
        lat.toString(),
        long.toString(),
        type.text,
        description.text,
        commentedUser,
    location.text,

    DateTime.now().toString(),

        authState.userModel.sellerId??"");
    return service;
  }

  void _submitButton() async {
    if (description.text == null || description.text.isEmpty) {
      return;
    }

    if (name.text == null || name.text.isEmpty) {
      return;
    }

    if (price.text == null || price.text.isEmpty) {
      return;
    }
    if (type.text == null || type.text.isEmpty) {
      return;
    }
    if (location.text == null || location.text.isEmpty) {
      return;
    }
    var state = Provider.of<Servicestate>(context, listen: false);
    kScreenloader.showLoader(context);

    ServicesModel services = await createserviceModel();

    /// If tweet contain image
    /// First image is uploaded on firebase storage
    /// After sucessfull image upload to firebase storage it returns image path
    /// Add this image path to tweet model and save to firebase database
    try {
      await state.uploadFile(_image).then((imagePath) {
        if (imagePath != null) {
          services.image = imagePath;

          /// If type of tweet is new tweet
          state.createService(services);
        }
      });
      kScreenloader.hideLoader();

      /// Navigate back to home page
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(
      )));

      /// Checks for username in tweet description
      /// If foud sends notification to all tagged user
      /// If no user found or not compost tweet screen is closed and redirect back to home page.
      // final composetweetstate =
      // Provider.of<ComposeTweetState>(context, listen: false);
      // final searchstate = Provider.of<SearchState>(context, listen: false);
      // await composetweetstate
      //     .sendNotificationwatch(watch, searchstate)
      //     .then((_) {
      //   /// Hide running loader on screen
      //   kScreenloader.hideLoader();
      //
      //   /// Navigate back to home page
      //   Navigator.pop(context);
      // });
    } catch (e) {
      print(e);
      kScreenloader.hideLoader();
    }
  }
}
