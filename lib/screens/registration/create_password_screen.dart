// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glassmorphism/glassmorphism.dart';

// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/registration/create_password/create_password_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';
import 'package:oda/screens/registration/login_screen.dart';

class CreatePasswordScreen extends StatelessWidget {
  static const String id = "create_password_screen";

  const CreatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocProvider(
        create: (context) => CreatePasswordBloc(),
        child: BlocConsumer<CreatePasswordBloc, CreatePasswordState>(
          listenWhen: (CreatePasswordState previous, CreatePasswordState current) {
            return previous != current;
          },
          buildWhen: (CreatePasswordState previous, CreatePasswordState current) {
            return previous != current;
          },
          listener: (BuildContext context, CreatePasswordState state) {
            if (state is CreatePasswordSuccess) {
              context.read<CreatePasswordBloc>().loader = false;
              context.read<CreatePasswordBloc>().add(const CreatePasswordSetStateEvent());
              getIt<Variables>().generalVariables.indexName = LoginScreen.id;
              context.read<NavigationBloc>().add(const NavigationInitialEvent());
            }
            if (state is CreatePasswordFailure) {
              context.read<CreatePasswordBloc>().loader = false;
              context.read<CreatePasswordBloc>().add(const CreatePasswordSetStateEvent());
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (BuildContext context, CreatePasswordState state) {
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
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: Orientation.portrait == MediaQuery.of(context).orientation ? getIt<Variables>().generalVariables.height : getIt<Variables>().generalVariables.width),
                            width: getIt<Functions>().getWidgetWidth(width: Orientation.portrait == MediaQuery.of(context).orientation ? getIt<Variables>().generalVariables.width : getIt<Variables>().generalVariables.height),
                            child: Column(
                              children: [
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 100)),
                                Expanded(
                                  child: Center(
                                    child: GlassmorphicContainer(
                                      height: getIt<Functions>().getWidgetHeight(height: 590),
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
                                              getIt<Variables>().generalVariables.currentLanguage.createNewPass,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                color: const Color(0xffffffff),
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                            Text(
                                              getIt<Variables>().generalVariables.currentLanguage.createNewPassSub,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                color: const Color(0xfff9f9f9),
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 34)),
                                            textBars(controller: context.read<CreatePasswordBloc>().passwordController, isConfirm: false),
                                            context.read<CreatePasswordBloc>().isPasswordEmpty || context.read<CreatePasswordBloc>().isPasswordNotValid ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                            context.read<CreatePasswordBloc>().isPasswordEmpty
                                                ? Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.emptyOldPasswordField,
                                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                  )
                                                : context.read<CreatePasswordBloc>().isPasswordNotValid
                                                    ? Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.weekPassword,
                                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                      )
                                                    : const SizedBox(),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 25)),
                                            textBars(controller: context.read<CreatePasswordBloc>().confirmPasswordController, isConfirm: true),
                                            context.read<CreatePasswordBloc>().isPasswordNotMatched ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                            context.read<CreatePasswordBloc>().isPasswordNotMatched
                                                ? Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.passwordsDoNotMatch,
                                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                  )
                                                : const SizedBox(),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 35)),
                                            LoadingButton(
                                              height: getIt<Functions>().getWidgetHeight(height: 45),
                                              width: getIt<Functions>().getWidgetWidth(width: 414),
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                              status: context.read<CreatePasswordBloc>().loader,
                                              onTap: () {
                                                context.read<CreatePasswordBloc>().loader = true;
                                                context.read<CreatePasswordBloc>().add(const CreatePasswordSetStateEvent());
                                                if (context.read<CreatePasswordBloc>().passwordController.text.isEmpty) {
                                                  context.read<CreatePasswordBloc>().isPasswordEmpty = true;
                                                  context.read<CreatePasswordBloc>().isPasswordNotValid = false;
                                                  context.read<CreatePasswordBloc>().isPasswordNotMatched = false;
                                                  context.read<CreatePasswordBloc>().loader = false;
                                                  context.read<CreatePasswordBloc>().add(const CreatePasswordSetStateEvent());
                                                } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,40}$').hasMatch(context.read<CreatePasswordBloc>().passwordController.text)) {
                                                  context.read<CreatePasswordBloc>().isPasswordNotValid = true;
                                                  context.read<CreatePasswordBloc>().isPasswordEmpty = false;
                                                  context.read<CreatePasswordBloc>().isPasswordNotMatched = false;
                                                  context.read<CreatePasswordBloc>().loader = false;
                                                  context.read<CreatePasswordBloc>().add(const CreatePasswordSetStateEvent());
                                                } else if (context.read<CreatePasswordBloc>().passwordController.text != context.read<CreatePasswordBloc>().confirmPasswordController.text) {
                                                  context.read<CreatePasswordBloc>().isPasswordNotMatched = true;
                                                  context.read<CreatePasswordBloc>().isPasswordEmpty = false;
                                                  context.read<CreatePasswordBloc>().isPasswordNotValid = false;
                                                  context.read<CreatePasswordBloc>().loader = false;
                                                  context.read<CreatePasswordBloc>().add(const CreatePasswordSetStateEvent());
                                                } else {
                                                  context.read<CreatePasswordBloc>().isPasswordEmpty = false;
                                                  context.read<CreatePasswordBloc>().isPasswordNotValid = false;
                                                  context.read<CreatePasswordBloc>().isPasswordNotMatched = false;
                                                  context.read<CreatePasswordBloc>().add(const CreatePasswordSetStateEvent());
                                                  context.read<CreatePasswordBloc>().add(ResetPasswordEvent(controller: context.read<CreatePasswordBloc>().passwordController));
                                                }
                                              },
                                              text: getIt<Variables>().generalVariables.currentLanguage.continueText,
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 25)),
                                            Text("*${getIt<Variables>().generalVariables.currentLanguage.newPassErrorOne}",
                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 11), color: const Color(0xffffffff))),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                            Text("*${getIt<Variables>().generalVariables.currentLanguage.newPassErrorTwo}",
                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 11), color: const Color(0xffffffff))),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                            Text("*${getIt<Variables>().generalVariables.currentLanguage.newPassErrorThree}",
                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 11), color: const Color(0xffffffff))),
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
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 140)),
                              Expanded(
                                child: Center(
                                  child: GlassmorphicContainer(
                                    height: getIt<Functions>().getWidgetHeight(height: 610),
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
                                          AutoSizeText(
                                            maxFontSize: getIt<Functions>().getTextSize(fontSize:22),
                                            minFontSize: getIt<Functions>().getTextSize(fontSize:21),
                                            softWrap: true,
                                            maxLines: 2,
                                            getIt<Variables>().generalVariables.currentLanguage.createNewPass,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                          Flexible(
                                            child: AutoSizeText(
                                              maxFontSize: getIt<Functions>().getTextSize(fontSize:14),
                                              minFontSize: getIt<Functions>().getTextSize(fontSize:8),
                                              softWrap: true,
                                              maxLines: 2,
                                              getIt<Variables>().generalVariables.currentLanguage.createNewPassSub,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xfff9f9f9),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 34)),
                                          textBars(controller: context.read<CreatePasswordBloc>().passwordController, isConfirm: false),
                                          context.read<CreatePasswordBloc>().isPasswordEmpty || context.read<CreatePasswordBloc>().isPasswordNotValid ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                          context.read<CreatePasswordBloc>().isPasswordEmpty
                                              ? Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.emptyOldPasswordField,
                                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                )
                                              : context.read<CreatePasswordBloc>().isPasswordNotValid
                                                  ? Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.weekPassword,
                                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                    )
                                                  : const SizedBox(),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 25)),
                                          textBars(controller: context.read<CreatePasswordBloc>().confirmPasswordController, isConfirm: true),
                                          context.read<CreatePasswordBloc>().isPasswordNotMatched ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                          context.read<CreatePasswordBloc>().isPasswordNotMatched
                                              ? Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.passwordsDoNotMatch,
                                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: Colors.yellowAccent),
                                                )
                                              : const SizedBox(),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 35)),
                                          LoadingButton(
                                            height: getIt<Functions>().getWidgetHeight(height: 45),
                                            width: getIt<Functions>().getWidgetWidth(width: 414),
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                            status: context.read<CreatePasswordBloc>().loader,
                                            onTap: () {
                                              context.read<CreatePasswordBloc>().loader = true;
                                              context.read<CreatePasswordBloc>().add(const CreatePasswordSetStateEvent());
                                              if (context.read<CreatePasswordBloc>().passwordController.text.isEmpty) {
                                                context.read<CreatePasswordBloc>().isPasswordEmpty = true;
                                                context.read<CreatePasswordBloc>().isPasswordNotValid = false;
                                                context.read<CreatePasswordBloc>().isPasswordNotMatched = false;
                                                context.read<CreatePasswordBloc>().loader = false;
                                                context.read<CreatePasswordBloc>().add(const CreatePasswordSetStateEvent());
                                              } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,40}$').hasMatch(context.read<CreatePasswordBloc>().passwordController.text)) {
                                                context.read<CreatePasswordBloc>().isPasswordNotValid = true;
                                                context.read<CreatePasswordBloc>().isPasswordEmpty = false;
                                                context.read<CreatePasswordBloc>().isPasswordNotMatched = false;
                                                context.read<CreatePasswordBloc>().loader = false;
                                                context.read<CreatePasswordBloc>().add(const CreatePasswordSetStateEvent());
                                              } else if (context.read<CreatePasswordBloc>().passwordController.text != context.read<CreatePasswordBloc>().confirmPasswordController.text) {
                                                context.read<CreatePasswordBloc>().isPasswordNotMatched = true;
                                                context.read<CreatePasswordBloc>().isPasswordEmpty = false;
                                                context.read<CreatePasswordBloc>().isPasswordNotValid = false;
                                                context.read<CreatePasswordBloc>().loader = false;
                                                context.read<CreatePasswordBloc>().add(const CreatePasswordSetStateEvent());
                                              } else {
                                                context.read<CreatePasswordBloc>().isPasswordEmpty = false;
                                                context.read<CreatePasswordBloc>().isPasswordNotValid = false;
                                                context.read<CreatePasswordBloc>().isPasswordNotMatched = false;
                                                context.read<CreatePasswordBloc>().add(const CreatePasswordSetStateEvent());
                                                context.read<CreatePasswordBloc>().add(ResetPasswordEvent(controller: context.read<CreatePasswordBloc>().passwordController));
                                              }
                                            },
                                            text: getIt<Variables>().generalVariables.currentLanguage.continueText,
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 25)),
                                          AutoSizeText(
                                              maxFontSize: getIt<Functions>().getTextSize(fontSize:11),
                                              minFontSize: getIt<Functions>().getTextSize(fontSize:11),
                                              softWrap: true,
                                              maxLines: 2,
                                              "*${getIt<Variables>().generalVariables.currentLanguage.newPassErrorOne}",
                                              style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xffffffff))),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                          AutoSizeText(
                                              maxFontSize: getIt<Functions>().getTextSize(fontSize:11),
                                              minFontSize: getIt<Functions>().getTextSize(fontSize:11),
                                              softWrap: true,
                                              maxLines: 1,
                                              "*${getIt<Variables>().generalVariables.currentLanguage.newPassErrorTwo}",
                                              style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xffffffff))),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                          AutoSizeText(
                                              maxFontSize: getIt<Functions>().getTextSize(fontSize:11),
                                              minFontSize: getIt<Functions>().getTextSize(fontSize:11),
                                              softWrap: true,
                                              maxLines: 1,
                                              "*${getIt<Variables>().generalVariables.currentLanguage.newPassErrorThree}",
                                              style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xffffffff))),
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
      ),
    );
  }

  Widget textBars({required TextEditingController controller, required bool isConfirm}) {
    return BlocProvider(
      create: (context) => CreatePasswordBloc(),
      child: BlocBuilder<CreatePasswordBloc, CreatePasswordState>(
        builder: (BuildContext context, CreatePasswordState state) {
          return SizedBox(
            height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 75 : 70),
            width: getIt<Functions>().getWidgetWidth(width: 414),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConfirm ? getIt<Variables>().generalVariables.currentLanguage.confirmPassword : getIt<Variables>().generalVariables.currentLanguage.newPass,
                  style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xffffffff)),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 45),
                  child: TextFormField(
                    controller: controller,
                    cursorColor: const Color(0xffE0E6EE),
                    keyboardType: TextInputType.text,
                    obscureText: isConfirm ? context.read<CreatePasswordBloc>().isConfirmVisible : context.read<CreatePasswordBloc>().isVisible,
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (isConfirm) {
                            context.read<CreatePasswordBloc>().isConfirmVisible = !context.read<CreatePasswordBloc>().isConfirmVisible;
                          } else {
                            context.read<CreatePasswordBloc>().isVisible = !context.read<CreatePasswordBloc>().isVisible;
                          }
                          context.read<CreatePasswordBloc>().add(const CreatePasswordSetStateEvent());
                        },
                        icon: SvgPicture.asset(
                            isConfirm
                                ? context.read<CreatePasswordBloc>().isConfirmVisible
                                    ? "assets/general/eye.svg"
                                    : "assets/general/eye-slash.svg"
                                : context.read<CreatePasswordBloc>().isVisible
                                    ? "assets/general/eye.svg"
                                    : "assets/general/eye-slash.svg",
                            height: getIt<Functions>().getWidgetHeight(height: 20),
                            width: getIt<Functions>().getWidgetWidth(width: 20)),
                      ),
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
}
