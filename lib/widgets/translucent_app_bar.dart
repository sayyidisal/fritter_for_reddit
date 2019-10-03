import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/hex_color.dart';

class TranslucentSliverAppDelegate extends SliverPersistentHeaderDelegate {
  final EdgeInsets safeAreaPadding;

  TranslucentSliverAppDelegate(padding) : this.safeAreaPadding = padding;

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => minExtent + 250;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return AppbarSelector(maxExtent, minExtent);
  }

  @override
  bool shouldRebuild(TranslucentSliverAppDelegate old) {
    return maxExtent != old.maxExtent ||
        minExtent != old.minExtent ||
        safeAreaPadding != old.safeAreaPadding;
  }
}

class AppbarSelector extends StatefulWidget {
  final maxExtent, minExtent;

  AppbarSelector(this.maxExtent, this.minExtent);

  @override
  _AppbarSelectorState createState() => _AppbarSelectorState();
}

class _AppbarSelectorState extends State<AppbarSelector> {
  @override
  Widget build(BuildContext context) {
    return Provider.of<FeedProvider>(context).currentPage ==
            CurrentPage.FrontPage
        ? TranslucentAppBarFrontPage(
            widget.maxExtent,
            widget.minExtent,
          )
        : TranslucentAppBarOther(
            widget.maxExtent,
            widget.minExtent,
          );
  }
}

class TranslucentAppBarOther extends StatefulWidget {
  final maxExtent, minExtent;

  TranslucentAppBarOther(this.maxExtent, this.minExtent);

  @override
  _TranslucentAppBarOtherState createState() => _TranslucentAppBarOtherState();
}

class _TranslucentAppBarOtherState extends State<TranslucentAppBarOther> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, FeedProvider model, _) {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Opacity(
              opacity: 1.0,
              child: Container(
                // Don't wrap this in any SafeArea widgets, use padding instead
                padding: EdgeInsets.only(top: 0),
                height: widget.maxExtent,
                color: model.state == ViewState.Busy
                    ? Colors.white30
                    : model != null &&
                            model.subredditInformationEntity.data
                                    .bannerBackgroundColor !=
                                ""
                        ? TransparentHexColor(model.subredditInformationEntity
                            .data.bannerBackgroundColor)
                        : Colors.white30,
                // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
                child: Stack(
                  overflow: Overflow.clip,
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: model.state == ViewState.Idle
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 24.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: CircleAvatar(
                                      maxRadius: 24,
                                      minRadius: 24,
                                      backgroundImage: model
                                                  .subredditInformationEntity
                                                  .data
                                                  .communityIcon !=
                                              ""
                                          ? NetworkImage(model
                                              .subredditInformationEntity
                                              .data
                                              .communityIcon)
                                          : model.subredditInformationEntity
                                                      .data.iconImg !=
                                                  ""
                                              ? NetworkImage(model
                                                  .subredditInformationEntity
                                                  .data
                                                  .iconImg)
                                              : AssetImage(
                                                  'assets/default_icon.png'),
                                      backgroundColor: model
                                                  .subredditInformationEntity
                                                  .data
                                                  .primaryColor ==
                                              ""
                                          ? Theme.of(context).accentColor
                                          : HexColor(model
                                              .subredditInformationEntity
                                              .data
                                              .primaryColor),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            model.subredditInformationEntity
                                                .data.displayNamePrefixed,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline,
                                          ),
                                          Text(
                                            model.subredditInformationEntity
                                                    .data.subscribers
                                                    .toString() +
                                                " Subscribers",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subhead,
                                          )
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      OutlineButton(
                                        child: model.partialState ==
                                                ViewState.Busy
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Text(model
                                                    .subredditInformationEntity
                                                    .data
                                                    .userIsSubscriber
                                                ? 'Subscribed'
                                                : 'Join'),
                                        onPressed: () {
                                          model.unsubscribeFromSubreddit(
                                              model.subredditInformationEntity
                                                  .data.name,
                                              !model.subredditInformationEntity
                                                  .data.userIsSubscriber);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AppBar(
                        primary: true,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        brightness: Brightness.light,
                        iconTheme: IconThemeData.fallback(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TranslucentAppBarFrontPage extends StatefulWidget {
  final maxExtent, minExtent;

  TranslucentAppBarFrontPage(this.maxExtent, this.minExtent);

  @override
  _TranslucentAppBarFrontPageState createState() =>
      _TranslucentAppBarFrontPageState();
}

class _TranslucentAppBarFrontPageState
    extends State<TranslucentAppBarFrontPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, FeedProvider model, _) {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Opacity(
              opacity: 1.0,
              child: Container(
                // Don't wrap this in any SafeArea widgets, use padding instead
                padding: EdgeInsets.only(top: 0),
                height: widget.maxExtent,
                color: Colors.white30,
                // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
                child: Stack(
                  overflow: Overflow.clip,
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: model.state == ViewState.Idle
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 24.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Front Page',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AppBar(
                        primary: true,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        brightness: Brightness.light,
                        iconTheme: IconThemeData.fallback(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}