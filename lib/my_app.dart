// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:oda/bloc/back_to_store/add_back_to_store/add_back_to_store_bloc.dart';
import 'package:oda/bloc/back_to_store/back_to_store/back_to_store_bloc.dart';
import 'package:oda/bloc/catch_weight/catch_weight_bloc.dart';
import 'package:oda/bloc/dispute/dispute_main/dispute_main_bloc.dart';
import 'package:oda/bloc/home/home_bloc/home_bloc.dart';
import 'package:oda/bloc/home/notification/notification_bloc.dart';
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/out_bound/out_bound_detail/out_bound_detail_bloc.dart';
import 'package:oda/bloc/out_bound/out_bound_entry/out_bound_entry_bloc.dart';
import 'package:oda/bloc/out_bound/out_bound_main/out_bound_bloc.dart';
import 'package:oda/bloc/pick_list/pick_list/pick_list_bloc.dart';
import 'package:oda/bloc/pick_list/pick_list_details/pick_list_details_bloc.dart';
import 'package:oda/bloc/ro_trip_list/ro_trip_list_detail/ro_trip_list_detail_bloc.dart';
import 'package:oda/bloc/ro_trip_list/ro_trip_list_main/ro_trip_list_main_bloc.dart';
import 'package:oda/bloc/settings/settings_bloc.dart';
import 'package:oda/bloc/task/add_task_bloc/add_task_bloc.dart';
import 'package:oda/bloc/task/task_bloc/task_bloc.dart';
import 'package:oda/bloc/task/view_task_bloc/view_task_bloc.dart';
import 'package:oda/bloc/timer/timer_bloc.dart';
import 'package:oda/bloc/trip_list/trip_list_detail/trip_list_detail_bloc.dart';
import 'package:oda/bloc/trip_list/trip_list_entry/trip_list_entry_bloc.dart';
import 'package:oda/bloc/trip_list/trip_list_main/trip_list_bloc.dart';
import 'package:oda/bloc/warehouse_pickup/warehouse_pickup_detail/warehouse_pickup_detail_bloc.dart';
import 'package:oda/bloc/warehouse_pickup/warehouse_pickup_main/warehouse_pickup_bloc.dart';
import 'package:oda/bloc/warehouse_pickup/warehouse_pickup_summary/warehouse_pickup_summary_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/env.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showFlutterNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      showFlutterNotification(message);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Orientation.portrait == MediaQuery.of(context).orientation) {
      getIt<Variables>().generalVariables.height = MediaQuery.of(context).size.height;
      getIt<Variables>().generalVariables.width = MediaQuery.of(context).size.width;
      getIt<Variables>().generalVariables.text = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.0);
    } else {
      getIt<Variables>().generalVariables.height = MediaQuery.of(context).size.width;
      getIt<Variables>().generalVariables.width = MediaQuery.of(context).size.height;
      getIt<Variables>().generalVariables.text = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.0);
    }
    getIt<Variables>().generalVariables.isDeviceTablet = (Orientation.portrait == MediaQuery.of(context).orientation ? getIt<Variables>().generalVariables.width : getIt<Variables>().generalVariables.height) > 480;
    return MediaQuery(
      data: MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: MultiBlocProvider(
        providers: [
          //BlocProvider(create: (context) => NavigationBloc()..add(const NavigationInitialEvent())),
          BlocProvider(create: (context) => HomeBloc()),
          BlocProvider(create: (context) => CatchWeightBloc()),
          BlocProvider(create: (context) => PickListBloc()),
          BlocProvider(create: (context) => PickListDetailsBloc()),
          BlocProvider(create: (context) => BackToStoreBloc()),
          BlocProvider(create: (context) => AddBackToStoreBloc()),
          BlocProvider(create: (context) => DisputeMainBloc()),
          BlocProvider(create: (context) => TripListBloc()),
          BlocProvider(create: (context) => TripListEntryBloc()),
          BlocProvider(create: (context) => TripListDetailsBloc()),
          BlocProvider(create: (context) => OutBoundBloc()),
          BlocProvider(create: (context) => OutBoundEntryBloc()),
          BlocProvider(create: (context) => OutBoundDetailBloc()),
          BlocProvider(create: (context) => WarehousePickupBloc()),
          BlocProvider(create: (context) => WarehousePickupDetailBloc()),
          BlocProvider(create: (context) => WarehousePickupSummaryBloc()),
          BlocProvider(create: (context) => NotificationBloc()),
          BlocProvider(create: (context) => SettingsBloc()),
          BlocProvider(create: (context) => TimerBloc()),
          BlocProvider(create: (context) => RoTripListMainBloc()),
          BlocProvider(create: (context) => RoTripListDetailBloc()),
          BlocProvider(create: (context) => TaskBloc()),
          BlocProvider(create: (context) => AddTaskBloc()),
          BlocProvider(create: (context) => ViewTaskBloc()),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: scaffoldKey,
          navigatorKey: navigatorKey,
          title: AppEnvironment.title,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true, fontFamily: "Figtree"),
          home: BlocConsumer<NavigationBloc, NavigationState>(
            listenWhen: (previous, current) {
              return previous != current;
            },
            buildWhen: (previous, current) {
              return previous != current;
            },
            listener: (BuildContext context, NavigationState navigation) {
              if (navigation is NavigationConfirm) {
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[0].name = getIt<Variables>().generalVariables.currentLanguage.home;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[1].name = getIt<Variables>().generalVariables.currentLanguage.picklist;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[2].name = getIt<Variables>().generalVariables.currentLanguage.catchWeight;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[3].name = getIt<Variables>().generalVariables.currentLanguage.bts;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[4].name = getIt<Variables>().generalVariables.currentLanguage.dispute;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[5].name = getIt<Variables>().generalVariables.currentLanguage.settings;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[6].name = getIt<Variables>().generalVariables.currentLanguage.tripList;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[7].name = getIt<Variables>().generalVariables.currentLanguage.outBound;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[8].name = getIt<Variables>().generalVariables.currentLanguage.wareHouseList;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[9].name = getIt<Variables>().generalVariables.currentLanguage.roTripList;
                context.read<HomeBloc>().add(const HomeSetStateEvent(stillLoading: true));
                context.read<NotificationBloc>().add(const NotificationSetStateEvent(stillLoading: true));
                context.read<PickListBloc>().add(const PickListSetStateEvent(stillLoading: true));
                context.read<PickListDetailsBloc>().add(const PickListDetailsSetStateEvent(stillLoading: true));
                context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent(stillLoading: true));
                context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent(stillLoading: true));
                context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent(stillLoading: true));
                context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent(stillLoading: true));
                context.read<SettingsBloc>().add(const SettingsSetStateEvent(stillLoading: true));
                context.read<TaskBloc>().add(const TaskSetStateEvent(stillLoading: true));
                context.read<AddTaskBloc>().add(const AddTaskSetStateEvent(stillLoading: true));
                context.read<ViewTaskBloc>().add(const ViewTaskSetStateEvent(stillLoading: true));

                context.read<OutBoundBloc>().add(const OutBoundSetStateEvent(stillLoading: true));
                context.read<OutBoundEntryBloc>().add(const OutBoundEntrySetStateEvent(stillLoading: true));
                context.read<OutBoundDetailBloc>().add(const OutBoundDetailSetStateEvent(stillLoading: true));

                context.read<TripListBloc>().add(const TripListSetStateEvent(stillLoading: true));
                context.read<TripListEntryBloc>().add(const TripListEntrySetStateEvent(stillLoading: true));
                context.read<TripListDetailsBloc>().add(const TripListDetailsSetStateEvent(stillLoading: true));

                context.read<WarehousePickupBloc>().add(const WarehousePickupSetStateEvent(stillLoading: true));
                context.read<WarehousePickupSummaryBloc>().add(const WarehousePickupSummarySetStateEvent(stillLoading: true));
                context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent(stillLoading: true));

                context.read<RoTripListMainBloc>().add(const RoTripListMainSetStateEvent(stillLoading: true));
                context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent(stillLoading: true));

                FocusManager.instance.primaryFocus!.unfocus();
              }
            },
            builder: (BuildContext context, NavigationState navigation) {
              if (navigation is NavigationLoaded) {
                return getIt<Widgets>().primaryContainerWidget(body: getIt<Variables>().generalVariables.mainWidget, context: context);
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
