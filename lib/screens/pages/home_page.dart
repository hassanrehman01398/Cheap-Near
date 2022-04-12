import 'dart:typed_data';
import 'package:badges/badges.dart';
import 'package:cheapnear/animations/bottomAnimation.dart';
import 'package:cheapnear/helper/constant.dart';
import 'package:cheapnear/model/services_model.dart';
import 'package:cheapnear/screens/pages/service_detail.dart';
import 'package:cheapnear/states/authState.dart';
import 'package:cheapnear/states/servicesState.dart';
import 'package:cheapnear/utils/constants.dart';
import 'package:cheapnear/widgets/customWidgets.dart';
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

  //String API_KEY = apikey;

  String address;
  bool loading = true;
  CameraPosition _position;
  List<Marker> _markers = <Marker>[];
  TextEditingController editingController = TextEditingController();
  bool isService = false;
  List<ServicesModel> list, list1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocationAllServices();

    // getlocationAllServices(list);
  }

  getlocationAllServices() async {

    var servicestate = Provider.of<Servicestate>(context,listen: false);
    List<ServicesModel> services=servicestate.servicelist;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      latLng = LatLng(position.latitude, position.longitude);
      var address = addresses.first;
      this.address = address.addressLine;
      loading = false; });
      for(int i=0;i<services.length;i++) {

        final Uint8List markerIcond =
            await getBytesFromCanvas(250, 250, "assets/services/${services[i].type.toLowerCase()}.png");

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(DateTime.now().millisecondsSinceEpoch.toString()),
              position:  LatLng(double.parse(services[i].lat), double.parse(services[i].long)),
              draggable: true,
              infoWindow: InfoWindow(
                title: services[i].type,
                snippet: services[i].name,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ServiceDetail(
                          service: services[i],
                        )));
              },
              icon: BitmapDescriptor.defaultMarkerWithHue(120),
            ),
          );
        });

      }

  }

  getlocationSpecificServices(List<ServicesModel> services) async {

    setState(() {

      _markers.clear();
      list=services;

    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      latLng = LatLng(position.latitude, position.longitude);
      var address = addresses.first;
      this.address = address.addressLine;
      loading = false;

    });
    for(int i=0;i<services.length;i++) {

      // final Uint8List markerIcond =
      // await getBytesFromCanvas(100, 100, "assets/services/${services[i].type.toLowerCase()}.png");

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(DateTime.now().millisecondsSinceEpoch.toString()),
            position:  LatLng(double.parse(services[i].lat), double.parse(services[i].long)),
            draggable: true,
            infoWindow: InfoWindow(
              title: services[i].type,
              snippet: services[i].name,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ServiceDetail(
                        service: services[i],
                      )));
            },
            icon: BitmapDescriptor.defaultMarkerWithHue(120),
          ),
        );
      });

    }
  }




  @override
  Widget build(BuildContext context) {
    var authstate = Provider.of<AuthState>(context);
    var servicestate = Provider.of<Servicestate>(context);


    return Scaffold(
      backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
      WidgetAnimator(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: editingController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  list = list
                      .where((x) =>
                          (x.name != null &&
                              x.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) ||
                          (x.type != null &&
                              x.type
                                  .toLowerCase()
                                  .contains(value.toLowerCase())))
                      .toList();
                });
              } else {
                setState(() {
                  list = list1;
                });
              }
            },
            decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      isService = !isService;
                    });
                    if(isService){
                      setState(() {
                        list = servicestate.servicelist;
                        list1 = list;

                      });

                    }
                    else{

                    }
                  },
                  icon: Icon(Icons.map),),
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
                    getlocationSpecificServices(servicestate.servicelist.where((element) => element.type==service_types[index]).toList());
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
                        _markers,
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
          : WidgetAnimator(ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: list == null ? 0 : list.length,
            itemBuilder: (cyx, index) {
              return WidgetAnimator(Padding(
                padding: const EdgeInsets.all(8.0),
                child: ServiceCard(list[index]),
              ));
            },
          ))
    ])));
  }

  Widget ServiceCard(ServicesModel service) {
    return Material(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(children: [
                    Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            width: fullWidth(context) * 0.20,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 1,
                              ),
                              image: DecorationImage(
                                  image: customAdvanceNetworkImage(
                                      service.image ?? ""),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          onTap: () {},
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Text(
                                service.name,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                service.description,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                softWrap: true,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Text(
                    service.price,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  GestureDetector(
                    child: Container(
                      height: 40.0,
                      width: fullWidth(context) * 0.27,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                primary,
                                primary
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Center(
                        child: Text(
                          "View",
                        ),
                      ),
                    ),
                    onTap: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ServiceDetail(service: service,)));

                    },
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: Row(
                  children: [
                    Text("1 Bought"),
                    Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border,color: Colors.red,))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
