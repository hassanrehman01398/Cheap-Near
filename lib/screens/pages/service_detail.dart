import 'package:cheapnear/animations/bottomAnimation.dart';
import 'package:cheapnear/utils/constants.dart';
import 'package:cheapnear/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceDetail extends StatefulWidget {
  final String id;
  final String name;
  final String image;
  final String price;
  final String type;
  final String location;
  final String description;

  const ServiceDetail({Key key, this.id, this.name, this.image, this.price, this.type, this.location, this.description}) : super(key: key);

   @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: primary,
          title: Text(widget.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),),
        ),
        body: Consumer<ThemeNotifier>(
          builder: (context,notifier,value){
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: Hero(
                      tag: widget.id,
                      child: Image.network(
                        widget.image,
                        fit:BoxFit.cover,
                      ),
                    ),
                  ),
                  // SizedBox(height: 10,),
                  // WidgetAnimator(Text("\$ "+widget.price.toString(),style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 25),)),
                  SizedBox(height: 10,),
                  WidgetAnimator(Text(widget.name,style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                  SizedBox(height: 10,),
                  WidgetAnimator(Text(widget.location,style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      WidgetAnimator(Text(widget.price,style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                      WidgetAnimator(Text(widget.type,style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  WidgetAnimator(
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: 400,
                        child: Text(widget.description,style: TextStyle(fontSize: 16,color: notifier.darkTheme ? primary:Colors.white),textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                  WidgetAnimator(
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetAnimator(
                            FlatButton.icon(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                color: Colors.red,
                                onPressed: (){}, icon: Icon(Icons.chat,color: Colors.white,), label: Text("Start Chat",style: TextStyle(color: Colors.white),)),
                          ),
                          SizedBox(width: 20,),
                          WidgetAnimator(
                            FlatButton.icon(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                color: Colors.green,
                                onPressed: (){}, icon: Icon(Icons.favorite_border,color: Colors.white,), label: Text("Add To Favourite",style: TextStyle(color: Colors.white),)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )
    );
  }
}