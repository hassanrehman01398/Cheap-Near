

import 'package:cheapnear/payment/router/pages_config.dart';
import 'package:flutter/material.dart';

enum PageState {
  none,
  addPage,
  addAll,
  addWidget,
  pop,
  replace,
  replaceAll
}

class PageAction {
  PageState state;
  PageConfiguration page;
  List<PageConfiguration> pages;
  Widget widget;

  PageAction({this.state = PageState.none, this.page, this.pages, this.widget});
}
class AppState extends ChangeNotifier {
  PageAction _currentAction = PageAction();
  PageAction get currentAction => _currentAction;
  set currentAction(PageAction action) {
    _currentAction = action;
    notifyListeners();
  }
  String _accountId = 'acct_1KklPfGg071cY2MT';
  String get accountId => _accountId;
  set accountId(String id) {
    _accountId = id;
    notifyListeners();
  }

  AppState();

  void goToRegister() {
    _currentAction = PageAction(state: PageState.addPage, page: registerPageConfig);
    notifyListeners();
  }

  void goToRegisterSuccess() {
    _currentAction = PageAction(state: PageState.addPage, page: registerSuccessPageConfig);
    notifyListeners();
  }

  void goToPayOut() {
    _currentAction = PageAction(state: PageState.addPage, page: payOutPageConfig);
    notifyListeners();
  }

  void resetCurrentAction() {
    _currentAction = PageAction();
  }

}