import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/common/zero_state_view.dart';
import 'package:webblen_web_app/ui/widgets/events/event_block/event_block_view.dart';
import 'package:webblen_web_app/ui/widgets/live_streams/live_stream_block/live_stream_block_view.dart';

import 'list_full_event_search_results_model.dart';

class ListFullEventSearchResults extends StatelessWidget {
  final String searchTerm;
  ListFullEventSearchResults({required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListFullEventSearchResultsModel>.reactive(
      onModelReady: (model) => model.initialize(searchTerm),
      viewModelBuilder: () => ListFullEventSearchResultsModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.dataResults.isEmpty
          ? Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CustomText(
          text: "No Results for \"${searchTerm}\"",
          textAlign: TextAlign.center,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: appFontColorAlt(),
        ),
      )
          : Container(
              height: screenHeight(context),
              color: appBackgroundColor,
              child: RefreshIndicator(
                onRefresh: model.refreshData,
                child: ListView.builder(
                  cacheExtent: 8000,
                  controller: model.scrollController,
                  key: PageStorageKey(model.listKey),
                  addAutomaticKeepAlives: true,
                  shrinkWrap: true,
                  itemCount: model.dataResults.length + 1,
                  itemBuilder: (context, index) {
                    if (index < model.dataResults.length) {
                      return EventBlockView(
                        event: model.dataResults[index],
                        showEventOptions: (event) => model.showContentOptions(event),
                      );
                    } else {
                      if (model.moreDataAvailable) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          model.loadAdditionalData();
                        });
                        return Align(
                          alignment: Alignment.center,
                          child: CustomCircleProgressIndicator(size: 10, color: appActiveColor()),
                        );
                      }
                      return Container();
                    }
                  },
                ),
              ),
            ),
    );
  }
}
