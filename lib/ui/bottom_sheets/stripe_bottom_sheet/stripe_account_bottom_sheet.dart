import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/ui/bottom_sheets/stripe_bottom_sheet/stripe_account_bottom_sheet_model.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';

class StripeAccountBottomSheet extends StatelessWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  const StripeAccountBottomSheet({
    Key? key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StripeAccountBottomSheetModel>.nonReactive(
      viewModelBuilder: () => StripeAccountBottomSheetModel(),
      builder: (context, model, child) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 500,
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomButton(
                onPressed: () => completer!(SheetResponse(responseData: "instant payout")),
                text: "Instant Payout",
                textSize: 16,
                textColor: Colors.white,
                height: 45,
                width: getValueForScreenType(context: context, mobile: screenWidth(context), tablet: 600, desktop: 700),
                backgroundColor: CustomColors.darkMountainGreen,
                elevation: 1.0,
                isBusy: false,
              ),
              SizedBox(height: 16),
              CustomButton(
                onPressed: () => completer!(SheetResponse(responseData: "payout methods")),
                text: "Payout Methods",
                textSize: 16,
                textColor: appFontColor(),
                height: 45,
                width: getValueForScreenType(context: context, mobile: screenWidth(context), tablet: 600, desktop: 700),
                backgroundColor: appButtonColor(),
                elevation: 1.0,
                isBusy: false,
              ),
              SizedBox(height: 16),
              CustomButton(
                onPressed: () => completer!(SheetResponse(responseData: "how do earnings work")),
                text: "How Do Earnings Work?",
                textSize: 16,
                textColor: appFontColor(),
                height: 45,
                width: getValueForScreenType(context: context, mobile: screenWidth(context), tablet: 600, desktop: 700),
                backgroundColor: appButtonColor(),
                elevation: 1.0,
                isBusy: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
