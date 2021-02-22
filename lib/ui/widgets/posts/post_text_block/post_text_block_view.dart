import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/posts/post_text_block/post_text_block_view_model.dart';
import 'package:webblen_web_app/ui/widgets/tags/tag_button.dart';
import 'package:webblen_web_app/ui/widgets/user/user_profile_pic.dart';
import 'package:webblen_web_app/utils/time_calc.dart';

class PostTextBlockView extends StatelessWidget {
  final String currentUID;
  final WebblenPost post;
  final Function(WebblenPost) showPostOptions;

  PostTextBlockView({
    this.currentUID,
    this.post,
    this.showPostOptions,
  });

  Widget head(PostTextBlockViewModel model) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: null,
            child: Row(
              children: <Widget>[
                UserProfilePic(
                  userPicUrl: model.authorImageURL,
                  size: 35,
                  isBusy: false,
                ),
                SizedBox(
                  width: 10.0,
                ),
                post.tags.isEmpty
                    ? Text(
                        "@${model.authorUsername}",
                        style: TextStyle(
                          color: appFontColor(),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "@${model.authorUsername}",
                            style: TextStyle(
                              color: appFontColor(),
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            post.tags.toString().replaceAll("[", "").replaceAll("]", ""),
                            style: TextStyle(
                              fontSize: 14,
                              color: appFontColorAlt(),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () => showPostOptions(post),
          ),
        ],
      ),
    );
  }

  Widget postBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        post.body,
        style: TextStyle(
          color: appFontColor(),
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget commentSaveAndPostTime(PostTextBlockViewModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () => model.saveUnsavePost(currentUID: currentUID, postID: post.id),
                child: Icon(
                  model.savedPost ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                  size: 18,
                  color: model.savedPost ? appSavedContentColor() : appIconColorAlt(),
                ),
              ),
            ],
          ),
          Text(
            TimeCalc().getPastTimeFromMilliseconds(post.postDateTimeInMilliseconds),
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget commentCount(PostTextBlockViewModel model) {
    return post.commentCount == 0
        ? Container()
        : Padding(
            padding: EdgeInsets.only(left: 16.0, top: 12.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  post.commentCount == 1 ? "${post.commentCount} comment" : "${post.commentCount} comments",
                  style: TextStyle(
                    fontSize: 14,
                    color: appFontColorAlt(),
                  ),
                ),
              ],
            ),
          );
  }

  Widget postMessage(PostTextBlockViewModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: '',
              style: TextStyle(
                color: appFontColor(),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: post.body.trim(),
              style: TextStyle(
                color: appFontColor(),
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget postTags(PostTextBlockViewModel model) {
    return post.tags == null || post.tags.isEmpty
        ? Container()
        : Container(
            margin: EdgeInsets.only(left: 16, bottom: 8, right: 16),
            height: 30,
            child: ListView.builder(
              addAutomaticKeepAlives: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: 4.0,
                bottom: 4.0,
              ),
              itemCount: post.tags.length,
              itemBuilder: (context, index) {
                return TagButton(
                  onTap: null,
                  tag: post.tags[index],
                );
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostTextBlockViewModel>.reactive(
      fireOnModelReadyOnce: true,
      initialiseSpecialViewModelsOnce: true,
      viewModelBuilder: () => PostTextBlockViewModel(),
      onModelReady: (model) => model.initialize(currentUID: currentUID, postAuthorID: post.authorID, postID: post.id),
      builder: (context, model, child) => GestureDetector(
        onDoubleTap: () => model.saveUnsavePost(currentUID: currentUID, postID: post.id),
        onTap: () => model.navigateToPostView(post.id),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              head(model),
              postBody(),
              commentCount(model),
              commentSaveAndPostTime(model),
              verticalSpaceSmall,
              postTags(model),
              verticalSpaceTiny,
              Divider(
                thickness: 4.0,
                color: appPostBorderColor(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
