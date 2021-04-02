import 'package:cheapnear/animations/bottomAnimation.dart';
import 'package:cheapnear/model/services_model.dart';
import 'package:cheapnear/screens/pages/service_detail.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      primary: false,
      itemCount: services.length,
      itemBuilder: (cyx, index) {
        return WidgetAnimator(
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GridTile(
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetail(
                      id: services[index].id,
                      name: services[index].name,
                      image: services[index].image,
                      type: services[index].type,
                      price: services[index].price,
                      description: services[index].description,
                      location: services[index].locations,
                    )));
                  },
                  child: Hero(
                    tag:services[index].id,
                    child: FadeInImage(
                      placeholder: AssetImage("assets/placeholder-image.png"),
                      image: NetworkImage(services[index].image),
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
                  onPressed: () {
                  }
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.chat,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                  },
                ),
                title: Text(
                  services[index].price,
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
  }
}
