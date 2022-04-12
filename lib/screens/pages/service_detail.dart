import 'dart:developer';

import 'package:cheapnear/animations/bottomAnimation.dart';
import 'package:cheapnear/message/chatScreenPage.dart';
import 'package:cheapnear/model/services_model.dart';
import 'package:cheapnear/payment/pages/checkout.dart';
import 'package:cheapnear/payment/pages/pay-out.dart';
import 'package:cheapnear/payment/services/stripe-backend-service.dart';
import 'package:cheapnear/states/chats/chatState.dart';
import 'package:cheapnear/utils/constants.dart';
import 'package:cheapnear/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

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
      backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: primary,
          title: Text(widget.service.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),),
        ),
        body: Consumer<ThemeNotifier>(
          builder: (context,notifier,value){
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                    Row(children: [
                      Text("Service Name : ",style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
                      WidgetAnimator(Text(widget.service.name,)),

                    ],),
                    SizedBox(height: 10,),
                    Row(children: [
                      Text("Description : ",style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
                      WidgetAnimator(
                        Center(
                          child: Text(widget.service.description),
                        ),
                      ),

                    ],),
                    SizedBox(height: 10,),
                    Row(children: [

                      Text("Location : ",style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
                      WidgetAnimator(Text(widget.service.location)),

                    ],),
                    SizedBox(height: 10,),
                    Row(children: [

                      Text("Type : ",style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
                      WidgetAnimator(Text("Type: "+widget.service.type)),

                    ],),

                    SizedBox(height: 10,),

                    Row(
                      children: [
                        Text("Price : ",style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
                        WidgetAnimator(Text(widget.service.price)),
                      ],
                    ),
                    SizedBox(height: 10,),
                    WidgetAnimator(
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Expanded(
                              child: WidgetAnimator(
                                FlatButton.icon(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5))
                                    ),
                                    color: Colors.green,
                                    onPressed: ()  {
                                      launch("tel://21213123123");
                                    },
                                    icon: Icon(Icons.call,color: Colors.white,),
                                    label: Text("Call me",style: TextStyle(color: Colors.white),)),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Expanded(
                              child: WidgetAnimator(
                                FlatButton.icon(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5))
                                    ),
                                    color: Colors.blue,
                                    onPressed: () async {
                                      ProgressDialog pd = ProgressDialog(context: context);
                                      pd.show(
                                        max: 100,
                                        msg: 'Please wait...',
                                        progressBgColor: Colors.transparent,
                                      );
                                      try {
                                        Product product=Product();
                                        product.price=double.parse(widget.service.price);
                                      //  product.image=widget.service.image;
                                        product.title=widget.service.name;
                                        product.currency="usd";
                                        CheckoutSessionResponse response = await StripeBackendService.payForProduct(product, widget.service.sellerId);
                                        pd.close();
                                        String sessionId = response.session['id'];
                                        Future.delayed(Duration(milliseconds: 300), () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => CheckoutPage(sessionId: sessionId),
                                          ))
                                              .then((value) {
                                            if (value == 'success') {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  new SnackBar(
                                                    content: Text('Payment Successful'),
                                                    backgroundColor: Colors.green,
                                                  )
                                              );
                                            } else if (value == 'cancel') {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  new SnackBar(
                                                      content: Text('Payment Failed or Cancelled'),
                                                      backgroundColor: Colors.red
                                                  )
                                              );
                                            }
                                          });
                                        });
                                      } catch (e) {
                                        log(e.toString());
                                        pd.close();
                                      }
                                    },
                                    icon: Icon(Icons.payment,color: Colors.white,),
                                    label: Text("Buy now",style: TextStyle(color: Colors.white),)),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Expanded(
                              child: WidgetAnimator(
                                FlatButton.icon(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5))
                                    ),
                                    color: Colors.red,
                                    onPressed: (){
                                      final chatState = Provider.of<ChatState>(context, listen: false);
                                      chatState.setChatUser = widget.service.user;
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreenPage(
                                      )));
                                    }, icon: Icon(Icons.chat,color: Colors.white,), label: Text("Start Chat",style: TextStyle(color: Colors.white),)),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
    );
  }
}