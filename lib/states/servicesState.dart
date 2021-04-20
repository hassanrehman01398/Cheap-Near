import 'dart:async';
import 'dart:io';
import 'package:cheapnear/helper/utility.dart';
import 'package:cheapnear/model/services_model.dart';
import 'package:cheapnear/model/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

import 'appState.dart';
// import 'authState.dart';

class Servicestate extends AppState {
  bool isBusy = false;
  List<ServicesModel> _services=List<ServicesModel>();


  List<ServicesModel> _favouritesservices=List<ServicesModel>();



  /// `feedlist` always [contain all tweets] fetched from firebase database
  List<ServicesModel> get servicelist {
    if (_services == null) {
      return null;
    } else {
      return List.from(_services);
    }
  }
  List<ServicesModel> get favouritesservices {
    if (_favouritesservices == null) {
      return null;
    } else {
      return _favouritesservices;
    }
  }

  /// contain tweet list for home page
  List<ServicesModel> getServicesList(UserModel userModel) {
    if (userModel == null) {
      return null;
    }

    List<ServicesModel> list;

    if (!isBusy && _services != null && _services.isNotEmpty) {
      list = _services.where((x) {
        /// If Tweet is a comment then no need to add it in tweet list
        if (x.id != null) {
          return false;
        }

        /// Only include Tweets of logged-in user's and his following user's
        if (x.user.userId != userModel.userId) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<ServicesModel> getmyServicesList(UserModel userModel) {

    if (userModel == null) {
      return null;
    }
    List<ServicesModel> list;

    if ( _services != null && _services.isNotEmpty) {

      list = _services.where((x) {

        /// If Tweet is a comment then no need to add it in tweet list

        if (x.id == null) {

          return false;
        }

        /// Only include Tweets of logged-in user's and his following user's
        if (x.user.userId == userModel.userId) {

          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }
  /// set tweet for detail tweet page
  /// Setter call when tweet is tapped to view detail
  /// Add Tweet detail is added in _tweetDetailModelList
  /// It makes `Fwitter` to view nested Tweets


  /// `remove` last Tweet from tweet detail page stack
  /// Function called when navigating back from a Tweet detail
  /// `_tweetDetailModelList` is map which contain lists of commment Tweet list
  /// After removing Tweet from Tweet detail Page stack its commnets tweet is also removed from `_tweetDetailModelList`


  /// get [Tweet list] from firebase realtime database
  void getDataFromDatabase() {
    try {
      isBusy = true;
      _services = null;
      notifyListeners();
      kDatabase.child('services').once().then((DataSnapshot snapshot) {
        _services = List<ServicesModel>();
        if (snapshot.value != null) {
          var map = snapshot.value;

          if (map != null) {
            map.forEach((key, value) {
              var model = ServicesModel.fromJson(value);
              model.id = key;

                _services.add(model);
                          });

            /// Sort Tweet by time
            /// It helps to display newest Tweet first.
            // _services.sort((x, y) => DateTime.parse(x.createdAt)
            //     .compareTo(DateTime.parse(y.createdAt)));
          }
        } else {
          _services = null;
        }
        isBusy = false;
        notifyListeners();
      });
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }
  void getFavouritesFromDatabase(String userId) {
    try {
      isBusy = true;
      _favouritesservices = null;
      notifyListeners();
      kDatabase.child('favourites').child(userId).once().then((DataSnapshot snapshot) {
        _favouritesservices = List<ServicesModel>();
        if (snapshot.value != null) {
          var map = snapshot.value;
          if (map != null) {
            map.forEach((key, value) {
              print(key);
              print(value);
              var model = ServicesModel.fromJson(value);
              model.id = key;
                _favouritesservices.add(model);

            });

            /// Sort Tweet by time
            /// It helps to display newest Tweet first.
            _favouritesservices.sort((x, y) => DateTime.parse(x.createdAt)
                .compareTo(DateTime.parse(y.createdAt)));
          }
        } else {
          _favouritesservices = List<ServicesModel>();
        }
        isBusy = false;
        notifyListeners();
      });
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }
  void removeFromFavourites(String userId,String favId,ServicesModel servicesModel){
    try{
      isBusy = true;
      kDatabase.child('favourites').child(userId).child(favId).remove();
      _favouritesservices.removeAt(
          _favouritesservices.indexWhere((element) => element.id==servicesModel.id));
      notifyListeners();
      isBusy = false;

    }catch(error){

      isBusy = false;
      cprint(error, errorIn: 'errorRemovingFromDatabase');
    }

  }

  /// create [New Tweet]

  createService(ServicesModel model) {
    ///  Create tweet in [Firebase kDatabase]
    isBusy = true;
    notifyListeners();
    String key=DateTime.now().millisecondsSinceEpoch.toString();
    model.id=key;
    try {
      kDatabase.child('services').child(key).set(model.toJson());
      _services.add(model);

notifyListeners();
    } catch (error) {
      cprint(error, errorIn: 'createService');
    }
    isBusy = false;
    notifyListeners();
  }
  createFavourite(ServicesModel services,String userId){
    isBusy = true;
    notifyListeners();
    try {
      // String favId=DateTime.now().millisecondsSinceEpoch.toString();
      // feed.key=favId;
      kDatabase.child('favourites').child(userId).child(services.id).set(services.toJson());
      _favouritesservices.add(services);

    } catch (error) {
      cprint(error, errorIn: 'createFavourite');
    }
    isBusy = false;
    notifyListeners();

  }

  ///  It will create tweet in [Firebase kDatabase] just like other normal tweet.
  ///  update retweet count for retweet model



  deleteService(ServicesModel model) {
    try {
      /// Delete tweet if it is in nested tweet detail page
      kDatabase.child('services').child(model.id).remove().then((_) {
        if(_services.contains(model)) {
          _services.remove(model);
        }
          cprint('service deleted');
       notifyListeners();
      });
    } catch (error) {
      cprint(error, errorIn: 'deleteservice');
    }
  }
  /// upload [file] to firebase storage and return its  path url
  Future<String> uploadFile(File file) async {
    try {
      isBusy = true;
      notifyListeners();
      var storageReference = FirebaseStorage.instance
          .ref()
          .child("services")
          .child(Path.basename(file.path));
      await storageReference.putFile(file);

      var url = await storageReference.getDownloadURL();
      if (url != null) {
        return url;
      }
      return null;
    } catch (error) {
      cprint(error, errorIn: 'uploadFile');
      return null;
    }
  }

  /// [Delete file] from firebase storage
  Future<void> deleteFile(String url, String baseUrl) async {
    try {
      var filePath = url.split(".com/o/")[1];
      filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
      filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
      //  filePath = filePath.replaceAll('tweetImage/', '');
      cprint('[Path]' + filePath);
      var storageReference = FirebaseStorage.instance.ref();
      await storageReference.child(filePath).delete().catchError((val) {
        cprint('[Error]' + val);
      }).then((_) {
        cprint('[Sucess] Image deleted');
      });
    } catch (error) {
      cprint(error, errorIn: 'deleteFile');
    }
  }

  /// [update] tweet

  updateService(ServicesModel model) async {

    await kDatabase.child('services').child(model.id).set(model.toJson());

    notifyListeners();
    getDataFromDatabase();

  }
  /// Add/Remove like on a Tweet
  /// [postId] is tweet id, [userId] is user's id who like/unlike Tweet


  /// Add [new comment tweet] to any tweet
  /// Comment is a Tweet itself


}
