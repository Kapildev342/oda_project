// ignore_for_file: unused_import

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:oda/bloc/home/home_bloc/home_bloc.dart';
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/rabbit_service.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';
import 'package:oda/screens/home/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    /*if (!getIt<Variables>().generalVariables.isNetworkOffline) {
      getIt<RabbitMQService>().listenToMessages( (message){debugPrint("message :$message");});
    }*/
  /*  getIt<RabbitMQService>().sendMessage({
      "event": "alert",
      "message": "alert generated",
      "module": "picklist",
      "activity": "",
      "actor_id": "",
      "body": {},
    });*/
    context.read<HomeBloc>().add(const HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        getIt<Widgets>().showAnimatedDialog(
          context: context,
          height: 190,
          width: 300,
          child: exitAppContent(context: context),
          isLogout: true,
        );
      },
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 480) {
          return Container(
            color: const Color(0xffEEF4FF),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getIt<Functions>().getWidgetWidth(
                          width: getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" ||
                                  getIt<Variables>().generalVariables.userData.userProfile.employeeType == "logistics_executive"
                              ? 6
                              : 0)),
                  child: AppBar(
                    leading: getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" ||
                            getIt<Variables>().generalVariables.userData.userProfile.employeeType == "logistics_executive"
                        ? IconButton(
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 2));
                              context.read<NavigationBloc>().add(const NavigationInitialEvent());
                            },
                            icon: CircleAvatar(
                              backgroundImage: getIt<Variables>().generalVariables.profileNetworkImage == null
                                  ? const AssetImage("assets/general/maintenance.png")
                                  : MemoryImage(getIt<Variables>().generalVariables.profileNetworkImage!),
                              radius: 18,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: const Icon(Icons.menu),
                          ),
                    forceMaterialTransparency: true,
                    titleSpacing: 0,
                    title: Text(
                      getIt<Variables>().generalVariables.currentLanguage.dashboard,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: 26), color: const Color(0xff282F3A)),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          getIt<Variables>().generalVariables.indexName = NotificationScreen.id;
                          getIt<Variables>().generalVariables.homeRouteList.add(HomeScreen.id);
                          context.read<NavigationBloc>().add(const NavigationInitialEvent());
                        },
                        icon: SvgPicture.asset(
                          "assets/home/notifications.svg",
                          height: getIt<Functions>().getWidgetHeight(height: 34),
                          width: getIt<Functions>().getWidgetWidth(width: 34),
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: getIt<Functions>().getWidgetWidth(width: 12),
                        right: getIt<Functions>().getWidgetWidth(width: 12),
                        bottom: getIt<Functions>().getWidgetHeight(height: 12)),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          );
        }
        else {
          return Container(
            color: const Color(0xffEEF4FF),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: const Color(0xffEEF4FF),
                  leading: getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" ||
                          getIt<Variables>().generalVariables.userData.userProfile.employeeType == "logistics_executive"
                      ? IconButton(
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 2));
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                          },
                          icon: CircleAvatar(
                              backgroundImage: getIt<Variables>().generalVariables.profileNetworkImage == null
                                  ? const AssetImage("assets/general/maintenance.png")
                                  : MemoryImage(getIt<Variables>().generalVariables.profileNetworkImage!)),
                        )
                      : IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(Icons.menu),
                        ),
                  forceMaterialTransparency: true,
                  titleSpacing: 0,
                  title: Text(
                    getIt<Variables>().generalVariables.currentLanguage.dashboard,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: 26), color: const Color(0xff282F3A)),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        getIt<Variables>().generalVariables.indexName = NotificationScreen.id;
                        getIt<Variables>().generalVariables.homeRouteList.add(HomeScreen.id);
                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                      },
                      icon: SvgPicture.asset(
                        "assets/home/notifications.svg",
                        height: getIt<Functions>().getWidgetHeight(height: 34),
                        width: getIt<Functions>().getWidgetWidth(width: 34),
                        fit: BoxFit.fill,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: getIt<Functions>().getWidgetWidth(width: 12),
                        right: getIt<Functions>().getWidgetWidth(width: 12),
                        bottom: getIt<Functions>().getWidgetHeight(height: 12)),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget exitAppContent({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: getIt<Functions>().getWidgetHeight(height: 17),
          ),
          Text(
            "${getIt<Variables>().generalVariables.currentLanguage.exit} ? ",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 24 : 22),
                color: const Color(0xff282F3A)),
          ),
          SizedBox(
            height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 16 : 12),
          ),
          Text(
            getIt<Variables>().generalVariables.currentLanguage.doYouWantToExit,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff303030)),
          ),
          SizedBox(
            height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 16 : 12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  getIt<Variables>().generalVariables.currentLanguage.cancel,
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff303030)),
                ),
              ),
              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 16)),
              TextButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                child: Text(
                  getIt<Variables>().generalVariables.currentLanguage.exit,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: Colors.red),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget updateOrMaintenanceDialogContent() {
    return SizedBox(
      height: getIt<Variables>().generalVariables.isDeviceTablet ? 411 : 325,
      width: getIt<Variables>().generalVariables.isDeviceTablet ? 600 : 380,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 49 : 25),
                ),
                Image.asset(
                  "assets/general/maintenance.png",
                  height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 154 : 100),
                  width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 154 : 100),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 17 : 12),
                ),
                Text(
                  getIt<Variables>().generalVariables.initialSetupValues.infoTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 24 : 20),
                      color: const Color(0xff282F3A)),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 8),
                ),
                SizedBox(
                  width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 499 : 325),
                  child: Text(
                    getIt<Variables>().generalVariables.initialSetupValues.infoMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff303030)),
                  ),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 50 : 25),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getIt<Variables>().generalVariables.initialSetupValues.dismissInfo
                  ? Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: getIt<Functions>().getWidgetHeight(height: 50),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: const Radius.circular(15),
                                  bottomRight: Radius.circular(getIt<Variables>().generalVariables.initialSetupValues.infoButton == "" ? 15 : 0))),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              getIt<Variables>().generalVariables.initialSetupValues.infoButton == ""
                  ? const SizedBox()
                  : Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          height: getIt<Functions>().getWidgetHeight(height: 50),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                  bottomRight: const Radius.circular(15),
                                  bottomLeft: Radius.circular(getIt<Variables>().generalVariables.initialSetupValues.dismissInfo ? 0 : 15))),
                          child: Center(
                            child: Text(
                              getIt<Variables>().generalVariables.initialSetupValues.infoButton,
                              style: TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}
