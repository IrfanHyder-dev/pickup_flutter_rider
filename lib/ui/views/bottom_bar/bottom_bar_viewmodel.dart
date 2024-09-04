import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pickup/ui/views/history/history_view.dart';
import 'package:pickup/ui/views/home/home_view.dart';
import 'package:pickup/ui/views/make_offer/make_anOffer/make_anOffer_view.dart';
import 'package:pickup/ui/views/paid_services_details/paid_services_detail_view.dart';
import 'package:pickup/ui/views/settings/settings_view.dart';
import 'package:stacked/stacked.dart';

@singleton
class BottomBarViewModel extends BaseViewModel with WidgetsBindingObserver {
  PageController? pageController = PageController(initialPage: 2);
  int maxCount = 5;
  int pageIndex = 2;

  init(int index) {
    WidgetsBinding.instance.addObserver(this);
    pageIndex = index;
    print("PAGE CONTROLLER===> ${pageController}");
    pageController!.jumpToPage(index);
    notifyListeners();
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  final List<Widget> bottomBarPages = [
    const MakeAnOfferView(),
    const PaidServicesDetailView(),
    const HomeView(),
    const HistoryView(),
    const SettingsView(),
  ];

  void onTap(int v) {
    // if (v != 3) {
      pageIndex = v;
      //if (pageController!.hasClients)
      pageController!.jumpToPage(v);
      notifyListeners();
    // }
  }

  void newPageNo(int page) {
    pageIndex = page;
    notifyListeners();
  }

// @override
// void initialise() {
//   pageIndex = 2;
//   pageController = PageController(initialPage: pageIndex);
//   notifyListeners();
// }
}
