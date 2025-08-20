// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/registration/splash/splash_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/screens/registration/login_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String id = "splash_screen";

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(const SplashInitialEvent()),
      child: BlocConsumer<SplashBloc, SplashState>(
        listenWhen: (SplashState previous, SplashState current) {
          return previous != current;
        },
        buildWhen: (SplashState previous, SplashState current) {
          return previous != current;
        },
        listener: (BuildContext context, SplashState splash) {
          if (splash is SplashFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(splash.message)));
          }
          if (splash is SplashSuccess) {
            if (getIt<Variables>().generalVariables.isLoggedIn && getIt<Variables>().generalVariables.isNetworkOffline) {
              Future.delayed(const Duration(seconds: 1), () {
                getIt<Variables>().generalVariables.isConfirmLoggedIn = true;
                context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 0));
                context.read<NavigationBloc>().add(const NavigationInitialEvent());
              });
            } else if (getIt<Variables>().generalVariables.isLoggedIn && !getIt<Variables>().generalVariables.isNetworkOffline) {
              getIt<Variables>().generalVariables.isConfirmLoggedIn = true;
              context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 0));
              context.read<NavigationBloc>().add(const NavigationInitialEvent());
            } else {
              getIt<Variables>().generalVariables.indexName = LoginScreen.id;
              context.read<NavigationBloc>().add(const NavigationInitialEvent());
            }
          }
        },
        builder: (BuildContext context, SplashState splash) {
          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/general/background.png"),
              fit: BoxFit.fill,
            )),
            child: Center(
              child: SvgPicture.asset("assets/general/app_logo.svg"),
            ),
          );
        },
      ),
    );
  }
}
