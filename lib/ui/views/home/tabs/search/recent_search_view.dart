import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/zero_state_view.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_search_results/list_recent_search_results.dart';
import 'package:webblen_web_app/ui/widgets/search/search_field.dart';

import 'recent_search_view_model.dart';

class RecentSearchView extends StatelessWidget {
  Widget head(RecentSearchViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(
            heroTag: 'search',
            onTap: () => model.navigateToSearchView(),
            enabled: false,
            textEditingController: null,
            onChanged: (String) {},
            onFieldSubmitted: (String) {},
          ),
          IconButton(
            onPressed: () => model.customBottomSheetService.showAddContentOptions(),
            icon: Icon(FontAwesomeIcons.plus, color: appIconColor(), size: 20),
          ),
        ],
      ),
    );
  }

  Widget body(RecentSearchViewModel model) {
    return model.user.recentSearchTerms?.isNotEmpty ?? true
        ? Hero(
            tag: 'recent-searches',
            child: ListRecentSearchResults(
              onSearchTermSelected: (val) => model.researchTerm(val),
              searchTerms: model.user.recentSearchTerms,
              isScrollable: false,
              scrollController: null,
            ),
          )
        : ZeroStateView(
            imageAssetName: "search",
            imageSize: 200,
            opacity: 0.3,
            header: "No Recent Searches Found",
            subHeader: "Search for anything you'd like",
            refreshData: null,
            secondaryAction: () {},
            mainActionButtonTitle: '',
            scrollController: null,
            mainAction: () {},
            secondaryActionButtonTitle: '',
          );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RecentSearchViewModel>.reactive(
      disposeViewModel: false,
      fireOnModelReadyOnce: true,
      initialiseSpecialViewModelsOnce: true,
      viewModelBuilder: () => locator<RecentSearchViewModel>(),
      builder: (context, model, child) => Container(
        height: screenHeight(context),
        color: appBackgroundColor,
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                head(model),
                verticalSpaceSmall,
                Expanded(
                  child: body(model),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}