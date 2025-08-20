// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

// Project imports:
import 'package:oda/bloc/home/notification/notification_bloc.dart';
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';

class NotificationScreen extends StatefulWidget {
  static const String id = "notification_screen";

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    context.read<NotificationBloc>().add(const NotificationInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        NotificationBloc().add(const NotificationSetStateEvent(stillLoading: true));
        getIt<Variables>().generalVariables.indexName = getIt<Variables>().generalVariables.homeRouteList[getIt<Variables>().generalVariables.homeRouteList.length - 1];
        context.read<NavigationBloc>().add(const NavigationInitialEvent());
        getIt<Variables>().generalVariables.homeRouteList.removeAt(getIt<Variables>().generalVariables.homeRouteList.length - 1);
      },
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 480) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 117),
                  child: AppBar(
                    leading: IconButton(
                      onPressed: () {
                        NotificationBloc().add(const NotificationSetStateEvent(stillLoading: true));
                        getIt<Variables>().generalVariables.indexName = getIt<Variables>().generalVariables.homeRouteList[getIt<Variables>().generalVariables.homeRouteList.length - 1];
                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                        getIt<Variables>().generalVariables.homeRouteList.removeAt(getIt<Variables>().generalVariables.homeRouteList.length - 1);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    forceMaterialTransparency: true,
                    actions: const [SizedBox()],
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getIt<Variables>().generalVariables.currentLanguage.notifications,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: 26), color: const Color(0xff282F3A)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 4), horizontal: getIt<Functions>().getWidgetWidth(width: 6)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: const Color(0xff007AFF),
                          ),
                          child: Text(
                            "10",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: 10), color: const Color(0xffFFFFFF)),
                          ),
                        ),
                      ],
                    ),
                    titleSpacing: 0,
                  ),
                ),
                Expanded(
                    child: SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: false,
                  physics: const BouncingScrollPhysics(),
                  onRefresh: () {},
                  controller: refreshController,
                  onLoading: () {},
                  child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                      physics: const ScrollPhysics(),
                      itemCount: 5,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {},
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: getIt<Functions>().getWidgetHeight(height: 8)),
                                child: CircleAvatar(
                                  radius: getIt<Functions>().getWidgetWidth(width: 3.5),
                                  backgroundColor: 1 == 1 ? const Color(0xFF007AFF) : Colors.white,
                                ),
                              ),
                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "body " * 20,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: const Color(0xFF282F3A), fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 16)),
                                    ),
                                    Text(
                                      "27/11/2024 11:00 PM ",
                                      style: TextStyle(color: const Color(0xFF8F9BB3), fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ))
              ],
            ),
          );
        } else {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 117),
                  child: AppBar(
                    leading:  IconButton(
                      onPressed: () {
                        NotificationBloc().add(const NotificationSetStateEvent(stillLoading: true));
                        getIt<Variables>().generalVariables.indexName = getIt<Variables>().generalVariables.homeRouteList[getIt<Variables>().generalVariables.homeRouteList.length - 1];
                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                        getIt<Variables>().generalVariables.homeRouteList.removeAt(getIt<Variables>().generalVariables.homeRouteList.length - 1);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getIt<Variables>().generalVariables.currentLanguage.notifications,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: 26), color: const Color(0xff282F3A)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 4), horizontal: getIt<Functions>().getWidgetWidth(width: 6)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: const Color(0xff007AFF),
                          ),
                          child: Text(
                            "10",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: 10), color: const Color(0xffFFFFFF)),
                          ),
                        ),
                      ],
                    ),
                    actions: const [SizedBox()],
                    forceMaterialTransparency: true,
                    titleSpacing: 0,
                  ),
                ),
                Expanded(
                    child: SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: false,
                  physics: const BouncingScrollPhysics(),
                  onRefresh: () {},
                  controller: refreshController,
                  onLoading: () {},
                  child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                      physics: const ScrollPhysics(),
                      itemCount: 5,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {},
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: getIt<Functions>().getWidgetHeight(height: 8)),
                                child: CircleAvatar(
                                  radius: getIt<Functions>().getWidgetWidth(width: 3.5),
                                  backgroundColor: 1 == 1 ? const Color(0xFF007AFF) : Colors.white,
                                ),
                              ),
                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(maxWidth: getIt<Functions>().getWidgetWidth(width: 340), minHeight: getIt<Functions>().getWidgetHeight(height: 50)),
                                    child: Text(
                                      "body " * 20,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: const Color(0xFF282F3A), fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                    ),
                                  ),
                                  Text(
                                    "27/11/2024 11:00 PM ",
                                    style: TextStyle(color: const Color(0xFF8F9BB3), fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                ))
              ],
            ),
          );
        }
      }),
    );
  }
}
