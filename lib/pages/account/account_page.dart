import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/webblen_user.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/widgets/common/alerts/custom_alerts.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/containers/round_container.dart';
import 'package:webblen_web_app/widgets/common/images/round_pic.dart';
import 'package:webblen_web_app/widgets/common/state/zero_state_view.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';
import 'package:webblen_web_app/widgets/layout/centered_view.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File newUserImg;
  Uint8List newUserImgByteMemory;

  logOut() async {
    CustomAlerts().showLoadingAlert(context, "Logging Out...");
    FirebaseAuthenticationService().signOut().then((error) {
      Navigator.pop(context);
      if (error != null) {
        CustomAlerts().showErrorAlert(context, "There Was an Issue Logging Out", error);
      }
    });
  }

  uploadImage(String uid) async {
    File file;
    FileReader fileReader = FileReader();
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      file = uploadInput.files.first;
      fileReader.readAsDataUrl(file);
      fileReader.onLoadEnd.listen((event) {
        print(file.size);
        if (file.size > 5000000) {
          CustomAlerts().showErrorAlert(context, "File Size Error", "File Size Cannot Exceed 5MB");
        } else if (file.type == "image/jpg" || file.type == "image/jpeg" || file.type == "image/png") {
          String base64FileString = fileReader.result.toString().split(',')[1];
          CustomAlerts().showLoadingAlert(context, "Uploading Image...");
          //COMPRESS FILE HERE
          WebblenUserData().updateUserImg(file, uid).then((error) {
            Navigator.pop(context);
            if (error.isNotEmpty) {
              CustomAlerts().showErrorAlert(context, "Image Upload Error", error);
            } else {
              setState(() {
                newUserImg = file;
                newUserImgByteMemory = base64Decode(base64FileString);
              });
            }
          });
        } else {
          CustomAlerts().showErrorAlert(context, "Image Upload Error", "Please Upload a Valid Image");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return CenteredView(
      child: user == null
          ? Container()
          : user.isAnonymous
              ? ZeroStateView(
                  title: "You Are Not Logged In",
                  desc: "Please Finish Login to Continue",
                  buttonTitle: "Login",
                  buttonAction: () => locator<NavigationService>().navigateTo(AccountLoginRoute),
                )
              : StreamBuilder<WebblenUser>(
                  stream: WebblenUserData().streamCurrentUser(user.uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return ZeroStateView(
                        title: "Account Setup Required",
                        desc: "Please Finish Setting Up Your Account to Continue",
                        buttonTitle: "Complete Account Setup",
                        buttonAction: () => locator<NavigationService>().navigateTo(AccountSetupRoute),
                      );
                    WebblenUser currentUser = snapshot.data;
                    //print(currentUser);
                    return CenteredView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 32.0,
                          ),
                          GestureDetector(
                            onTap: () => uploadImage(user.uid),
                            child: Stack(
                              children: <Widget>[
                                newUserImgByteMemory == null
                                    ? RoundPic(
                                        isUserPic: true,
                                        picURL: currentUser.profile_pic,
                                        size: 200.0,
                                      )
                                    : CircleAvatar(
                                        radius: 75,
                                        backgroundImage: MemoryImage(newUserImgByteMemory),
                                      ),
                                Positioned(
                                  right: 0.0,
                                  top: 0.0,
                                  child: RoundIconContainer(
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 25.0,
                                    ),
                                    color: CustomColors.clouds,
                                    size: 50.0,
                                  ),
                                )
                              ],
                            ),
                          ).showCursorOnHover,
                          SizedBox(height: 8.0),
                          CustomText(
                            context: context,
                            text: "@${currentUser.username}",
                            textColor: Colors.black,
                            textAlign: TextAlign.center,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(height: 16.0),
                          CustomColorButton(
                            onPressed: () => locator<NavigationService>().navigateTo(MyEventsRoute),
                            text: "My Events",
                            textColor: Colors.black,
                            backgroundColor: Colors.white,
                            textSize: 18.0,
                            height: 40.0,
                            width: 200.0,
                          ).showCursorOnHover,
                          SizedBox(height: 8.0),
                          CustomColorButton(
                            onPressed: () => locator<NavigationService>().navigateTo(WalletSetupEarningsRoute),
                            text: "Setup Earnings Account",
                            textColor: Colors.black,
                            backgroundColor: Colors.white,
                            textSize: 18.0,
                            height: 40.0,
                            width: 200.0,
                          ).showCursorOnHover,
                          SizedBox(height: 8.0),
                          CustomColorButton(
                            onPressed: () => logOut(),
                            text: "Log Out",
                            textColor: Colors.black,
                            backgroundColor: Colors.white,
                            textSize: 18.0,
                            height: 40.0,
                            width: 200.0,
                          ).showCursorOnHover,
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
