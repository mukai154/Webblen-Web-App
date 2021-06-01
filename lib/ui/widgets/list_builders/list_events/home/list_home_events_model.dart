import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/firestore/data/event_data_service.dart';
import 'package:webblen_web_app/services/reactive/content_filter/reactive_content_filter_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/custom_string_methods.dart';

class ListHomeEventsModel extends ReactiveViewModel {
  EventDataService _eventDataService = locator<EventDataService>();
  WebblenBaseViewModel? webblenBaseViewModel = locator<WebblenBaseViewModel>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();
  ReactiveContentFilterService _reactiveContentFilterService = locator<ReactiveContentFilterService>();

  ///HELPERS
  ScrollController scrollController = ScrollController();
  String listKey = "initial-home-events-key";

  ///FILTER DATA
  String listAreaCode = "";
  String listTagFilter = "";
  String listSortByFilter = "Latest";

  String get cityName => _reactiveContentFilterService.cityName;
  String get areaCode => _reactiveContentFilterService.areaCode;
  String get tagFilter => _reactiveContentFilterService.tagFilter;
  String get sortByFilter => _reactiveContentFilterService.sortByFilter;

  ///DATA
  List<DocumentSnapshot> dataResults = [];

  bool loadingAdditionalData = false;
  bool moreDataAvailable = true;

  int resultsLimit = 20;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveContentFilterService];

  initialize() async {
    // get content filter
    syncContentFilter();

    _reactiveContentFilterService.addListener(() {
      if (areaCode != listAreaCode || listTagFilter != tagFilter || listSortByFilter != sortByFilter) {
        syncContentFilter();
        refreshData();
      }
    });

    await loadData();
  }

  syncContentFilter() {
    listAreaCode = areaCode;
    listTagFilter = listTagFilter;
    listSortByFilter = sortByFilter;
    notifyListeners();
  }

  Future<void> refreshData() async {
    scrollController.jumpTo(scrollController.position.minScrollExtent);

    //clear previous data
    dataResults = [];
    loadingAdditionalData = false;
    moreDataAvailable = true;

    notifyListeners();
    //load all data
    await loadData();
  }

  loadData() async {
    setBusy(true);

    //load data with params
    dataResults = await _eventDataService.loadEvents(
      areaCode: areaCode,
      resultsLimit: resultsLimit,
      tagFilter: tagFilter,
      sortBy: sortByFilter,
    );

    notifyListeners();

    setBusy(false);
  }

  loadAdditionalData() async {
    //check if already loading data or no more data available
    if (loadingAdditionalData || !moreDataAvailable) {
      return;
    }

    //set loading additional data status
    loadingAdditionalData = true;
    notifyListeners();

    //load additional posts
    List<DocumentSnapshot> newResults = await _eventDataService.loadAdditionalEvents(
      lastDocSnap: dataResults[dataResults.length - 1],
      areaCode: areaCode,
      resultsLimit: resultsLimit,
      tagFilter: tagFilter,
      sortBy: sortByFilter,
    );

    //notify if no more posts available
    if (newResults.length == 0) {
      moreDataAvailable = false;
    } else {
      dataResults.addAll(newResults);
    }

    //set loading additional posts status
    loadingAdditionalData = false;
    notifyListeners();
  }

  showContentOptions(dynamic content) async {
    String val = await customBottomSheetService.showContentOptions(content: content);
    if (val == "deleted content") {
      dataResults.removeWhere((doc) => doc.id == content.id);
      listKey = getRandomString(5);
      notifyListeners();
    }
  }
}
