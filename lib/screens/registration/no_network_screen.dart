// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/svg.dart';

// Project imports:
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: SizedBox(
        width: Orientation.portrait == MediaQuery.of(context).orientation ? getIt<Variables>().generalVariables.width : getIt<Variables>().generalVariables.height,
        child: Stack(
          children: [
            Positioned(right: 0, child: SvgPicture.asset("assets/general/force_update_bg_one.svg")),
            Positioned(right: 0, bottom: 0, child: SvgPicture.asset("assets/general/force_update_bg_two.svg")),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 61), width: getIt<Functions>().getWidgetWidth(width: 61), child: Image.asset("assets/general/app_logo.svg")),
                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 100),
                      width: getIt<Functions>().getWidgetWidth(width: 293),
                      child: Text(
                         "Oops! No Internet Connection",
                        softWrap: true,
                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 36), fontWeight: FontWeight.w700, color: const Color(0xFF1A202C)),
                      ),
                    ),
                  ),
                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                  SizedBox(
                    width: getIt<Functions>().getWidgetWidth(width: 322),
                    height: getIt<Functions>().getWidgetHeight(height: 75),
                    child: Text(
                    "Please check your internet connection",
                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xFF303030), fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
