import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';

class PlatformDataService {
  SnackbarService _snackbarService = locator<SnackbarService>();
  CollectionReference appReleaseRef = FirebaseFirestore.instance.collection("app_release_info");
  CollectionReference webblenCurrencyRef = FirebaseFirestore.instance.collection("webblen_currency");

  Future<bool> isUpdateAvailable() async {
    bool updateAvailable = false;
    String currentVersion = "9.2.1";
    DocumentSnapshot docSnapshot = await appReleaseRef.doc("general").get();
    String releasedVersion = docSnapshot.data()["versionNumber"];
    bool versionIsRequired = docSnapshot.data()["versionIsRequired"];
    if (currentVersion != releasedVersion && versionIsRequired) {
      updateAvailable = true;
    }
    return updateAvailable;
  }

  ///NEW CONTENT RATES
  Future<double> getNewPostTaxRate() async {
    double promo;
    DocumentSnapshot snapshot = await webblenCurrencyRef.doc('APP_ECONOMY').get();
    try {
      promo = snapshot.data()['newPostTaxRate'].toDouble();
    } catch (e) {
      // _snackbarService.showSnackbar(
      //   title: 'Promotion Error',
      //   message: "There Was an Issue Getting Webblen Promotions",
      //   duration: Duration(seconds: 5),
      // );
    }
    return promo;
  }

  Future<double> getNewStreamTaxRate() async {
    double promo;
    DocumentSnapshot snapshot = await webblenCurrencyRef.doc('APP_ECONOMY').get();
    try {
      promo = snapshot.data()['newStreamTaxRate'].toDouble();
    } catch (e) {
      // _snackbarService.showSnackbar(
      //   title: 'Promotion Error',
      //   message: "There Was an Issue Getting Webblen Promotions",
      //   duration: Duration(seconds: 5),
      // );
    }
    return promo;
  }

  Future<double> getNewEventTaxRate() async {
    double promo;
    DocumentSnapshot snapshot = await webblenCurrencyRef.doc('APP_ECONOMY').get();
    try {
      promo = snapshot.data()['newEventTaxRate'].toDouble();
    } catch (e) {
      // _snackbarService.showSnackbar(
      //   title: 'Promotion Error',
      //   message: "There Was an Issue Getting Webblen Promotions",
      //   duration: Duration(seconds: 5),
      // );
    }
    return promo;
  }

  ///PROMOTIONS
  Future<double> getPostPromo() async {
    double promo;
    DocumentSnapshot snapshot = await webblenCurrencyRef.doc('APP_INCENTIVES').get();
    try {
      promo = snapshot.data()['postPromo'].toDouble();
    } catch (e) {
      // _snackbarService.showSnackbar(
      //   title: 'Promotion Error',
      //   message: "There Was an Issue Getting Webblen Promotions",
      //   duration: Duration(seconds: 5),
      // );
    }
    return promo;
  }

  Future<double> getStreamPromo() async {
    double promo;
    DocumentSnapshot snapshot = await webblenCurrencyRef.doc('APP_INCENTIVES').get();
    try {
      promo = snapshot.data()['streamPromo'].toDouble();
    } catch (e) {
      // _snackbarService.showSnackbar(
      //   title: 'Promotion Error',
      //   message: "There Was an Issue Getting Webblen Promotions",
      //   duration: Duration(seconds: 5),
      // );
    }
    return promo;
  }

  Future<double> getEventPromo() async {
    double promo;
    DocumentSnapshot snapshot = await webblenCurrencyRef.doc('APP_INCENTIVES').get();
    try {
      promo = snapshot.data()['eventPromo'].toDouble();
    } catch (e) {
      // _snackbarService.showSnackbar(
      //   title: 'Promotion Error',
      //   message: "There Was an Issue Getting Webblen Promotions",
      //   duration: Duration(seconds: 5),
      // );
    }
    return promo;
  }

  Future<double> getEventTicketFee() async {
    double eventTicketFee;
    DocumentSnapshot snapshot = await appReleaseRef.doc('general').get();
    eventTicketFee = snapshot.data()['ticketFee'];
    return eventTicketFee;
  }

  Future<double> getTaxRate() async {
    double taxRate;
    DocumentSnapshot snapshot = await appReleaseRef.doc('general').get();
    taxRate = snapshot.data()['taxRate'];
    return taxRate;
  }

  Future<String> getWebblenDownloadLink() async {
    String key;
    DocumentSnapshot snapshot = await appReleaseRef.doc('webblen').get();
    key = snapshot.data()['downloadLink'];
    return key;
  }

  Future<String> getStripePubKey() async {
    String pubKey;
    DocumentSnapshot snapshot = await appReleaseRef.doc('stripe').get();
    pubKey = snapshot.data()['pubKey'];
    return pubKey;
  }

  Future<String> getAgoraAppID() async {
    String appID;
    DocumentSnapshot snapshot = await appReleaseRef.doc('agora').get();
    appID = snapshot.data()['appID'];
    return appID;
  }

  Future<String> getGoogleApiKey() async {
    String key;
    DocumentSnapshot snapshot = await appReleaseRef.doc('google').get();
    key = snapshot.data()['apiKey'];
    return key;
  }
}
