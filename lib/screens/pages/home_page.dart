import 'package:cheapnear/animations/bottomAnimation.dart';
import 'package:cheapnear/helper/constant.dart';
import 'package:cheapnear/model/category_model.dart';
import 'package:cheapnear/model/services_model.dart';
import 'package:cheapnear/screens/pages/service_detail.dart';
import 'package:cheapnear/states/authState.dart';
import 'package:cheapnear/states/servicesState.dart';
import 'package:cheapnear/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng latLng;
  double pLat, pLong;
  Iterable markers = [];

  //String API_KEY = apikey;

  String address;
  bool loading = true;
  CameraPosition _position;
  List<Marker> _markers = <Marker>[];
  TextEditingController editingController = TextEditingController();
  bool isService = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocation();
  }

  getlocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      latLng = LatLng(position.latitude, position.longitude);
      var address = addresses.first;
      print(address.addressLine);
      this.address = address.addressLine;
      loading = false;
      _markers.add(
        Marker(
          markerId: MarkerId('1'),
          position: latLng,
          draggable: true,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    var authstate = Provider.of<AuthState>(context);
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      WidgetAnimator(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: editingController,
            decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
        ),
      ),
      WidgetAnimator(Container(
        height: 50,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: service_types.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputChip(
                  backgroundColor: primary,
                  onPressed: () {


                  },
                  label: Text(
                    service_types[index],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }),
      )),
      isService == false
          ? WidgetAnimator(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: GoogleMap(
                      //onMapCreated: _onMapCreated(),
                      markers: Set.from(
                        markers,
                      ),
                      initialCameraPosition: latLng == null
                          ? CameraPosition(
                              target: LatLng(24.7976208, 67.0328722))
                          : CameraPosition(target: latLng, zoom: 14.0),
                      mapType: MapType.terrain,
                      myLocationEnabled: true,
                    ),
                  ),
                ),
              ),
            )
          : WidgetAnimator(Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Consumer<Servicestate>(builder: (context, state, child) {
                final List<ServicesModel> list =
                    state.getmyServicesList(authstate.userModel);
                return GridView.builder(
                  primary: false,
                  itemCount: list==null?0:list.length,
                  itemBuilder: (cyx, index) {
                    return WidgetAnimator(Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: GridTile(
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ServiceDetail(service: list[index],)));
                              },
                              child: Hero(
                                tag: list[index].id,
                                child: FadeInImage(
                                  placeholder: AssetImage(
                                      "assets/placeholder-image.png"),
                                  image: NetworkImage(list[index].image),
                                  fit: BoxFit.cover,
                                ),
                              )),
                          footer: GridTileBar(
                            backgroundColor: Colors.black87,
                            leading: IconButton(
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () {}),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.chat,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: () {},
                            ),
                            title: Text(
                              list[index].price,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ));
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                );
              })))
    ])));
  }
}
