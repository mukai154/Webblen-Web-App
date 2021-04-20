import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/user_stripe_info.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/services/stripe/stripe_connect_account_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class PayoutMethodsViewModel extends StreamViewModel<UserStripeInfo> with ReactiveServiceMixin {
  NavigationService _navigationService = locator<NavigationService>();
  StripeConnectAccountService _stripeConnectAccountService = locator<StripeConnectAccountService>();
  CustomBottomSheetService _customBottomSheetService = locator<CustomBottomSheetService>();
  // StripePaymentService? _stripePaymentService = locator<StripePaymentService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();

  ///CURRENT USER
  UserStripeInfo? _userStripeInfo;
  UserStripeInfo? get userStripeInfo => _userStripeInfo;
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  bool stripeAccountIsSetup = false;
  bool dismissedSetupAccountNotice = false;

  bool retrievingAccountStatus = true;
  bool retrievedAccountStatus = false;

  initialize() {
    setBusy(true);
  }

  ///STREAM DATA
  @override
  void onData(UserStripeInfo? data) {
    if (data != null) {
      if (data.isValid()) {
        _userStripeInfo = data;
        notifyListeners();
        setBusy(false);
      }
    }
  }

  @override
  Stream<UserStripeInfo> get stream => streamUserStripeInfo();

  Stream<UserStripeInfo> streamUserStripeInfo() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      UserStripeInfo stripeInfo = UserStripeInfo();
      stripeInfo = await _stripeConnectAccountService.getStripeConnectAccountByUID(user.id);
      if (stripeInfo.isValid() && !retrievedAccountStatus && !retrievingAccountStatus) {
        retrieveAndUpdateStripeAccountStatus();
      }
      yield stripeInfo;
    }
  }

  retrieveAndUpdateStripeAccountStatus() async {
    retrievingAccountStatus = true;
    notifyListeners();
    Map<String, dynamic> accountStatus = await _stripeConnectAccountService.retrieveWebblenStripeAccountStatus(uid: user.id!);

    if (accountStatus.isNotEmpty) {
      await _stripeConnectAccountService.updateStripeAccountStatus(uid: user.id!, accountStatus: accountStatus);
    }

    retrievingAccountStatus = false;
    retrievedAccountStatus = true;
    notifyListeners();
  }

  ///NAVIGATION
  navigateToSetUpDirectDepositView() {
    _navigationService.navigateTo(Routes.SetUpDirectDepositViewRoute);
  }

  navigateToSetUpInstantDepositView() {
    _navigationService.navigateTo(Routes.SetUpInstantDepositViewRoute);
  }

  navigateToCreateEventPage() {
    // _navigationService.navigateTo(Routes.CreateEventViewRoute);
  }
}
