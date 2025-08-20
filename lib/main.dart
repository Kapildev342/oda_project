// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/my_app.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/env.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnvironment.setupEnv(Environment.prod);
  await injectDependencies();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(BlocProvider(
      create: (context) => NavigationBloc()..add(const NavigationInitialEvent())..add(const ListenConnectivity()),
      child: const MyApp()));
}
