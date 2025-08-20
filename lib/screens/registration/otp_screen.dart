// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/registration/otp/otp_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';
import 'package:oda/screens/registration/create_password_screen.dart';

class OtpScreen extends StatefulWidget {
  static const String id = "otp_screen";
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool canResend = false;
  int timerValue = 30;
  TextEditingController otpController = TextEditingController();
  Timer? timer;
  bool loader = false;
  bool isOtpFieldEmpty = false;

  @override
  void initState() {
    timerFunction();
    super.initState();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void timerFunction() {
    timer = Timer.periodic(const Duration(seconds: 1), (value) {
      if (timerValue != 0) {
        timerValue--;
        canResend = false;
        setState(() {});
      } else {
        timer!.cancel();
        timerValue = 30;
        canResend = true;
        setState(() {});
      }
    });
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
          create: (context) => OtpBloc(),
          child: BlocConsumer<OtpBloc, OtpState>(
            listenWhen: (OtpState previous, OtpState current) {
              return previous != current;
            },
            buildWhen: (OtpState previous, OtpState current) {
              return previous != current;
            },
            listener: (BuildContext context, OtpState state) {
              if (state is OtpSuccess) {
                loader = false;
                context.read<OtpBloc>().add(const OtpSetStateEvent());
                if (timer != null) {
                  timer!.cancel();
                }
                getIt<Variables>().generalVariables.indexName = CreatePasswordScreen.id;
                getIt<Variables>().generalVariables.loginRouteList.add(OtpScreen.id);
                context.read<NavigationBloc>().add(const NavigationInitialEvent());
              }
              if (state is OtpFailure) {
                loader = false;
                context.read<OtpBloc>().add(const OtpSetStateEvent());
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (BuildContext context, OtpState state) {
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
                                        height: getIt<Functions>().getWidgetHeight(height: 465),
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
                                              Text(
                                                getIt<Variables>().generalVariables.currentLanguage.otpVerification,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                  color: const Color(0xffffffff),
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                              Text(
                                                getIt<Variables>().generalVariables.currentLanguage.otpVerificationSubtext,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  color: const Color(0xfff9f9f9),
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 32)),
                                              otpFieldBar(controller: otpController),
                                              isOtpFieldEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                              isOtpFieldEmpty
                                                  ? Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.enterValidOtp,
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
                                                  loader = true;
                                                  context.read<OtpBloc>().add(const OtpSetStateEvent());
                                                  if (otpController.text.isEmpty || otpController.text.length < 4) {
                                                    isOtpFieldEmpty = true;
                                                    loader = false;
                                                    context.read<OtpBloc>().add(const OtpSetStateEvent());
                                                  } else {
                                                    isOtpFieldEmpty = false;
                                                    context.read<OtpBloc>().add(const OtpSetStateEvent());
                                                    context.read<OtpBloc>().add(OtpValidateEvent(controller: otpController));
                                                  }
                                                },
                                                text: getIt<Variables>().generalVariables.currentLanguage.submitOtp,
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                              Center(
                                                child: TextButton(
                                                  onPressed: canResend
                                                      ? () {
                                                          otpController.clear();
                                                          context.read<OtpBloc>().add(const OtpSetStateEvent());
                                                          context.read<OtpBloc>().add(const OtpResendEvent());
                                                          timerFunction();
                                                        }
                                                      : () {},
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: '${getIt<Variables>().generalVariables.currentLanguage.resendOtp} ',
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: canResend ? const Color(0xffffffff) : const Color(0xffffffff).withOpacity(0.5), fontWeight: FontWeight.w500),
                                                      children: <TextSpan>[
                                                        TextSpan(text: canResend ? "" : ' in ', style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xffffffff).withOpacity(0.5), fontWeight: FontWeight.w600)),
                                                        TextSpan(text: canResend ? "" : ' $timerValue Seconds', style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff07EE10), fontWeight: FontWeight.w600)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
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
                            Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: GlassmorphicContainer(
                                      height: getIt<Functions>().getWidgetHeight(height: 482),
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
                                            Text(
                                              getIt<Variables>().generalVariables.currentLanguage.otpVerification,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 22),
                                                color: const Color(0xffffffff),
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                            Flexible(
                                              child: AutoSizeText(
                                                maxFontSize: getIt<Functions>().getTextSize(fontSize:14),
                                                minFontSize: getIt<Functions>().getTextSize(fontSize:8),
                                                softWrap: true,
                                                getIt<Variables>().generalVariables.currentLanguage.otpVerificationSubtext,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  color: const Color(0xfff9f9f9),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 32)),
                                            otpFieldBar(controller: otpController),
                                            isOtpFieldEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                            isOtpFieldEmpty
                                                ? Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.enterValidOtp,
                                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                  )
                                                : const SizedBox(),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 32)),
                                            LoadingButton(
                                              height: getIt<Functions>().getWidgetHeight(height: 45),
                                              width: getIt<Functions>().getWidgetWidth(width: 414),
                                              fontSize: 14,
                                              status: loader,
                                              onTap: () {
                                                loader = true;
                                                context.read<OtpBloc>().add(const OtpSetStateEvent());
                                                if (otpController.text.isEmpty || otpController.text.length < 4) {
                                                  isOtpFieldEmpty = true;
                                                  loader = false;
                                                  context.read<OtpBloc>().add(const OtpSetStateEvent());
                                                } else {
                                                  isOtpFieldEmpty = false;
                                                  context.read<OtpBloc>().add(const OtpSetStateEvent());
                                                  context.read<OtpBloc>().add(OtpValidateEvent(controller: otpController));
                                                }
                                              },
                                              text: getIt<Variables>().generalVariables.currentLanguage.submitOtp,
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                            Center(
                                              child: TextButton(
                                                onPressed: canResend
                                                    ? () {
                                                        otpController.clear();
                                                        context.read<OtpBloc>().add(const OtpSetStateEvent());
                                                        context.read<OtpBloc>().add(const OtpResendEvent());
                                                        timerFunction();
                                                      }
                                                    : () {},
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: '${getIt<Variables>().generalVariables.currentLanguage.resendOtp} ',
                                                    style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: canResend ? const Color(0xffffffff) : const Color(0xffffffff).withOpacity(0.5), fontWeight: FontWeight.w500),
                                                    children: <TextSpan>[
                                                      TextSpan(text: canResend ? "" : ' in ', style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xffffffff).withOpacity(0.5), fontWeight: FontWeight.w600)),
                                                      TextSpan(text: canResend ? "" : ' $timerValue Seconds', style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff07EE10), fontWeight: FontWeight.w600)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
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
        ));
  }

  Widget otpFieldBar({required TextEditingController controller}) {
    return SizedBox(
      height: getIt<Functions>().getWidgetHeight(height: 70),
      width: getIt<Functions>().getWidgetWidth(width: 260),
      child: Center(
        child: PinCodeTextField(
          length: 4,
          appContext: context,
          controller: controller,
          keyboardType: TextInputType.number,
          enableActiveFill: true,
          cursorColor: const Color(0xffffffff),
          autoDisposeControllers: false,
          onChanged: (code) {},
          textStyle: const TextStyle(color: Colors.white),
          pinTheme: PinTheme(
              inactiveColor: const Color(0xFFE0E6EE),
              activeColor: const Color(0xFFE0E6EE),
              selectedColor: const Color(0xFFE0E6EE),
              inactiveFillColor: const Color(0xFFE0E6EE).withOpacity(0.12),
              activeFillColor: const Color(0xFFE0E6EE).withOpacity(0.12),
              selectedFillColor: const Color(0xFFE0E6EE).withOpacity(0.12),
              inactiveBorderWidth: 1.5,
              selectedBorderWidth: 1.5,
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(10.0),
              fieldHeight: getIt<Functions>().getWidgetHeight(height: 50),
              fieldWidth: getIt<Functions>().getWidgetWidth(width: 50),
              borderWidth: 1.5),
        ),
      ),
    );
  }
}
