// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/settings/settings_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';
import 'package:oda/screens/home/home_screen.dart';
import 'package:oda/screens/registration/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = "settings_screen";

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    context.read<SettingsBloc>().add(const SettingsInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: context.read<SettingsBloc>().isPasswordChanged
          ? (value) {}
          : (value) {
        context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 0));
        getIt<Variables>().generalVariables.indexName = HomeScreen.id;
        context.read<NavigationBloc>().add(const NavigationInitialEvent());
      },
      canPop: false,
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listenWhen: (SettingsState previous, SettingsState current) {
          return previous != current;
        },
        buildWhen: (SettingsState previous, SettingsState current) {
          return previous != current;
        },
        listener: (BuildContext context, SettingsState state) {
          if (state is SettingsFailure) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (BuildContext context, SettingsState state) {
          if (state is SettingsLoaded) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth > 480) {
                  return SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        Image.asset(
                          "assets/general/settings_background.png",
                          height: getIt<Functions>().getWidgetHeight(height: 219),
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 45)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" ||
                                          getIt<Variables>().generalVariables.userData.userProfile.employeeType == "logistics_executive"
                                          ?const SizedBox():InkWell(
                                        onTap: () {
                                          context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 0));
                                          getIt<Variables>().generalVariables.indexName = HomeScreen.id;
                                          context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                        },
                                        child: const Icon(
                                          Icons.arrow_back,
                                          color: Color(0xff1D2736),
                                        ),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.settings,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff282F3A),
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                        ),
                                      ),
                                    ],
                                  ),
                                  BlocConsumer<NavigationBloc, NavigationState>(
                                    listenWhen: (NavigationState previous, NavigationState current) {
                                      return previous != current;
                                    },
                                    buildWhen: (NavigationState previous, NavigationState current) {
                                      return previous != current;
                                    },
                                    listener: (BuildContext context, NavigationState navigation) {
                                      if (navigation is LanguageChanged) {
                                        context.read<SettingsBloc>().add(const SettingsInitialEvent());
                                        context.read<SettingsBloc>().add(const SettingsChangeLanguageEvent());
                                      }
                                    },
                                    builder: (BuildContext context, NavigationState state) {
                                      return PopupMenuButton(
                                        offset: const Offset(-20, 35),
                                        color: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        itemBuilder: (BuildContext context) {
                                          return List.generate(
                                            getIt<Variables>().generalVariables.languageList.length,
                                                (index) => PopupMenuItem(
                                              onTap: () {
                                                if(getIt<Variables>().generalVariables.isNetworkOffline){
                                                  ScaffoldMessenger.of(context).clearSnackBars();
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getIt<Variables>().generalVariables.currentLanguage.offlineNotChangePsws)));
                                                }else{
                                                  context.read<NavigationBloc>().add(LanguageChangingEvent(index: index));
                                                }
                                              },
                                              value: getIt<Variables>().generalVariables.languageList.indexWhere((element) => element.code == getIt<Variables>().generalVariables.loggedHeaders.lang),
                                              child: Row(
                                                children: [
                                                  getIt<Variables>().generalVariables.languageList[index].code == getIt<Variables>().generalVariables.loggedHeaders.lang
                                                      ? Image.asset("assets/settings/translation_logo_filled.png", height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill)
                                                      : Image.asset("assets/settings/translation_logo.png", height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill),
                                                  SizedBox(
                                                    width: getIt<Functions>().getWidgetWidth(width: 10),
                                                  ),
                                                  Text(
                                                    getIt<Variables>().generalVariables.languageList[index].name.toUpperCase(),
                                                    style: const TextStyle(color: Colors.black),
                                                  ),
                                                  const Expanded(
                                                    child: SizedBox(),
                                                  ),
                                                  getIt<Variables>().generalVariables.languageList[index].code == getIt<Variables>().generalVariables.loggedHeaders.lang
                                                      ? const Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                    size: 15,
                                                  )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Image.asset("assets/settings/translation_logo.png", height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill),
                                      );
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 120),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: getIt<Functions>().getWidgetWidth(width: 120),
                                      width: getIt<Functions>().getWidgetWidth(width: 120),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: getIt<Variables>().generalVariables.profileNetworkImage == null?const AssetImage("assets/general/maintenance.png"):MemoryImage(getIt<Variables>().generalVariables.profileNetworkImage!),
                                          fit: BoxFit.fill,
                                        ),
                                        color: Colors.grey.shade100,
                                        border: Border.all(color: Colors.grey.shade400),
                                      ),
                                    ),
                                    SizedBox(
                                      width: getIt<Functions>().getWidgetWidth(width: 20),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: getIt<Functions>().getWidgetHeight(height: 16),
                                        ),
                                        Text(
                                          getIt<Variables>().generalVariables.profileValues.userName,
                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 24), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                        ),
                                        SizedBox(
                                          height: getIt<Functions>().getWidgetHeight(height: 4),
                                        ),
                                        Text(
                                          getIt<Variables>().generalVariables.profileValues.employeeType,
                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 16), fontWeight: FontWeight.w500, color: const Color(0xff007AFF)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                              Container(
                                padding: EdgeInsets.only(
                                  left: getIt<Functions>().getWidgetWidth(width: 20),
                                  right: getIt<Functions>().getWidgetWidth(width: 20),
                                  top: getIt<Functions>().getWidgetHeight(height: 28),
                                  bottom: getIt<Functions>().getWidgetHeight(height: 10),
                                ),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                                child: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: getIt<Variables>().generalVariables.profileValues.data.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 42),
                                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color(0xffE0E7EC)))),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Image.memory(
                                                          base64Decode(getIt<Variables>().generalVariables.profileValues.data[index].icon),
                                                          height: getIt<Functions>().getWidgetHeight(height: 28),
                                                          width: getIt<Functions>().getWidgetWidth(width: 28),
                                                        ),
                                                        SizedBox(
                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                        ),
                                                        Text(
                                                          getIt<Variables>().generalVariables.profileValues.data[index].label,
                                                          style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Text(
                                                      getIt<Variables>().generalVariables.profileValues.data[index].value,
                                                      style: TextStyle(
                                                        color: const Color(0xff6F6F6F),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                                        ],
                                      );
                                    }),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                              InkWell(
                                onTap: () {
                                  if (getIt<Variables>().generalVariables.isNetworkOffline) {
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getIt<Variables>().generalVariables.currentLanguage.offlineNotChangePsws)));
                                  } else {
                                    context.read<SettingsBloc>().currentPasswordController.clear();
                                    getIt<Variables>().generalVariables.popUpWidget = currentPasswordContent();
                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                    vertical: getIt<Functions>().getWidgetHeight(height: 15),
                                  ),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/settings/change_password.svg",
                                        height: getIt<Functions>().getWidgetHeight(height: 28),
                                        width: getIt<Functions>().getWidgetWidth(width: 28),
                                      ),
                                      SizedBox(
                                        width: getIt<Functions>().getWidgetWidth(width: 10),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.changePassword,
                                        style: TextStyle(
                                          color: const Color(0xff282F3A),
                                          fontWeight: FontWeight.w500,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" ||
                                  getIt<Variables>().generalVariables.userData.userProfile.employeeType == "logistics_executive"
                                  ?35:100)),
                              Center(
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xffF92C38), width: 0.68),
                                        maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 175), getIt<Functions>().getWidgetHeight(height: 50)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                    onPressed: () {
                                      if (getIt<Variables>().generalVariables.isNetworkOffline) {
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getIt<Variables>().generalVariables.currentLanguage.offlineNotLogout)));
                                      } else {
                                        getIt<Widgets>().showAnimatedDialog(
                                          context: context,
                                          height: 180,
                                          width: 300,
                                          child: logOutContent(),
                                          isLogout: true,
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: getIt<Functions>().getWidgetWidth(width: 100),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.logOut,
                                              style: TextStyle(
                                                color: const Color(0xffF92C38),
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        Image.asset(
                                          "assets/settings/logout.png",
                                          height: getIt<Functions>().getWidgetHeight(height: 18),
                                          width: getIt<Functions>().getWidgetWidth(width: 18),
                                        ),
                                      ],
                                    )),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        Image.asset(
                          "assets/general/settings_background.png",
                          height: getIt<Functions>().getWidgetHeight(height: 237),
                          width: getIt<Functions>().getWidgetWidth(width: 764),
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 66)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" ||
                                          getIt<Variables>().generalVariables.userData.userProfile.employeeType == "logistics_executive"
                                          ?const SizedBox():InkWell(
                                        onTap: () {
                                          context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 0));
                                          getIt<Variables>().generalVariables.indexName = HomeScreen.id;
                                          context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                        },
                                        child: const Icon(
                                          Icons.arrow_back,
                                          color: Color(0xff1D2736),
                                        ),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.settings,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff282F3A),
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                        ),
                                      ),
                                    ],
                                  ),
                                  BlocConsumer<NavigationBloc, NavigationState>(
                                    listener: (BuildContext context, NavigationState navigation) {
                                      if (navigation is LanguageChanged) {
                                        context.read<SettingsBloc>().add(const SettingsInitialEvent());
                                        context.read<SettingsBloc>().add(const SettingsChangeLanguageEvent());
                                      }
                                    },
                                    builder: (BuildContext context, NavigationState state) {
                                      return getIt<Variables>().generalVariables.isNetworkOffline?const SizedBox():PopupMenuButton(
                                        offset: const Offset(-20, 35),
                                        color: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        itemBuilder: (BuildContext context) {
                                          return List.generate(
                                            getIt<Variables>().generalVariables.languageList.length,
                                                (index) => PopupMenuItem(
                                              onTap: () {
                                                if(getIt<Variables>().generalVariables.isNetworkOffline){
                                                  ScaffoldMessenger.of(context).clearSnackBars();
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getIt<Variables>().generalVariables.currentLanguage.offlineNotChangeLang)));
                                                }else{
                                                  context.read<NavigationBloc>().add(LanguageChangingEvent(index: index));
                                                }
                                              },
                                                  value: getIt<Variables>().generalVariables.languageList.indexWhere((element) => element.code == getIt<Variables>().generalVariables.loggedHeaders.lang),
                                              child: Row(
                                                children: [
                                                  getIt<Variables>().generalVariables.languageList[index].code == getIt<Variables>().generalVariables.loggedHeaders.lang
                                                      ? Image.asset("assets/settings/translation_logo_filled.png", height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill)
                                                      : Image.asset("assets/settings/translation_logo.png", height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    getIt<Variables>().generalVariables.languageList[index].name.toUpperCase(),
                                                    style: const TextStyle(color: Colors.black),
                                                  ),
                                                  const Expanded(
                                                    child: SizedBox(),
                                                  ),
                                                  getIt<Variables>().generalVariables.languageList[index].code == getIt<Variables>().generalVariables.loggedHeaders.lang
                                                      ? const Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                    size: 15,
                                                  )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Image.asset("assets/settings/translation_logo.png", height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill),
                                      );
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 120),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: getIt<Functions>().getWidgetHeight(height: 120),
                                      width: getIt<Functions>().getWidgetWidth(width: 120),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.grey.shade100,
                                          border: Border.all(color: Colors.grey.shade400),
                                          image: DecorationImage(
                                            image: getIt<Variables>().generalVariables.profileNetworkImage == null?const AssetImage("assets/general/maintenance.png"):MemoryImage(getIt<Variables>().generalVariables.profileNetworkImage!),
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                    SizedBox(
                                      width: getIt<Functions>().getWidgetWidth(width: 20),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: getIt<Functions>().getWidgetHeight(height: 16),
                                        ),
                                        Text(
                                          getIt<Variables>().generalVariables.profileValues.userName,
                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 22), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                        ),
                                        SizedBox(
                                          height: getIt<Functions>().getWidgetHeight(height: 4),
                                        ),
                                        Text(
                                          getIt<Variables>().generalVariables.profileValues.employeeType,
                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff007AFF)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                              Container(
                                padding: EdgeInsets.only(
                                  left: getIt<Functions>().getWidgetWidth(width: 20),
                                  right: getIt<Functions>().getWidgetWidth(width: 20),
                                  top: getIt<Functions>().getWidgetHeight(height: 28),
                                  bottom: getIt<Functions>().getWidgetHeight(height: 10),
                                ),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                                child: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: getIt<Variables>().generalVariables.profileValues.data.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 42),
                                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color(0xffE0E7EC)))),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Image.memory(
                                                          base64Decode(getIt<Variables>().generalVariables.profileValues.data[index].icon),
                                                          height: getIt<Functions>().getWidgetHeight(height: 28),
                                                          width: getIt<Functions>().getWidgetWidth(width: 28),
                                                        ),
                                                        SizedBox(
                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                        ),
                                                        Text(
                                                          getIt<Variables>().generalVariables.profileValues.data[index].label,
                                                          style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Text(
                                                      getIt<Variables>().generalVariables.profileValues.data[index].value,
                                                      style: TextStyle(
                                                        color: const Color(0xff6F6F6F),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                                        ],
                                      );
                                    }),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                              InkWell(
                                onTap: () {
                                  if (getIt<Variables>().generalVariables.isNetworkOffline) {
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getIt<Variables>().generalVariables.currentLanguage.offlineNotChangePsws)));
                                  } else {
                                    context.read<SettingsBloc>().currentPasswordController.clear();
                                    getIt<Variables>().generalVariables.popUpWidget = currentPasswordContent();
                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                    vertical: getIt<Functions>().getWidgetHeight(height: 15),
                                  ),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/settings/change_password.svg",
                                        height: getIt<Functions>().getWidgetHeight(height: 28),
                                        width: getIt<Functions>().getWidgetWidth(width: 28),
                                      ),
                                      SizedBox(
                                        width: getIt<Functions>().getWidgetWidth(width: 10),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.changePassword,
                                        style: TextStyle(
                                          color: const Color(0xff282F3A),
                                          fontWeight: FontWeight.w500,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                              Center(
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xffF92C38), width: 0.68),

                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                    onPressed: () {
                                      if (getIt<Variables>().generalVariables.isNetworkOffline) {
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getIt<Variables>().generalVariables.currentLanguage.offlineNotLogout)));
                                      } else {
                                        getIt<Widgets>().showAnimatedDialog(
                                          context: context,
                                          height: 180,
                                          width: 300,
                                          child: logOutContent(),
                                          isLogout: true,
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 40)),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.logOut,
                                            style: TextStyle(
                                              color: const Color(0xffF92C38),
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        Image.asset(
                                          "assets/settings/logout.png",
                                          height: getIt<Functions>().getWidgetHeight(height: 18),
                                          width: getIt<Functions>().getWidgetWidth(width: 18),
                                        ),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 40)),
                                      ],
                                    )),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            );
          }
          else if (state is SettingsLoading) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth > 480) {
                  return SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        Image.asset(
                          "assets/general/settings_background.png",
                          height: getIt<Functions>().getWidgetHeight(height: 219),
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 45)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Skeleton.keep(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" ||
                                            getIt<Variables>().generalVariables.userData.userProfile.employeeType == "logistics_executive"
                                            ?const SizedBox():InkWell(
                                          onTap: () {
                                            context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 0));
                                            getIt<Variables>().generalVariables.indexName = HomeScreen.id;
                                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                          },
                                          child: const Icon(
                                            Icons.arrow_back,
                                            color: Color(0xff1D2736),
                                          ),
                                        ),
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.settings,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff282F3A),
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                              Skeletonizer(
                                enabled: true,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 120),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 120),
                                            width: getIt<Functions>().getWidgetWidth(width: 120),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              image: const DecorationImage(
                                                image: AssetImage("assets/general/maintenance.png"),
                                                fit: BoxFit.fill,
                                              ),
                                              color: Colors.grey.shade100,
                                              border: Border.all(color: Colors.grey.shade400),
                                            ),
                                          ),
                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                              ),
                                              Text(
                                                "User Name",
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 24), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                              ),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 4),
                                              ),
                                              Text(
                                                "Employee Type",
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 16), fontWeight: FontWeight.w500, color: const Color(0xff007AFF)),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: getIt<Functions>().getWidgetWidth(width: 20),
                                        right: getIt<Functions>().getWidgetWidth(width: 20),
                                        top: getIt<Functions>().getWidgetHeight(height: 28),
                                        bottom: getIt<Functions>().getWidgetHeight(height: 10),
                                      ),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                                      child: ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: 6,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: getIt<Functions>().getWidgetHeight(height: 42),
                                                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color(0xffE0E7EC)))),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Skeleton.shade(
                                                                child: SvgPicture.asset(
                                                                  "assets/settings/province.svg",
                                                                  height: getIt<Functions>().getWidgetHeight(height: 28),
                                                                  width: getIt<Functions>().getWidgetWidth(width: 28),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 10),
                                                              ),
                                                              Text(
                                                                "Label" * 4,
                                                                style: TextStyle(
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 25),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Text(
                                                            "value" * 2,
                                                            style: TextStyle(
                                                              color: const Color(0xff6F6F6F),
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 25),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                                              ],
                                            );
                                          }),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    InkWell(
                                      onTap: () {
                                        if (getIt<Variables>().generalVariables.isNetworkOffline) {
                                          ScaffoldMessenger.of(context).clearSnackBars();
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getIt<Variables>().generalVariables.currentLanguage.offlineNotChangePsws)));
                                        } else {
                                          context.read<SettingsBloc>().currentPasswordController.clear();
                                          getIt<Variables>().generalVariables.popUpWidget = currentPasswordContent();
                                          getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                          vertical: getIt<Functions>().getWidgetHeight(height: 15),
                                        ),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Skeleton.shade(
                                              child: SvgPicture.asset(
                                                "assets/settings/change_password.svg",
                                                height: getIt<Functions>().getWidgetHeight(height: 28),
                                                width: getIt<Functions>().getWidgetWidth(width: 28),
                                              ),
                                            ),
                                            SizedBox(
                                              width: getIt<Functions>().getWidgetWidth(width: 10),
                                            ),
                                            Text(
                                              "Change Password",
                                              style: TextStyle(
                                                color: const Color(0xff282F3A),
                                                fontWeight: FontWeight.w500,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 25),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 100)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        Image.asset(
                          "assets/general/settings_background.png",
                          height: getIt<Functions>().getWidgetHeight(height: 237),
                          width: getIt<Functions>().getWidgetWidth(width: 764),
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 66)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" ||
                                          getIt<Variables>().generalVariables.userData.userProfile.employeeType == "logistics_executive"
                                          ?const SizedBox():InkWell(
                                        onTap: () {
                                          context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 0));
                                          getIt<Variables>().generalVariables.indexName = HomeScreen.id;
                                          context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                        },
                                        child: const Icon(
                                          Icons.arrow_back,
                                          color: Color(0xff1D2736),
                                        ),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.settings,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff282F3A),
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                        ),
                                      ),
                                    ],
                                  ),
                                  BlocConsumer<NavigationBloc, NavigationState>(
                                    listener: (BuildContext context, NavigationState navigation) {
                                      if (navigation is LanguageChanged) {
                                        context.read<SettingsBloc>().add(const SettingsInitialEvent());
                                        context.read<SettingsBloc>().add(const SettingsChangeLanguageEvent());
                                      }
                                    },
                                    builder: (BuildContext context, NavigationState state) {
                                      return PopupMenuButton(
                                        offset: const Offset(-20, 35),
                                        color: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        itemBuilder: (BuildContext context) {
                                          return List.generate(
                                            getIt<Variables>().generalVariables.languageList.length,
                                                (index) => PopupMenuItem(
                                              onTap: () {
                                                if(getIt<Variables>().generalVariables.isNetworkOffline){
                                                  ScaffoldMessenger.of(context).clearSnackBars();
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(getIt<Variables>().generalVariables.currentLanguage.offlineNotChangeLang)));
                                                }else{
                                                  context.read<NavigationBloc>().add(LanguageChangingEvent(index: index));
                                                }

                                              },
                                              value: index,
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.person_add,
                                                    color: Colors.green,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    getIt<Variables>().generalVariables.languageList[index].name.toUpperCase(),
                                                    style: const TextStyle(color: Colors.black),
                                                  ),
                                                  const Expanded(
                                                    child: SizedBox(),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.grey,
                                                    size: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Image.asset("assets/settings/translation_logo.png", height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill),
                                      );
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                              Skeletonizer(
                                enabled: true,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 120),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 120),
                                            width: getIt<Functions>().getWidgetWidth(width: 120),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Colors.grey.shade100,
                                                border: Border.all(color: Colors.grey.shade400),
                                                image: const DecorationImage(
                                                  image: AssetImage("assets/general/maintenance.png"),
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                          SizedBox(
                                            width: getIt<Functions>().getWidgetWidth(width: 20),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                              ),
                                              Text(
                                                getIt<Variables>().generalVariables.profileValues.userName,
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 22), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                              ),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 4),
                                              ),
                                              Text(
                                                getIt<Variables>().generalVariables.profileValues.employeeType,
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff007AFF)),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: getIt<Functions>().getWidgetWidth(width: 20),
                                        right: getIt<Functions>().getWidgetWidth(width: 20),
                                        top: getIt<Functions>().getWidgetHeight(height: 28),
                                        bottom: getIt<Functions>().getWidgetHeight(height: 10),
                                      ),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                                      child: ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: getIt<Variables>().generalVariables.profileValues.data.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: getIt<Functions>().getWidgetHeight(height: 42),
                                                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color(0xffE0E7EC)))),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/settings/province.svg",
                                                                height: getIt<Functions>().getWidgetHeight(height: 28),
                                                                width: getIt<Functions>().getWidgetWidth(width: 28),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 10),
                                                              ),
                                                              Text(
                                                                getIt<Variables>().generalVariables.profileValues.data[index].label,
                                                                style: TextStyle(
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Text(
                                                            getIt<Variables>().generalVariables.profileValues.data[index].value,
                                                            style: TextStyle(
                                                              color: const Color(0xff6F6F6F),
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                                              ],
                                            );
                                          }),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    InkWell(
                                      onTap: () {
                                        if (getIt<Variables>().generalVariables.isNetworkOffline) {
                                          ScaffoldMessenger.of(context).clearSnackBars();
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getIt<Variables>().generalVariables.currentLanguage.offlineNotChangePsws)));
                                        } else {
                                          context.read<SettingsBloc>().currentPasswordController.clear();
                                          getIt<Variables>().generalVariables.popUpWidget = currentPasswordContent();
                                          getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                          vertical: getIt<Functions>().getWidgetHeight(height: 15),
                                        ),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/settings/change_password.svg",
                                              height: getIt<Functions>().getWidgetHeight(height: 28),
                                              width: getIt<Functions>().getWidgetWidth(width: 28),
                                            ),
                                            SizedBox(
                                              width: getIt<Functions>().getWidgetWidth(width: 10),
                                            ),
                                            Text(
                                              getIt<Variables>().generalVariables.currentLanguage.changePassword,
                                              style: TextStyle(
                                                color: const Color(0xff282F3A),
                                                fontWeight: FontWeight.w500,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            );
          }
          else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget currentPasswordContent() {
    return BlocProvider(
      create: (context) => SettingsBloc(),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listenWhen: (SettingsState previous, SettingsState current) {
          return previous != current;
        },
        buildWhen: (SettingsState previous, SettingsState current) {
          return previous != current;
        },
        listener: (BuildContext context, SettingsState state) {
          if (state is SettingsFailure) {
            context.read<SettingsBloc>().buttonLoader = false;
            Flushbar(
              message: state.message,
              duration: const Duration(seconds: 2),
              isDismissible: false,
            ).show(context);
          }
          if (state is SettingsDialogSuccess) {
            context.read<SettingsBloc>().buttonLoader = false;
            Navigator.pop(context);
            context.read<SettingsBloc>().newPasswordController.clear();
            context.read<SettingsBloc>().confirmPasswordController.clear();
            getIt<Variables>().generalVariables.popUpWidget = changePasswordContent();
            getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
          }
        },
        builder: (BuildContext context, SettingsState state) {
          return SizedBox(
            width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 600 : 450),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 4),
                      ),
                      SvgPicture.asset(
                        "assets/settings/lock.svg",
                        height: getIt<Functions>().getWidgetHeight(height: 70),
                        width: getIt<Functions>().getWidgetWidth(width: 70),
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 28),
                      ),
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.enterOldPassword,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 26 : 22), color: const Color(0xff282F3A)),
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 8),
                      ),
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.enterOldPasswordSubtitle,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff303030)),
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 40 : 25),
                      ),
                      textBars(controller: context.read<SettingsBloc>().currentPasswordController, isVisible: context.read<SettingsBloc>().isCurrentPasswordVisible, type: "Current"),
                      context.read<SettingsBloc>().isPasswordEmpty
                          ? SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 8),
                      )
                          : const SizedBox(),
                      context.read<SettingsBloc>().isPasswordEmpty
                          ? Text(
                        getIt<Variables>().generalVariables.currentLanguage.emptyOldPasswordField,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.red),
                      )
                          : const SizedBox(),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 50 : 25),
                      ),
                    ],
                  ),
                ),
                context.read<SettingsBloc>().buttonLoader
                    ? Container(
                  height: getIt<Functions>().getWidgetHeight(height: 50),
                  width: getIt<Functions>().getWidgetWidth(width: 50),
                  padding: EdgeInsets.symmetric(
                    horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                    vertical: getIt<Functions>().getWidgetHeight(height: 15),
                  ),
                  child: const CircularProgressIndicator(),
                )
                    : InkWell(
                  onTap: () {
                    FocusManager.instance.primaryFocus!.unfocus();
                    if (context.read<SettingsBloc>().currentPasswordController.text.isEmpty) {
                      context.read<SettingsBloc>().isPasswordEmpty = true;
                      context.read<SettingsBloc>().add(const SettingsSetStateEvent());
                    } else {
                      context.read<SettingsBloc>().buttonLoader = true;
                      context.read<SettingsBloc>().isPasswordEmpty = false;
                      context.read<SettingsBloc>().add(const SettingsSetStateEvent());
                      context.read<SettingsBloc>().add(const SettingsCurrentPasswordValidationEvent());
                    }
                  },
                  child: Container(
                    height: getIt<Functions>().getWidgetHeight(height: 50),
                    decoration: const BoxDecoration(
                      color: Color(0xff007838),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                    ),
                    child: Center(
                      child: Text(
                        getIt<Variables>().generalVariables.currentLanguage.next,
                        style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget changePasswordContent() {
    return BlocProvider(
      create: (context) => SettingsBloc(),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listenWhen: (SettingsState previous, SettingsState current) {
          return previous != current;
        },
        buildWhen: (SettingsState previous, SettingsState current) {
          return previous != current;
        },
        listener: (BuildContext context, SettingsState state) {
          if (state is SettingsFailure) {
            context.read<SettingsBloc>().buttonLoader = false;
            Flushbar(
              message: state.message,
              duration: const Duration(seconds: 2),
              isDismissible: false,
            ).show(context);
          }
          if (state is SettingsDialogSuccess) {
            context.read<SettingsBloc>().buttonLoader = false;
            context.read<SettingsBloc>().isPasswordChanged = true;
            context.read<SettingsBloc>().add(const SettingsSetStateEvent());
            context.read<SettingsBloc>().add(const SettingsLogoutEvent());
          }
          if (state is SettingsLogoutSuccess) {
            context.read<SettingsBloc>().buttonLoader = false;
            Navigator.pop(context);
            getIt<Variables>().generalVariables.popUpWidget = passwordChangedContent();
            getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: true);
          }
        },
        builder: (BuildContext context, SettingsState state) {
          return SizedBox(
            width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 600 : 450),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 4),
                      ),
                      SvgPicture.asset(
                        "assets/settings/lock.svg",
                        height: getIt<Functions>().getWidgetHeight(height: 70),
                        width: getIt<Functions>().getWidgetWidth(width: 70),
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 28),
                      ),
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.createNewPass,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 26 : 22), color: const Color(0xff282F3A)),
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 8),
                      ),
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.createNewPassSub1,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff303030)),
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 40 : 25),
                      ),
                      textBars(controller: context.read<SettingsBloc>().newPasswordController, isVisible: context.read<SettingsBloc>().isNewPasswordVisible, type: "New"),
                      context.read<SettingsBloc>().isNewPasswordEmpty
                          ? SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 8),
                      )
                          : const SizedBox(),
                      context.read<SettingsBloc>().isNewPasswordEmpty
                          ? Text(
                        getIt<Variables>().generalVariables.currentLanguage.emptyNewPassword,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.red),
                      )
                          : const SizedBox(),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 20 : 16),
                      ),
                      textBars(controller: context.read<SettingsBloc>().confirmPasswordController, isVisible: context.read<SettingsBloc>().isConfirmPasswordVisible, type: "Confirm"),
                      context.read<SettingsBloc>().isConfirmPasswordEmpty
                          ? SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 8),
                      )
                          : const SizedBox(),
                      context.read<SettingsBloc>().isConfirmPasswordEmpty
                          ? Text(
                        getIt<Variables>().generalVariables.currentLanguage.emptyConfirmPassword,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.red),
                      )
                          : const SizedBox(),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 50 : 25),
                      ),
                    ],
                  ),
                ),
                context.read<SettingsBloc>().buttonLoader
                    ? Container(
                  height: getIt<Functions>().getWidgetHeight(height: 50),
                  width: getIt<Functions>().getWidgetWidth(width: 50),
                  padding: EdgeInsets.symmetric(
                    horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                    vertical: getIt<Functions>().getWidgetHeight(height: 15),
                  ),
                  child: const CircularProgressIndicator(),
                )
                    : InkWell(
                  onTap: () {
                    if (context.read<SettingsBloc>().newPasswordController.text.isEmpty || context.read<SettingsBloc>().confirmPasswordController.text.isEmpty) {
                      if (context.read<SettingsBloc>().newPasswordController.text.isEmpty) {
                        context.read<SettingsBloc>().isNewPasswordEmpty = true;
                        context.read<SettingsBloc>().isConfirmPasswordEmpty = false;
                        context.read<SettingsBloc>().add(const SettingsSetStateEvent());
                      } else if (context.read<SettingsBloc>().confirmPasswordController.text.isEmpty) {
                        context.read<SettingsBloc>().isNewPasswordEmpty = false;
                        context.read<SettingsBloc>().isConfirmPasswordEmpty = true;
                        context.read<SettingsBloc>().add(const SettingsSetStateEvent());
                      }
                    } else {
                      context.read<SettingsBloc>().isNewPasswordEmpty = false;
                      context.read<SettingsBloc>().isConfirmPasswordEmpty = false;
                      context.read<SettingsBloc>().add(const SettingsSetStateEvent());
                      bool strongPassword = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,40}$').hasMatch(context.read<SettingsBloc>().newPasswordController.text);
                      if (context.read<SettingsBloc>().newPasswordController.text != context.read<SettingsBloc>().confirmPasswordController.text) {
                        Flushbar(
                          message: getIt<Variables>().generalVariables.currentLanguage.pswdNotMatched,
                          duration: const Duration(seconds: 2),
                          isDismissible: false,
                        ).show(context);
                      } else if (!strongPassword) {
                        Flushbar(
                          title: getIt<Variables>().generalVariables.currentLanguage.tryStrongPswd,
                          message: getIt<Variables>().generalVariables.currentLanguage.pswdInstruction,
                          duration: const Duration(seconds: 5),
                          isDismissible: false,
                        ).show(context);
                      } else {
                        context.read<SettingsBloc>().buttonLoader = true;
                        context.read<SettingsBloc>().add(const SettingsChangePasswordEvent());
                      }
                    }
                  },
                  child: Container(
                    height: getIt<Functions>().getWidgetHeight(height: 50),
                    decoration: const BoxDecoration(
                      color: Color(0xff007838),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                    ),
                    child: Center(
                      child: Text(
                        getIt<Variables>().generalVariables.currentLanguage.next,
                        style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget passwordChangedContent() {
    return SizedBox(
      width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 600 : 450),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/settings/grey_circle.svg",
                      height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 154 : 100),
                      width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 154 : 100),
                    ),
                    SvgPicture.asset(
                      "assets/settings/lock_yellow.svg",
                      height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 100 : 65),
                      width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 100 : 65),
                    ),
                  ],
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 17 : 12),
                ),
                Text(
                  getIt<Variables>().generalVariables.currentLanguage.passwordChanged,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 26 : 22), color: const Color(0xff282F3A)),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 8),
                ),
                SizedBox(
                  width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 499 : 325),
                  child: Text(
                    getIt<Variables>().generalVariables.currentLanguage.passwordChangedSub,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff303030)),
                  ),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 50 : 25),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              context.read<SettingsBloc>().isPasswordChanged = false;
              getIt<Variables>().generalVariables.indexName = LoginScreen.id;
              context.read<NavigationBloc>().add(const NavigationInitialEvent());
            },
            child: Container(
              height: getIt<Functions>().getWidgetHeight(height: 50),
              decoration: const BoxDecoration(
                color: Color(0xff007838),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
              ),
              child: Center(
                child: Text(
                  getIt<Variables>().generalVariables.currentLanguage.continueText,
                  style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget logOutContent() {
    return BlocProvider(
      create: (context) => SettingsBloc(),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listenWhen: (SettingsState previous, SettingsState current) {
          return previous != current;
        },
        buildWhen: (SettingsState previous, SettingsState current) {
          return previous != current;
        },
        listener: (BuildContext context, SettingsState state) {
          if (state is SettingsFailure) {
            context.read<SettingsBloc>().buttonLoader = false;
            context.read<SettingsBloc>().add(const SettingsSetStateEvent());
            Flushbar(
              message: state.message,
              duration: const Duration(seconds: 2),
              isDismissible: false,
            ).show(context);
          }
          if (state is SettingsLogoutSuccess) {
            context.read<SettingsBloc>().buttonLoader = false;
            context.read<SettingsBloc>().add(const SettingsSetStateEvent());
            Navigator.pop(context);
            getIt<Variables>().generalVariables.indexName = LoginScreen.id;
            context.read<NavigationBloc>().add(const NavigationInitialEvent());
          }
        },
        builder: (BuildContext context, SettingsState state) {
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
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "${getIt<Variables>().generalVariables.currentLanguage.logOut} ? ",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 24 : 22), color: const Color(0xff282F3A)),
                  ),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 16 : 12),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    getIt<Variables>().generalVariables.currentLanguage.areYouSureThatYouWantToLogOut,
                    maxLines: 2,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff303030)),
                  ),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 16 : 12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    context.read<SettingsBloc>().buttonLoader
                        ? const SizedBox()
                        : TextButton(
                      style: TextButton.styleFrom(minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 90), getIt<Functions>().getWidgetHeight(height: 50))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: getIt<Functions>().getWidgetWidth(width: 90),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.cancel,
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff303030)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: getIt<Functions>().getWidgetWidth(width: 16),
                    ),
                    context.read<SettingsBloc>().buttonLoader
                        ? Container(
                      height: getIt<Functions>().getWidgetHeight(height: 50),
                      width: getIt<Functions>().getWidgetWidth(width: 50),
                      padding: EdgeInsets.symmetric(
                        horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                        vertical: getIt<Functions>().getWidgetHeight(height: 15),
                      ),
                      child: const CircularProgressIndicator(),
                    )
                        : TextButton(
                      style: TextButton.styleFrom(minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 90), getIt<Functions>().getWidgetHeight(height: 50))),
                      onPressed: () {
                        context.read<SettingsBloc>().buttonLoader = true;
                        context.read<SettingsBloc>().add(const SettingsSetStateEvent());
                        context.read<SettingsBloc>().add(const SettingsLogoutEvent());
                      },
                      child: SizedBox(
                        width: getIt<Functions>().getWidgetWidth(width: 90),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.logOut,
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget textBars({required TextEditingController controller, required bool isVisible, required String type}) {
    return BlocProvider(
      create: (context) => SettingsBloc(),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return SizedBox(
            height: getIt<Functions>().getWidgetHeight(height: 70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.toLowerCase() == "current"
                      ? getIt<Variables>().generalVariables.currentLanguage.currentPassword.replaceAll("p", "P")
                      : type.toLowerCase() == "new"
                      ? getIt<Variables>().generalVariables.currentLanguage.newPass.replaceAll("p", "P")
                      : type.toLowerCase() == "confirm"
                      ? getIt<Variables>().generalVariables.currentLanguage.confirmPassword.replaceAll("p", "P")
                      : "$type Password",
                  style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 45),
                  child: TextFormField(
                    controller: controller,
                    cursorColor: const Color(0xff000000),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff282F3A),
                    ),
                    obscureText: isVisible,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffE0E6EE).withOpacity(0.12),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68),
                        ),
                        hintText: type.toLowerCase() == "current"
                            ? getIt<Variables>().generalVariables.currentLanguage.enterCurrentPassword
                            : type.toLowerCase() == "new"
                            ? getIt<Variables>().generalVariables.currentLanguage.enterNewPass
                            : type.toLowerCase() == "confirm"
                            ? getIt<Variables>().generalVariables.currentLanguage.enterConfirmPassword
                            : "Enter $type Password",
                        hintStyle: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff8A8D8E)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            isVisible = !isVisible;
                            context.read<SettingsBloc>().add(const SettingsSetStateEvent());
                          },
                          icon: SvgPicture.asset(isVisible ? "assets/general/open_eyes.svg" : "assets/general/closed_eye_icon.svg", height: getIt<Functions>().getWidgetHeight(height: 20), width: getIt<Functions>().getWidgetWidth(width: 20)),
                        )),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
