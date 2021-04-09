import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/firestore/data/live_stream_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';

class LiveStreamBlockViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  LiveStreamDataService _liveStreamDataService = locator<LiveStreamDataService>();
  UserDataService _userDataService = locator<UserDataService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();

  bool isLive = false;
  bool savedStream = false;
  String? hostImageURL = "";
  String? hostUsername = "";

  initialize(WebblenLiveStream stream) async {
    setBusy(true);

    //check if user saved event
    if (_reactiveWebblenUserService.userLoggedIn) {
      if (stream.savedBy!.contains(_reactiveWebblenUserService.user.id)) {
        savedStream = true;
      }
    }

    //check if event is happening now
    isStreamLive(stream);

    WebblenUser author = await _userDataService.getWebblenUserByID(stream.id);
    if (author.isValid()) {
      hostImageURL = author.profilePicURL;
      hostUsername = author.username;
    }
    notifyListeners();
    setBusy(false);
  }

  isStreamLive(WebblenLiveStream stream) {
    int currentDateInMilli = DateTime.now().millisecondsSinceEpoch;
    int eventStartDateInMilli = stream.startDateTimeInMilliseconds!;
    int? eventEndDateInMilli = stream.endDateTimeInMilliseconds;
    if (currentDateInMilli >= eventStartDateInMilli && currentDateInMilli <= eventEndDateInMilli!) {
      isLive = true;
    } else {
      isLive = false;
    }
    notifyListeners();
  }

  saveUnsaveStream({String? streamID}) async {
    if (savedStream) {
      savedStream = false;
    } else {
      savedStream = true;
    }
    HapticFeedback.lightImpact();
    notifyListeners();
    await _liveStreamDataService.saveUnsaveStream(uid: _reactiveWebblenUserService.user.id, streamID: streamID, savedStream: savedStream);
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
  navigateToStreamView(String? id) async {
    _navigationService!.navigateTo(Routes.LiveStreamViewRoute(id: id));
  }

  navigateToUserView(String? id) {
    _navigationService!.navigateTo(Routes.UserProfileView(id: id));
  }
}