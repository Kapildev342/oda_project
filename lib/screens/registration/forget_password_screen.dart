// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glassmorphism/glassmorphism.dart';

// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/registration/forget_password/forget_password_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';
import 'package:oda/screens/registration/otp_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const String id = "forget_screen";

  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController loginController = TextEditingController();
  bool loader = false;
  bool isLoginFieldEmpty = false;
  bool isKeyPadOpen = false;
  late StreamSubscription<bool> keyboardSubscription;
  KeyboardVisibilityController keyboardVisibilityController = KeyboardVisibilityController();

  @override
  void initState() {
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyPadOpen = visible;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    loginController.dispose();
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) {
        getIt<Variables>().generalVariables.indexName = getIt<Variables>().generalVariables.loginRouteList[getIt<Variables>().generalVariables.loginRouteList.length - 1];
        context.read<NavigationBloc>().add(const NavigationInitialEvent());
        getIt<Variables>().generalVariables.loginRouteList.removeAt(getIt<Variables>().generalVariables.loginRouteList.length - 1);
      },
      canPop: false,
      child: BlocProvider(
        create: (context) => ForgetPasswordBloc(),
        child: BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
          listenWhen: (ForgetPasswordState previous, ForgetPasswordState current) {
            return previous != current;
          },
          buildWhen: (ForgetPasswordState previous, ForgetPasswordState current) {
            return previous != current;
          },
          listener: (BuildContext context, ForgetPasswordState state) {
            if (state is ForgetPasswordSuccess) {
              loader = false;
              context.read<ForgetPasswordBloc>().add(const ForgetPasswordSetStateEvent());
              getIt<Variables>().generalVariables.indexName = OtpScreen.id;
              getIt<Variables>().generalVariables.loginRouteList.add(ForgetPasswordScreen.id);
              context.read<NavigationBloc>().add(const NavigationInitialEvent());
            }
            if (state is ForgetPasswordFailure) {
              loader = false;
              context.read<ForgetPasswordBloc>().add(const ForgetPasswordSetStateEvent());
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (BuildContext context, ForgetPasswordState state) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth > 480) {
                  return SingleChildScrollView(
                    child: Container(
                      height: Orientation.portrait == MediaQuery.of(context).orientation ? getIt<Variables>().generalVariables.height : getIt<Variables>().generalVariables.width,
                      width: Orientation.portrait == MediaQuery.of(context).orientation ? getIt<Variables>().generalVariables.width : getIt<Variables>().generalVariables.height,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/general/background.png"),
                        fit: BoxFit.fill,
                      )),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: Orientation.portrait == MediaQuery.of(context).orientation ? getIt<Variables>().generalVariables.height : getIt<Variables>().generalVariables.width),
                            width: getIt<Functions>().getWidgetWidth(width: Orientation.portrait == MediaQuery.of(context).orientation ? getIt<Variables>().generalVariables.width : getIt<Variables>().generalVariables.height),
                            child: Column(
                              children: [
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                Expanded(
                                  child: Center(
                                    child: GlassmorphicContainer(
                                      height: getIt<Functions>().getWidgetHeight(height: 405),
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
                                              child: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.forgotPass,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                  color: const Color(0xffffffff),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                            Expanded(
                                              child: AutoSizeText(
                                                maxFontSize: getIt<Functions>().getTextSize(fontSize:14),
                                                minFontSize: getIt<Functions>().getTextSize(fontSize:10),
                                                softWrap: true,
                                                getIt<Variables>().generalVariables.currentLanguage.enterEmailIdText,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xfff9f9f9),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                            textBars(controller: loginController),
                                            isLoginFieldEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                            isLoginFieldEmpty
                                                ? Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.emptyLoginId,
                                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                  )
                                                : const SizedBox(),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
                                            LoadingButton(
                                              height: getIt<Functions>().getWidgetHeight(height: 45),
                                              width: getIt<Functions>().getWidgetWidth(width: 414),
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                              status: loader,
                                              onTap: () {
                                                FocusManager.instance.primaryFocus!.unfocus();
                                                loader = true;
                                                context.read<ForgetPasswordBloc>().add(const ForgetPasswordSetStateEvent());
                                                if (loginController.text.isEmpty) {
                                                  isLoginFieldEmpty = true;
                                                  loader = false;
                                                  context.read<ForgetPasswordBloc>().add(const ForgetPasswordSetStateEvent());
                                                } else {
                                                  isLoginFieldEmpty = false;
                                                  context.read<ForgetPasswordBloc>().add(const ForgetPasswordSetStateEvent());
                                                  context.read<ForgetPasswordBloc>().add(ForgetPasswordCallEvent(controller: loginController));
                                                }
                                              },
                                              text: getIt<Variables>().generalVariables.currentLanguage.sendOtp,
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                            Center(
                                              child: TextButton(
                                                  onPressed: () {
                                                    getIt<Variables>().generalVariables.indexName = getIt<Variables>().generalVariables.loginRouteList[getIt<Variables>().generalVariables.loginRouteList.length - 1];
                                                    context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                    getIt<Variables>().generalVariables.loginRouteList.removeAt(getIt<Variables>().generalVariables.loginRouteList.length - 1);
                                                  },
                                                  child: Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.goToBack,
                                                    style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                          ),
                          Positioned(
                            top: getIt<Functions>().getWidgetHeight(height: Orientation.portrait == MediaQuery.of(context).orientation ? 87 : 40),
                            child: SvgPicture.asset(
                              "assets/general/app_logo.svg",
                              height: getIt<Functions>().getWidgetHeight(height: 100),
                              width: getIt<Functions>().getWidgetWidth(width: 100),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                else {
                  return SingleChildScrollView(
                    child: AnimatedContainer(
                      height: isKeyPadOpen ? getIt<Variables>().generalVariables.height - (getIt<Functions>().getWidgetHeight(height: 210)) : getIt<Variables>().generalVariables.height,
                      width: Orientation.portrait == MediaQuery.of(context).orientation ? getIt<Variables>().generalVariables.width : getIt<Variables>().generalVariables.height,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/general/background.png"),
                        fit: BoxFit.fill,
                      )),
                      duration:const Duration(milliseconds: 350),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 350),
                                height: getIt<Functions>().getWidgetHeight(height: isKeyPadOpen ? 185 : 275),
                              ),
                              Expanded(
                                child: Center(
                                  child: GlassmorphicContainer(
                                    height: getIt<Functions>().getWidgetHeight(height: 425),
                                    width: getIt<Functions>().getWidgetWidth(width: 380),
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
                                      width: getIt<Functions>().getWidgetWidth(width: 380),
                                      padding: EdgeInsets.symmetric(
                                        vertical: getIt<Functions>().getWidgetHeight(height: 22),
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 22),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.forgotPass,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 22),
                                                color: const Color(0xffffffff),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                          Expanded(
                                            child: AutoSizeText(
                                              maxFontSize: getIt<Functions>().getTextSize(fontSize:14),
                                              minFontSize: getIt<Functions>().getTextSize(fontSize:6),
                                              softWrap: true,
                                              maxLines: 4,
                                              getIt<Variables>().generalVariables.currentLanguage.enterEmailIdText,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xfff9f9f9),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 32)),
                                          textBars(controller: loginController),
                                          isLoginFieldEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                          isLoginFieldEmpty
                                              ? Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.emptyLoginId,
                                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                )
                                              : const SizedBox(),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                          LoadingButton(
                                            height: getIt<Functions>().getWidgetHeight(height: 45),
                                            width: getIt<Functions>().getWidgetWidth(width: 414),
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                            status: loader,
                                            onTap: () {
                                              FocusManager.instance.primaryFocus!.unfocus();
                                              loader = true;
                                              context.read<ForgetPasswordBloc>().add(const ForgetPasswordSetStateEvent());
                                              if (loginController.text.isEmpty) {
                                                isLoginFieldEmpty = true;
                                                loader = false;
                                                context.read<ForgetPasswordBloc>().add(const ForgetPasswordSetStateEvent());
                                              } else {
                                                isLoginFieldEmpty = false;
                                                context.read<ForgetPasswordBloc>().add(const ForgetPasswordSetStateEvent());
                                                context.read<ForgetPasswordBloc>().add(ForgetPasswordCallEvent(controller: loginController));
                                              }
                                            },
                                            text: getIt<Variables>().generalVariables.currentLanguage.sendOtp,
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                          Center(
                                            child: TextButton(
                                                onPressed: () {
                                                  getIt<Variables>().generalVariables.indexName = getIt<Variables>().generalVariables.loginRouteList[getIt<Variables>().generalVariables.loginRouteList.length - 1];
                                                  context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                  getIt<Variables>().generalVariables.loginRouteList.removeAt(getIt<Variables>().generalVariables.loginRouteList.length - 1);
                                                },
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.goToBack,
                                                  style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 350),
                                height: getIt<Functions>().getWidgetHeight(height: isKeyPadOpen ? 25 : 108),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: getIt<Variables>().generalVariables.currentLanguage.poweredByEWF,
                                  style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xffffffff), fontWeight: FontWeight.w400),
                                  children: <TextSpan>[
                                    TextSpan(text: '', style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xffffffff), fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              AnimatedContainer(duration: const Duration(milliseconds: 350), height: getIt<Functions>().getWidgetHeight(height: isKeyPadOpen ? 8 : 48)),
                            ],
                          ),
                          Positioned(
                            top: getIt<Functions>().getWidgetHeight(height: 80),
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

  Widget textBars({required TextEditingController controller}) {
    return SizedBox(
      height: getIt<Functions>().getWidgetHeight(height: 71),
      width: getIt<Functions>().getWidgetWidth(width: 414),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getIt<Variables>().generalVariables.currentLanguage.logInId,
            style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xffffffff)),
          ),
          SizedBox(
            height: getIt<Functions>().getWidgetHeight(height: 45),
            child: TextFormField(
              controller: controller,
              cursorColor: const Color(0xffE0E6EE),
              keyboardType: TextInputType.text,
              style: TextStyle(
                fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                fontWeight: FontWeight.w500,
                color: const Color(0xffFFFFFF),
              ),
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
