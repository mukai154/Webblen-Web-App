import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/extensions/string_extensions.dart';
import 'package:webblen_web_app/widgets/common/containers/text_field_container.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class CustomAlerts {
  showInfoAlert(BuildContext context, String title, String desc) {
    Alert(
      context: context,
      type: AlertType.info,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          color: Colors.black,
          child: Text(
            "Dismiss",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ).showCursorOnHover,
          onPressed: () => Navigator.pop(context),
          width: 200,
        )
      ],
    ).show();
  }

  showSuccessAlert(BuildContext context, String title, String desc) {
    Alert(
      context: context,
      type: AlertType.success,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          color: Colors.black,
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ).showCursorOnHover,
          onPressed: () => Navigator.pop(context),
          width: 200,
        )
      ],
    ).show();
  }

  showActionRequiredDialog(BuildContext context, String title, String desc, String actionText, VoidCallback action) {
    Alert(
      context: context,
      type: AlertType.info,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          color: Colors.black,
          child: Text(
            actionText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ).showCursorOnHover,
          onPressed: () {
            Navigator.pop(context);
            action;
          },
          width: 200,
        )
      ],
    ).show();
  }

  showSuccessActionAlert(BuildContext context, String title, String desc, VoidCallback action, String actionText) {
    Alert(
      context: context,
      type: AlertType.success,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          color: Colors.black,
          child: Text(
            actionText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ).showCursorOnHover,
          onPressed: () {
            Navigator.pop(context);
            action;
          },
          width: 200,
        )
      ],
    ).show();
  }

  showErrorAlert(BuildContext context, String title, String desc) {
    Alert(
      context: context,
      type: AlertType.error,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          color: Colors.black,
          child: Text(
            "Dismiss",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ).showCursorOnHover,
          onPressed: () => Navigator.pop(context),
          width: 200,
        )
      ],
    ).show();
  }

  showLoadingAlert(BuildContext context, String alertDescription) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
    Alert(
      context: context,
      type: AlertType.none,
      style: alertStyle,
      title: alertDescription,
      content: Container(
        margin: EdgeInsets.only(top: 8.0),
        child: CustomCircleProgress(50, 50, 50, 50, Colors.red),
      ),
      buttons: [],
    ).show();
  }

  showEventShareLink(BuildContext context, String eventTitle, String eventLink, VoidCallback copyLinkAction) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Event Copied To Clipboard!",
      content: Column(
        children: [
          CustomText(
            context: context,
            text: "The event link below has been copied to your clipboard. \n Share it anywhere you'd like!",
            textColor: Colors.black,
            textAlign: TextAlign.center,
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 8.0),
          TextFieldContainer(
            child: CustomText(
              context: context,
              text: eventLink,
              textColor: Colors.black,
              textAlign: TextAlign.center,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          color: Colors.black,
          child: Text(
            'Copy Link',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ).showCursorOnHover,
          onPressed: () => copyText(eventLink),
          width: 200,
        ),
      ],
    ).show();
  }

  showCheckExampleDialog(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Banking Info",
      desc: "You Can Find Your Routing & Account Number on a Bank Check",
      content: Container(
        height: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 150,
              child: Image.asset(
                "assets/images/check_example.png",
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
      buttons: [
        DialogButton(
          color: Colors.black,
          child: Text(
            "Dismiss",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ).showCursorOnHover,
          onPressed: () => Navigator.pop(context),
          width: 200,
        ),
      ],
    ).show();
  }
}
