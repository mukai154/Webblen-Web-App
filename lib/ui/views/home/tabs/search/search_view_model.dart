import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/app/router.gr.dart';
import 'package:webblen_web_app/models/search_result.dart';
import 'package:webblen_web_app/services/algolia/algolia_search_service.dart';
import 'package:webblen_web_app/services/auth/auth_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/ui/views/home/tabs/search/recent_search_view_model.dart';

class SearchViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  AlgoliaSearchService _algoliaSearchService = locator<AlgoliaSearchService>();
  UserDataService _userDataService = locator<UserDataService>();
  RecentSearchViewModel _recentSearchViewModel = locator<RecentSearchViewModel>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();

  ///HELPERS
  TextEditingController searchTextController = TextEditingController();

  ///SEARCH
  List recentSearchTerms = [];
  List<SearchResult> streamResults = [];
  List<SearchResult> eventResults = [];
  List<SearchResult> userResults = [];

  int streamResultsLimit = 5;
  int eventResultsLimit = 5;
  int userResultsLimit = 5;

  ///DATA

  initialize({String term}) async {
    setBusy(true);

    //check if user clicked recently searched term
    if (term != null && term.trim().isNotEmpty) {
      searchTextController.text = term;
      querySearchResults(term);
    }

    //get recent search
    recentSearchTerms = _recentSearchViewModel.recentSearchTerms;

    notifyListeners();
    setBusy(false);
  }

  querySearchResults(String searchTerm) async {
    await Future.delayed(Duration(seconds: 1));
    if (searchTextController.text != searchTerm) {
      return;
    }
    setBusy(true);
    if (searchTerm == null || searchTerm.trim().isEmpty) {
      streamResults = [];
      eventResults = [];
      userResults = [];
    } else {
      streamResults = await _algoliaSearchService.searchStreams(searchTerm: searchTerm, resultsLimit: streamResultsLimit);
      eventResults = await _algoliaSearchService.searchEvents(searchTerm: searchTerm, resultsLimit: eventResultsLimit);
      userResults = await _algoliaSearchService.searchUsers(searchTerm: searchTerm, resultsLimit: userResultsLimit);
    }
    notifyListeners();
    setBusy(false);
  }

  ///NAVIGATION
  viewAllResultsForSearchTerm({BuildContext context, String searchTerm}) async {
    if (searchTerm.trim().isNotEmpty) {
      searchTextController.text = searchTerm;
      notifyListeners();
      _algoliaSearchService.storeSearchTerm(uid: webblenBaseViewModel.uid, searchTerm: searchTerm);
      await _navigationService.navigateTo(Routes.AllSearchResultsViewRoute(term: searchTerm));
      searchTextController.selection = TextSelection(baseOffset: 0, extentOffset: searchTextController.text.length);
      FocusScope.of(context).previousFocus();
    }
  }

  navigateToCauseView(String id) {
    //_navigationService.navigateTo(Routes.CauseViewRoute, arguments: {'id': id});
  }

  navigateToUserView(Map<String, dynamic> userData) {
    //_algoliaSearchService.storeSearchTerm(uid: webblenBaseViewModel.uid, searchTerm: userData['username']);
    _navigationService.navigateTo(Routes.UserProfileView(id: userData['id']));
  }

  navigateToLiveStreamView(Map<String, dynamic> streamData) {
    //_algoliaSearchService.storeSearchTerm(uid: webblenBaseViewModel.uid, searchTerm: streamData['name']);
    //_navigationService.navigateTo(Routes.LiveStreamViewRoute, arguments: {'id': streamData['id']});
  }

  navigateToEventView(Map<String, dynamic> eventData) {
    //_algoliaSearchService.storeSearchTerm(uid: webblenBaseViewModel.uid, searchTerm: eventData['name']);
    //_navigationService.navigateTo(Routes.EventViewRoute, arguments: {'id': eventData['id']});
  }

  clearSearchTextField() {
    searchTextController.clear();
  }
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
