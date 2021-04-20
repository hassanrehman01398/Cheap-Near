import 'package:cheapnear/animations/bottomAnimation.dart';
import 'package:cheapnear/message/chatScreenPage.dart';
import 'package:cheapnear/model/services_model.dart';
import 'package:cheapnear/states/chats/chatState.dart';
import 'package:cheapnear/utils/constants.dart';
import 'package:cheapnear/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceDetail extends StatefulWidget {
final ServicesModel service;
  const ServiceDetail({Key key,this.service}) : super(key: key);

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
          title: Text(widget.service.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),),
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
                      tag: widget.service.id,
                      child: Image.network(
                        widget.service.image,
                        fit:BoxFit.cover,
                      ),
                    ),
                  ),
                  // SizedBox(height: 10,),
                  // WidgetAnimator(Text("\$ "+widget.price.toString(),style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 25),)),
                  SizedBox(height: 10,),
                  WidgetAnimator(Text(widget.service.name,style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                  SizedBox(height: 10,),
                  WidgetAnimator(Text("Location: "+widget.service.location,style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,)),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      WidgetAnimator(Text("Price: "+widget.service.price,style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                      WidgetAnimator(Text("Type: "+widget.service.type,style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  WidgetAnimator(
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Container(
                          width: 400,
                          child: Text("Description: "+widget.service.description,style: TextStyle(fontSize: 16,color: notifier.darkTheme ? primary:Colors.white),textAlign: TextAlign.center,),
                        ),
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
                                onPressed: (){
                                  final chatState = Provider.of<ChatState>(context, listen: false);
                                  chatState.setChatUser = widget.service.user;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreenPage(
                                  )));
                                }, icon: Icon(Icons.chat,color: Colors.white,), label: Text("Start Chat",style: TextStyle(color: Colors.white),)),
                          ),
                          SizedBox(width: 20,),

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