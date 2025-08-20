// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glassmorphism/glassmorphism.dart';

// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/registration/login/login_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';
import 'package:oda/screens/registration/forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool loader = false;
  bool isExpanded = false;
  bool isReducedSize = false;
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;
  bool isLoginEmpty = false;
  bool isPasswordEmpty = false;
  int selectedPopUpIndex = 0;
  String selectedLanguage = "ENGLISH";
  bool isKeyPadOpen = false;
  late StreamSubscription<bool> keyboardSubscription;
  KeyboardVisibilityController keyboardVisibilityController = KeyboardVisibilityController();

  @override
  void initState() {
    super.initState();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyPadOpen = visible;
      setState(() {});
    });
    _controller = AnimationController(duration: const Duration(milliseconds: 75), vsync: this);
    selectedLanguage = getIt<Variables>().generalVariables.languageList[getIt<Variables>().generalVariables.languageList.indexWhere((element) => element.code == getIt<Variables>().generalVariables.loggedHeaders.lang)].name;
    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward().then((value){
        setState(() {
          isExpanded = !isExpanded;
        });
      });
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) {
        getIt<Widgets>().showAnimatedDialog(
          context: context,
          height: 180,
          width: 300,
          child: exitAppContent(context: context),
          isLogout: true,
        );
      },
      canPop: false,
      child: BlocProvider(
        create: (context) => LoginBloc()..add(const LoginInitialEvent()),
        child: BlocConsumer<LoginBloc, LoginState>(
          listenWhen: (LoginState previous, LoginState current) {
            return previous != current;
          },
          buildWhen: (LoginState previous, LoginState current) {
            return previous != current;
          },
          listener: (BuildContext context, LoginState login) {
            if (login is LoginDialogState) {
              getIt<Widgets>().showAlertDialog(
                context: context,
                content: updateOrMaintenanceDialogContent(),
                isDismissible: getIt<Variables>().generalVariables.initialSetupValues.dismissInfo,
              );
            }
            if (login is LoginSuccess) {
              loader = false;
              getIt<Variables>().generalVariables.isLoggedIn = true;
              getIt<Variables>().generalVariables.isConfirmLoggedIn = true;
              context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 0));
              context.read<NavigationBloc>().add(const NavigationInitialEvent());
              loginController.clear();
              passwordController.clear();
            }
            if (login is LoginFailure) {
              loader = false;
              context.read<LoginBloc>().add(const LoginSetStateEvent());
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(login.message)));
            }
          },
          builder: (BuildContext context, LoginState login) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth > 480) {
                  var orientation = MediaQuery.of(context).orientation;
                  return orientation == Orientation.portrait
                      ? SingleChildScrollView(
                          child: Container(
                            height: getIt<Variables>().generalVariables.height,
                            width: getIt<Variables>().generalVariables.width,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage("assets/general/background.png"),
                              fit: BoxFit.fill,
                            )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AnimatedCrossFade(
                                    firstChild: SizedBox(height: getIt<Functions>().getWidgetHeight(height: 50)),
                                    secondChild: const SizedBox(),
                                    crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                    duration: const Duration(milliseconds: 150)),
                                SvgPicture.asset(
                                  "assets/general/app_logo.svg",
                                  height: getIt<Functions>().getWidgetHeight(height: 100),
                                  width: getIt<Functions>().getWidgetWidth(width: 100),
                                  fit: BoxFit.fill,
                                ),
                                AnimatedCrossFade(
                                    firstChild: SizedBox(height: getIt<Functions>().getWidgetHeight(height: 50)),
                                    secondChild: const SizedBox(),
                                    crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                    duration: const Duration(milliseconds: 150)),
                                AnimatedCrossFade(
                                    firstChild: Center(
                                      child: GlassmorphicContainer(
                                        height: getIt<Functions>().getWidgetHeight(height: 510),
                                        width: getIt<Functions>().getWidgetWidth(width: 470),
                                        borderRadius: 9,
                                        blur: 16,
                                        alignment: Alignment.bottomCenter,
                                        border: 0.71,
                                        linearGradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            const Color(0xFFffffff).withOpacity(0.5),
                                            const Color(0xFFFFFFFF).withOpacity(0.1),
                                          ],
                                        ),
                                        borderGradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            const Color(0xFFE0E6EE).withOpacity(0.8),
                                            const Color(0xFFE0E6EE).withOpacity(0.8),
                                          ],
                                        ),
                                        child: Container(
                                          width: getIt<Functions>().getWidgetWidth(width: 470),
                                          padding: EdgeInsets.symmetric(
                                            vertical: getIt<Functions>().getWidgetHeight(height: 28),
                                            horizontal: getIt<Functions>().getWidgetWidth(width: 28),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.logIn,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                    color: const Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 35)),
                                              textBars(controller: loginController, isPassword: false),
                                              isLoginEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                              isLoginEmpty
                                                  ? Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.emptyLoginId,
                                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                    )
                                                  : const SizedBox(),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                                              textBars(controller: passwordController, isPassword: true),
                                              isPasswordEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                              isPasswordEmpty
                                                  ? Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.emptyOldPasswordField,
                                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                    )
                                                  : const SizedBox(),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 15)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        getIt<Variables>().generalVariables.indexName = ForgetPasswordScreen.id;
                                                        getIt<Variables>().generalVariables.loginRouteList.add(LoginScreen.id);
                                                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                      },
                                                      child: Text(
                                                        "${getIt<Variables>().generalVariables.currentLanguage.forgotPass} ?",
                                                        style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                      ))
                                                ],
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                              LoadingButton(
                                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                                width: getIt<Functions>().getWidgetWidth(width: 414),
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                status: loader,
                                                onTap: () {
                                                  loader = true;
                                                  FocusManager.instance.primaryFocus!.unfocus();
                                                  context.read<LoginBloc>().add(const LoginSetStateEvent());
                                                  if (loginController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
                                                    if (loginController.text.trim().isEmpty) {
                                                      loginController.clear();
                                                      isLoginEmpty = true;
                                                      isPasswordEmpty = false;
                                                      loader = false;
                                                      context.read<LoginBloc>().add(const LoginSetStateEvent());
                                                    } else if (passwordController.text.trim().isEmpty) {
                                                      passwordController.clear();
                                                      isLoginEmpty = false;
                                                      isPasswordEmpty = true;
                                                      loader = false;
                                                      context.read<LoginBloc>().add(const LoginSetStateEvent());
                                                    }
                                                  } else {
                                                    isLoginEmpty = false;
                                                    isPasswordEmpty = false;
                                                    context.read<LoginBloc>().add(LoginButtonEvent(userId: loginController.text.trim(), password: passwordController.text));
                                                  }
                                                },
                                                text: getIt<Variables>().generalVariables.currentLanguage.logInButton,
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                              BlocConsumer<NavigationBloc, NavigationState>(
                                                listenWhen: (NavigationState previous, NavigationState current) {
                                                  return previous != current;
                                                },
                                                buildWhen: (NavigationState previous, NavigationState current) {
                                                  return previous != current;
                                                },
                                                listener: (BuildContext context, NavigationState navigation) {
                                                  if (navigation is LanguageChanged) {
                                                    context.read<LoginBloc>().add(const LoginSetStateEvent());
                                                  }
                                                },
                                                builder: (BuildContext context, NavigationState state) {
                                                  return PopupMenuButton(
                                                    offset: const Offset(1, 35),
                                                    color: Colors.white,
                                                    elevation: 2,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                    itemBuilder: (BuildContext context) {
                                                      return List.generate(
                                                        getIt<Variables>().generalVariables.languageList.length,
                                                        (index) => PopupMenuItem(
                                                          onTap: () {
                                                            selectedLanguage = getIt<Variables>().generalVariables.languageList[index].name;
                                                            context.read<NavigationBloc>().add(LanguageChangingEvent(index: index));
                                                          },
                                                          value: getIt<Variables>().generalVariables.languageList.indexWhere((element) => element.code == getIt<Variables>().generalVariables.loggedHeaders.lang),
                                                          child: Row(
                                                            children: [
                                                              getIt<Variables>().generalVariables.languageList[index].code == getIt<Variables>().generalVariables.loggedHeaders.lang
                                                                  ? Image.asset("assets/settings/translation_logo_filled.png",
                                                                      height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill)
                                                                  : Image.asset("assets/settings/translation_logo.png", height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 10),
                                                              ),
                                                              Text(
                                                                getIt<Variables>().generalVariables.languageList[index].name,
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
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Image.asset("assets/settings/translation_logo.png", height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill),
                                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                        Text(
                                                          selectedLanguage,
                                                          style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                        ),
                                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                        const Icon(Icons.arrow_drop_down, color: Colors.white)
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    secondChild: const SizedBox(),
                                    crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                    duration: const Duration(milliseconds: 150)),
                                AnimatedCrossFade(
                                    firstChild: SizedBox(height: getIt<Functions>().getWidgetHeight(height: 50)),
                                    secondChild: const SizedBox(),
                                    crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                    duration: const Duration(milliseconds: 150)),
                                AnimatedCrossFade(
                                    firstChild: RichText(
                                      text: TextSpan(
                                        text: getIt<Variables>().generalVariables.currentLanguage.poweredByEWF,
                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xffffffff), fontWeight: FontWeight.w400),
                                        children: <TextSpan>[
                                          TextSpan(text: '', style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xffffffff), fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                    secondChild: const SizedBox(),
                                    crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                    duration: const Duration(milliseconds: 150)),
                                AnimatedCrossFade(
                                    firstChild: SizedBox(height: getIt<Functions>().getWidgetHeight(height: 50)),
                                    secondChild: const SizedBox(),
                                    crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                    duration: const Duration(milliseconds: 150)),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Container(
                            height: getIt<Variables>().generalVariables.width,
                            width: getIt<Variables>().generalVariables.height,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage("assets/general/background.png"),
                              fit: BoxFit.fill,
                            )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AnimatedCrossFade(
                                    firstChild: SizedBox(width: getIt<Functions>().getWidgetWidth(width: 75)),
                                    secondChild: const SizedBox(),
                                    crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                    duration: const Duration(milliseconds: 150)),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/general/app_logo.svg",
                                      height: getIt<Functions>().getWidgetHeight(height: 125),
                                      width: getIt<Functions>().getWidgetWidth(width: 125),
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                    RichText(
                                      text: TextSpan(
                                        text: getIt<Variables>().generalVariables.currentLanguage.poweredByEWF,
                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xffffffff), fontWeight: FontWeight.w400),
                                        children: <TextSpan>[
                                          TextSpan(text: '', style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xffffffff), fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                  ],
                                ),
                                AnimatedCrossFade(
                                    firstChild: SizedBox(width: getIt<Functions>().getWidgetWidth(width: 50)),
                                    secondChild: const SizedBox(),
                                    crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                    duration: const Duration(milliseconds: 150)),
                                AnimatedCrossFade(
                                    firstChild: Center(
                                      child: GlassmorphicContainer(
                                        height: getIt<Functions>().getWidgetHeight(height: 510),
                                        width: getIt<Functions>().getWidgetWidth(width: 470),
                                        borderRadius: 9,
                                        blur: 16,
                                        alignment: Alignment.bottomCenter,
                                        border: 0.71,
                                        linearGradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            const Color(0xFFffffff).withOpacity(0.5),
                                            const Color(0xFFFFFFFF).withOpacity(0.1),
                                          ],
                                        ),
                                        borderGradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            const Color(0xFFE0E6EE).withOpacity(0.8),
                                            const Color(0xFFE0E6EE).withOpacity(0.8),
                                          ],
                                        ),
                                        child: Container(
                                          width: getIt<Functions>().getWidgetWidth(width: 470),
                                          padding: EdgeInsets.symmetric(
                                            vertical: getIt<Functions>().getWidgetHeight(height: 28),
                                            horizontal: getIt<Functions>().getWidgetWidth(width: 28),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.logIn,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                    color: const Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 35)),
                                              textBars(controller: loginController, isPassword: false),
                                              isLoginEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                              isLoginEmpty
                                                  ? Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.emptyLoginId,
                                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                    )
                                                  : const SizedBox(),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                                              textBars(controller: passwordController, isPassword: true),
                                              isPasswordEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                              isPasswordEmpty
                                                  ? Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.emptyOldPasswordField,
                                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                    )
                                                  : const SizedBox(),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 15)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        getIt<Variables>().generalVariables.indexName = ForgetPasswordScreen.id;
                                                        getIt<Variables>().generalVariables.loginRouteList.add(LoginScreen.id);
                                                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                      },
                                                      child: Text(
                                                        "${getIt<Variables>().generalVariables.currentLanguage.forgotPass} ?",
                                                        style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                      ))
                                                ],
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                              LoadingButton(
                                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                                width: getIt<Functions>().getWidgetWidth(width: 414),
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                status: loader,
                                                onTap: () {
                                                  loader = true;
                                                  FocusManager.instance.primaryFocus!.unfocus();
                                                  context.read<LoginBloc>().add(const LoginSetStateEvent());
                                                  if (loginController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
                                                    if (loginController.text.trim().isEmpty) {
                                                      loginController.clear();
                                                      isLoginEmpty = true;
                                                      isPasswordEmpty = false;
                                                      loader = false;
                                                      context.read<LoginBloc>().add(const LoginSetStateEvent());
                                                    } else if (passwordController.text.trim().isEmpty) {
                                                      passwordController.clear();
                                                      isLoginEmpty = false;
                                                      isPasswordEmpty = true;
                                                      loader = false;
                                                      context.read<LoginBloc>().add(const LoginSetStateEvent());
                                                    }
                                                  } else {
                                                    isLoginEmpty = false;
                                                    isPasswordEmpty = false;
                                                    context.read<LoginBloc>().add(LoginButtonEvent(userId: loginController.text.trim(), password: passwordController.text));
                                                  }
                                                },
                                                text: getIt<Variables>().generalVariables.currentLanguage.logInButton,
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                              BlocConsumer<NavigationBloc, NavigationState>(
                                                listenWhen: (NavigationState previous, NavigationState current) {
                                                  return previous != current;
                                                },
                                                buildWhen: (NavigationState previous, NavigationState current) {
                                                  return previous != current;
                                                },
                                                listener: (BuildContext context, NavigationState navigation) {
                                                  if (navigation is LanguageChanged) {
                                                    context.read<LoginBloc>().add(const LoginSetStateEvent());
                                                  }
                                                },
                                                builder: (BuildContext context, NavigationState state) {
                                                  return PopupMenuButton(
                                                    offset: const Offset(1, 35),
                                                    color: Colors.white,
                                                    elevation: 2,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                    itemBuilder: (BuildContext context) {
                                                      return List.generate(
                                                        getIt<Variables>().generalVariables.languageList.length,
                                                        (index) => PopupMenuItem(
                                                          onTap: () {
                                                            selectedLanguage = getIt<Variables>().generalVariables.languageList[index].name;
                                                            context.read<NavigationBloc>().add(LanguageChangingEvent(index: index));
                                                          },
                                                          value: getIt<Variables>().generalVariables.languageList.indexWhere((element) => element.code == getIt<Variables>().generalVariables.loggedHeaders.lang),
                                                          child: Row(
                                                            children: [
                                                              getIt<Variables>().generalVariables.languageList[index].code == getIt<Variables>().generalVariables.loggedHeaders.lang
                                                                  ? Image.asset("assets/settings/translation_logo_filled.png",
                                                                      height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill)
                                                                  : Image.asset("assets/settings/translation_logo.png", height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 10),
                                                              ),
                                                              Text(
                                                                getIt<Variables>().generalVariables.languageList[index].name,
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
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Image.asset("assets/settings/translation_logo.png", height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill),
                                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                        Text(
                                                          selectedLanguage,
                                                          style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                        ),
                                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                        const Icon(Icons.arrow_drop_down, color: Colors.white)
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    secondChild: const SizedBox(),
                                    crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                    duration: const Duration(milliseconds: 150)),
                                AnimatedCrossFade(
                                    firstChild: SizedBox(width: getIt<Functions>().getWidgetWidth(width: 25)),
                                    secondChild: const SizedBox(),
                                    crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                    duration: const Duration(milliseconds: 150)),
                              ],
                            ),
                          ),
                        );
                } else {
                  _animation = Tween<Offset>(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(0.0, -4.15),
                  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
                  return SingleChildScrollView(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      height: isKeyPadOpen ? getIt<Variables>().generalVariables.height - (getIt<Functions>().getWidgetHeight(height: 192)) : getIt<Variables>().generalVariables.height+1,
                      width: getIt<Variables>().generalVariables.width,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/general/background.png"),
                        fit: BoxFit.fill,
                      )),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedCrossFade(
                              firstChild: Column(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 350),
                                    height: getIt<Functions>().getWidgetHeight(height: isKeyPadOpen ? 185 : 270),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                                    child: GlassmorphicContainer(
                                      height: getIt<Functions>().getWidgetHeight(height: 475),
                                      width: getIt<Functions>().getWidgetWidth(width: 450),
                                      borderRadius: 6,
                                      blur: 16,
                                      alignment: Alignment.bottomCenter,
                                      border: 0.71,
                                      linearGradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          const Color(0xFFffffff).withOpacity(0.5),
                                          const Color(0xFFFFFFFF).withOpacity(0.1),
                                        ],
                                      ),
                                      borderGradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          const Color(0xFFE0E6EE).withOpacity(0.8),
                                          const Color(0xFFE0E6EE).withOpacity(0.8),
                                        ],
                                      ),
                                      child: Container(
                                        width: getIt<Functions>().getWidgetWidth(width: 380),
                                        padding: EdgeInsets.symmetric(
                                          vertical: getIt<Functions>().getWidgetHeight(height: 23),
                                          horizontal: getIt<Functions>().getWidgetWidth(width: 23),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.logIn,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 22),
                                                  color: const Color(0xffffffff),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 32)),
                                            textBars(controller: loginController, isPassword: false),
                                            isLoginEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                            isLoginEmpty
                                                ? Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.emptyLoginId,
                                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                  )
                                                : const SizedBox(),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
                                            textBars(controller: passwordController, isPassword: true),
                                            isPasswordEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                            isPasswordEmpty
                                                ? Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.emptyOldPasswordField,
                                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                  )
                                                : const SizedBox(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      getIt<Variables>().generalVariables.indexName = ForgetPasswordScreen.id;
                                                      getIt<Variables>().generalVariables.loginRouteList.add(LoginScreen.id);
                                                      context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                    },
                                                    child: Text(
                                                      "${getIt<Variables>().generalVariables.currentLanguage.forgotPass} ?",
                                                      style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                    ))
                                              ],
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 25)),
                                            LoadingButton(
                                              height: getIt<Functions>().getWidgetHeight(height: 45),
                                              width: getIt<Functions>().getWidgetWidth(width: 414),
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                              status: loader,
                                              onTap: () {
                                                loader = true;
                                                FocusManager.instance.primaryFocus!.unfocus();
                                                context.read<LoginBloc>().add(const LoginSetStateEvent());
                                                if (loginController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
                                                  if (loginController.text.trim().isEmpty) {
                                                    loginController.clear();
                                                    isLoginEmpty = true;
                                                    isPasswordEmpty = false;
                                                    loader = false;
                                                    context.read<LoginBloc>().add(const LoginSetStateEvent());
                                                  } else if (passwordController.text.trim().isEmpty) {
                                                    passwordController.clear();
                                                    isLoginEmpty = false;
                                                    isPasswordEmpty = true;
                                                    loader = false;
                                                    context.read<LoginBloc>().add(const LoginSetStateEvent());
                                                  }
                                                } else {
                                                  isLoginEmpty = false;
                                                  isPasswordEmpty = false;
                                                  context.read<LoginBloc>().add(LoginButtonEvent(userId: loginController.text.trim(), password: passwordController.text));
                                                }
                                              },
                                              text: getIt<Variables>().generalVariables.currentLanguage.logInButton,
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                            BlocConsumer<NavigationBloc, NavigationState>(
                                              listenWhen: (NavigationState previous, NavigationState current) {
                                                return previous != current;
                                              },
                                              buildWhen: (NavigationState previous, NavigationState current) {
                                                return previous != current;
                                              },
                                              listener: (BuildContext context, NavigationState navigation) {
                                                if (navigation is LanguageChanged) {
                                                  context.read<LoginBloc>().add(const LoginSetStateEvent());
                                                }
                                              },
                                              builder: (BuildContext context, NavigationState state) {
                                                return PopupMenuButton(
                                                  offset: const Offset(1, 35),
                                                  color: Colors.white,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                  itemBuilder: (BuildContext context) {
                                                    return List.generate(
                                                      getIt<Variables>().generalVariables.languageList.length,
                                                      (index) => PopupMenuItem(
                                                        onTap: () {
                                                          selectedLanguage = getIt<Variables>().generalVariables.languageList[index].name;
                                                          getIt<Variables>().generalVariables.loggedHeaders.lang = getIt<Variables>().generalVariables.languageList[index].code;
                                                          context.read<NavigationBloc>().add(LanguageChangingEvent(index: index));
                                                        },
                                                        value: getIt<Variables>().generalVariables.languageList.indexWhere((element) => element.code == getIt<Variables>().generalVariables.loggedHeaders.lang),
                                                        child: Row(
                                                          children: [
                                                            getIt<Variables>().generalVariables.languageList[index].code == getIt<Variables>().generalVariables.loggedHeaders.lang
                                                                ? Image.asset("assets/settings/translation_logo_filled.png",
                                                                    height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill)
                                                                : Image.asset("assets/settings/translation_logo.png", height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill),
                                                            SizedBox(
                                                              width: getIt<Functions>().getWidgetWidth(width: 10),
                                                            ),
                                                            Text(
                                                              getIt<Variables>().generalVariables.languageList[index].name,
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
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.asset("assets/settings/translation_logo.png", height: getIt<Functions>().getWidgetHeight(height: 35), width: getIt<Functions>().getWidgetWidth(width: 35), fit: BoxFit.fill),
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                      Text(
                                                        selectedLanguage,
                                                        style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                      ),
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                      const Icon(Icons.arrow_drop_down, color: Colors.white)
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 350),
                                    height: getIt<Functions>().getWidgetHeight(height: isKeyPadOpen ? 40 : 108),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: getIt<Variables>().generalVariables.currentLanguage.poweredByEWF,
                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 13), color: const Color(0xffffffff), fontWeight: FontWeight.w300, fontFamily: "Figtree"),
                                      children: <TextSpan>[
                                        TextSpan(text: '', style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 13), color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontFamily: "Figtree")),
                                      ],
                                    ),
                                  ),
                                  AnimatedContainer(duration: const Duration(milliseconds: 350), height: getIt<Functions>().getWidgetHeight(height: isKeyPadOpen ? 8 : 45)),
                                ],
                              ),
                              secondChild: const SizedBox(),
                              crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              duration: const Duration(milliseconds: 150)),
                          isExpanded
                              ? Positioned(
                                  top: getIt<Functions>().getWidgetHeight(height: 80),
                                  child: SvgPicture.asset(
                                    "assets/general/app_logo.svg",
                                    height: getIt<Functions>().getWidgetHeight(height: 82),
                                    width: getIt<Functions>().getWidgetWidth(width: 90),
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : SlideTransition(
                                  position: _animation,
                                  child: SvgPicture.asset(
                                    "assets/general/app_logo.svg",
                                    height: getIt<Functions>().getWidgetHeight(height: 82),
                                    width: getIt<Functions>().getWidgetWidth(width: 90),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget textBars({required TextEditingController controller, required bool isPassword}) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SizedBox(
            height: getIt<Functions>().getWidgetHeight(height: 71),
            width: getIt<Functions>().getWidgetWidth(width: 414),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPassword ? getIt<Variables>().generalVariables.currentLanguage.password : getIt<Variables>().generalVariables.currentLanguage.logInId,
                  style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w400, color: const Color(0xffffffff)),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 45),
                  child: TextFormField(
                    controller: controller,
                    cursorColor: const Color(0xffE0E6EE),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontSize: getIt<Functions>().getTextSize(
                            fontSize: getIt<Variables>().generalVariables.isDeviceTablet
                                ? isPassword && isVisible
                                    ? 10
                                    : 15
                                : 15),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xffFFFFFF),
                        decoration: TextDecoration.none),
                    autocorrect: false,
                    enableSuggestions: false,
                    obscureText: isPassword ? isVisible : false,
                    obscuringCharacter: '●',
                    decoration: InputDecoration(
                      fillColor: const Color(0xffE0E6EE).withOpacity(0.12),
                      filled: true,
                      contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68),
                      ),
                      suffixIcon: isPassword
                          ? IconButton(
                              onPressed: () {
                                isVisible = !isVisible;
                                context.read<LoginBloc>().add(const LoginSetStateEvent());
                              },
                              icon: SvgPicture.asset(isVisible ? "assets/general/eye.svg" : "assets/general/eye-slash.svg",
                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                  width: getIt<Functions>()
                                      .getWidgetWidth(width: 20)), /*Icon(
                                isVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                              ),*/
                            )
                          : const SizedBox(),
                    ),
                  ),
                )
              ],
            ),
          );
        },
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
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 24 : 20), color: const Color(0xff282F3A)),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 8),
                ),
                SizedBox(
                  width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 499 : 325),
                  child: Text(
                    getIt<Variables>().generalVariables.initialSetupValues.infoMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff303030)),
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
                          decoration:
                              BoxDecoration(color: Colors.red, borderRadius: BorderRadius.only(bottomLeft: const Radius.circular(15), bottomRight: Radius.circular(getIt<Variables>().generalVariables.initialSetupValues.infoButton == "" ? 15 : 0))),
                          child: Center(
                            child: Text(
                              getIt<Variables>().generalVariables.currentLanguage.cancel,
                              style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
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
                          decoration:
                              BoxDecoration(color: Colors.green, borderRadius: BorderRadius.only(bottomRight: const Radius.circular(15), bottomLeft: Radius.circular(getIt<Variables>().generalVariables.initialSetupValues.dismissInfo ? 0 : 15))),
                          child: Center(
                            child: Text(
                              getIt<Variables>().generalVariables.initialSetupValues.infoButton,
                              style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
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
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 24 : 22), color: const Color(0xff282F3A)),
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
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff303030)),
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
}
