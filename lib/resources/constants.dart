// ignore_for_file: unused_import

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// Flutter imports:
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Project imports:
import 'package:oda/edited_packages/device_details.dart';
import 'package:oda/firebase_options.dart';
import 'package:oda/local_database/language_box/language.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/rabbit_service.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';
import 'package:oda/screens/registration/splash_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

GetIt getIt = GetIt.instance;

Future<void> injectDependencies() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  HttpOverrides.global = MyHttpOverrides();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Directory? dir = await getExternalStorageDirectory();
  String hivePath = "${dir!.path}/hive_data/";
  await Directory(hivePath).create(recursive: true);
  await Hive.initFlutter(hivePath);
  Hive.registerAdapter(UserResponseAdapter());
  Hive.registerAdapter(HeadersLoggedDataAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(DatumAdapter());
  //Hive.registerAdapter(PickListMainDataAdapter());
  Hive.registerAdapter(FilterOptionsResponseAdapter());
  Hive.registerAdapter(RoomAdapter());
  Hive.registerAdapter(ZoneAdapter());
  Hive.registerAdapter(LanguageDataAdapter());
  Hive.registerAdapter(LanguageListModelAdapter());
  Hive.registerAdapter(TripListAdapter());
  Hive.registerAdapter(SoListAdapter());
  Hive.registerAdapter(ItemsListAdapter());
  Hive.registerAdapter(BatchesListAdapter());
  Hive.registerAdapter(HandledByForUpdateListAdapter());
  Hive.registerAdapter(SessionInfoAdapter());
  Hive.registerAdapter(UnavailableReasonAdapter());
  Hive.registerAdapter(PartialItemsListAdapter());
  Hive.registerAdapter(LocalTempDataListAdapter());
  Hive.registerAdapter(PickListMainResponseAdapter());
  Hive.registerAdapter(PicklistItemAdapter());
  Hive.registerAdapter(HandledByPickListAdapter());
  Hive.registerAdapter(PickListDetailsResponseAdapter());
  Hive.registerAdapter(PickListDetailsItemAdapter());
  Hive.registerAdapter(PickListBatchesListAdapter());
  Hive.registerAdapter(CatchWeightItemAdapter());
  Hive.registerAdapter(LocationDisputeInfoAdapter());
  Hive.registerAdapter(PickListSessionInfoAdapter());
  Hive.registerAdapter(TimelineInfoAdapter());
  Hive.registerAdapter(FilterAdapter());
  Hive.registerAdapter(FloorLocationAdapter());
  Hive.registerAdapter(StagingLocationAdapter());
  Hive.registerAdapter(LoadingLocationAdapter());
  Hive.registerAdapter(PartialPickListDetailsItemAdapter());
  Hive.registerAdapter(LocalTempDataPickListAdapter());
  Hive.registerAdapter(S3Adapter());
  Hive.registerAdapter(InvoiceDataAdapter());
  /*Hive.registerAdapter(PickListBoxDataAdapter());
  Hive.registerAdapter(LocationDisputeInfoAdapter());
  Hive.registerAdapter(PickedSessionInfoAdapter());*/
  getIt.registerSingleton(Variables());
  getIt.registerSingleton(Functions());
  getIt.registerSingleton(Widgets());
 // getIt.registerSingleton(RabbitMQService());
  getIt<Variables>().generalVariables.userBox = await Hive.openBox<UserResponse>('boxData');
  getIt<Variables>().generalVariables.languageBox = await Hive.openBox<LanguageData>('languageData');
 // await Hive.openBox<PickListMainData>('pick_list_main_data');
  await Hive.openBox<TripList>('trip_list');
  await Hive.openBox<SoList>('so_list');
  await Hive.openBox<ItemsList>('items_list');
  await Hive.openBox<BatchesList>('batches_list');
  await Hive.openBox<PartialItemsList>('partial_items_list');
  await Hive.openBox<LocalTempDataList>('local_temp_data_list');
  await Hive.openBox<LocalTempDataList>('local_temp_data_list_out_bound');
  await Hive.openBox<TripList>('trip_list_pickup');
  await Hive.openBox<SoList>('so_list_pickup');
  await Hive.openBox<ItemsList>('items_list_pickup');
  await Hive.openBox<BatchesList>('batches_list_pickup');
  await Hive.openBox<InvoiceData>('invoice_data_list_pickup');
 // await Hive.openBox<PartialItemsList>('partial_items_list_pickup');
  await Hive.openBox<LocalTempDataList>('local_temp_data_list_pickup');
 // await Hive.openBox<InvoiceData>('invoice_data_list_pickup');
  /*await Hive.openBox<PickListBoxData>('pick_list_box_data');
  await Hive.openBox<LocationDisputeInfo>('location_dispute_info');*/
  await Hive.openBox<PickListMainResponse>('pick_list_main_response');
  await Hive.openBox<PicklistItem>('pick_list_item');
  await Hive.openBox<HandledByPickList>('handled_by_pick_list');
  await Hive.openBox<PickListDetailsResponse>('pick_list_details_response');
  await Hive.openBox<PickListDetailsItem>('pick_list_details_item');
  await Hive.openBox<PickListBatchesList>('pick_list_batches_list');
  await Hive.openBox<CatchWeightItem>('catch_weight_item');
  await Hive.openBox<LocationDisputeInfo>('location_dispute_info');
  await Hive.openBox<PickListSessionInfo>('pick_list_session_info');
  await Hive.openBox<TimelineInfo>('time_line_info');
  await Hive.openBox<Filter>('filter');
  await Hive.openBox<FloorLocation>('floor_location');
  await Hive.openBox<StagingLocation>('staging_location');
  await Hive.openBox<LoadingLocation>('loading_location');
  await Hive.openBox<PartialPickListDetailsItem>('partial_pick_list_details_item');
  await Hive.openBox<LocalTempDataPickList>('local_temp_data_pick_list');
  await Hive.openBox<UnavailableReason>('unavailable_reason');
  await Hive.openBox<UnavailableReason>('complete_reason');

  await Hive.openBox('pick_list_main_data_list_local');
  await Hive.openBox('partial_pick_list_main_data_list_local');
  if (Device.get().isTablet) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  } else {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  await setupFlutterNotifications();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.requestPermission();
  RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    getIt<Variables>().generalVariables.backgroundMessage = message;
  }
  getIt<Variables>().generalVariables.indexName = SplashScreen.id;
  getIt<Variables>().generalVariables.packageVersion = packageInfo.version;
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> setupFlutterNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  DarwinInitializationSettings initializationSettingsDarwin = const DarwinInitializationSettings(
    requestAlertPermission: false,
    requestSoundPermission: false,
    requestBadgePermission: true,
  );
  InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "ODA_1234",
    'ODA_EWF',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails("ODA_1234", 'ODA_EWF', importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    NotificationDetails platformChannelSpecifics = const NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(notification.hashCode, notification.title, notification.body, platformChannelSpecifics, payload: "");
  } else {
    DarwinNotificationDetails iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(iOS: iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(notification.hashCode, notification!.title, notification.body, platformChannelSpecifics, payload: "");
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
