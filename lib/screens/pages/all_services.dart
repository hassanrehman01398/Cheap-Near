import 'package:cheapnear/animations/bottomAnimation.dart';
import 'package:cheapnear/model/services_model.dart';
import 'package:cheapnear/screens/pages/service_detail.dart';
import 'package:cheapnear/screens/pages/update_service.dart';
import 'package:cheapnear/states/authState.dart';
import 'package:cheapnear/states/servicesState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweetalert/sweetalert.dart';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {

  @override
  Widget build(BuildContext context) {

    var authstate = Provider.of<AuthState>(context);


    return Consumer<Servicestate>(builder: (context, state, child)
    {
      final List<ServicesModel> list = state.getmyServicesList(authstate.userModel);

    return GridView.builder(
      primary: false,
      itemCount: list==null?0:list.length,
      itemBuilder: (cyx, index) {
        return WidgetAnimator(
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GridTile(
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateServicesPage(
                      service: list[index],

                    )));
                  },
                  child: Hero(
                    tag:list[index].id,
                    child: FadeInImage(
                      placeholder: AssetImage("assets/placeholder-image.png"),
                      image: NetworkImage(list[index].image),
                      fit: BoxFit.cover,
                    ),
                  )),
              footer: GridTileBar(
                backgroundColor: Colors.black87,
                leading: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateServicesPage(
                      service: list[index],

                    )));
                  }
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    SweetAlert.show(context,
                        title: "Delete",
                        subtitle: "Are you sure you want to delete this?",
                        style: SweetAlertStyle.confirm,
                        showCancelButton: true, onPress: (bool isConfirm) {
                          if (isConfirm) {
                            state.deleteService(list[index]);
                            SweetAlert.show(context,style: SweetAlertStyle.success,title: "Success");
                            // return false to keep dialog
                            return false;
                          }
                        });
                  },
                ),
                title: Text(
                  list[index].name,
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
  });
  }
}
