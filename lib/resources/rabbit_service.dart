// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

// Project imports:
import 'package:oda/bloc/back_to_store/back_to_store/back_to_store_bloc.dart';
import 'package:oda/bloc/dispute/dispute_main/dispute_main_bloc.dart';
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/pick_list/pick_list/pick_list_bloc.dart';
import 'package:oda/bloc/pick_list/pick_list_details/pick_list_details_bloc.dart';
import 'package:oda/my_app.dart';
import 'package:oda/repository_model/general/socket_message_response_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';
import 'functions.dart';

class RabbitMQService {
  late Client client;
  late Channel channel;
  late Queue queue;
  late Exchange exchange;
  String user = 'TeamEWF';
  String pass = 'teamewf2024';
  String host = "192.168.1.251";
  String exc = "tst1";
  int port = 5672;

  /// Connect to RabbitMQ
  Future<void> connect() async {
    client = Client(
      settings: ConnectionSettings(
        host: host, // Replace with your RabbitMQ host
        authProvider: PlainAuthenticator(user, pass), // Replace with your username and password
        virtualHost: "/", // Replace with your RabbitMQ virtual host
      ),
    );
    channel = await client.channel();
    exchange = await channel.exchange("outbound", ExchangeType.FANOUT, durable: true);
    queue = await channel.queue(getIt<Variables>().generalVariables.userData.userProfile.id, exclusive: true); // Temporary queue with a unique name
    await queue.bind(exchange, "");
  }

  /// Listen to messages from the queue
  void listenToMessages(void Function(String message) onMessageReceived) {
    queue.consume().then((consumer) {
      consumer.listen((AmqpMessage message) {
        socketReceiveFunction(message: message);
      });
    });
  }

  /// Send a message to the queue
  Future<void> sendMessage(Map<String, dynamic> message) async {
    exchange.publish(message, "");
  }

  /// Close the RabbitMQ connection
  Future<void> close() async {
    await client.close();
  }

  socketReceiveFunction({required AmqpMessage message}) {
    Map messageData = message.payloadAsJson;
    debugPrint("messageData : $messageData");
    //event
    if (messageData["event"] == "alert") {
      //module
      if (messageData["module"] == "picklist") {
        //activity
        if (messageData["activity"] == "New Picklist") {
          SocketPickListMessageResponse response = SocketPickListMessageResponse.fromJson(message.payloadAsJson as Map<String, dynamic>);
          getIt<Variables>().generalVariables.socketMessageId = response.body.picklistId;
          getIt<Variables>().generalVariables.popUpWidget = pickListAlertContent(socketMessage: response);
          getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
        }
      }
      if (messageData["module"] == "dispute") {
        //activity
        if (messageData["activity"] == "Raised") {
          SocketDisputeResponse response = SocketDisputeResponse.fromJson(message.payloadAsJson as Map<String, dynamic>);
          getIt<Variables>().generalVariables.socketMessageId = response.body.disputeId.toString();
          Future.delayed(const Duration(seconds: 2), () {
            getIt<Variables>().generalVariables.popUpWidget = disputeAlertContent(socketMessage: response);
            getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
          });
        }
      }
      if (messageData["module"] == "bts") {
        //activity
        if (messageData["activity"] == "New Alert") {
          SocketBtsResponse response = SocketBtsResponse.fromJson(message.payloadAsJson as Map<String, dynamic>);
          getIt<Variables>().generalVariables.socketMessageId = response.body.btsId.toString();
          Future.delayed(const Duration(seconds: 2), () {
            getIt<Variables>().generalVariables.popUpWidget = btsAlertContent(socketMessage: response);
            getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
          });
        }
      }
      PickListDetailsBloc().getStringFromCatchWeightList(data: []);
    }


   /* if (messageData["event"] == "refresh") {
      //module
      if (messageData["module"] == "trip") {
        //activity
        if (messageData["activity"] == "Trip Updated") {
          SocketPickListMessageResponse response = SocketPickListMessageResponse.fromJson(message.payloadAsJson as Map<String, dynamic>);
          getIt<Variables>().generalVariables.socketMessageId = response.body.picklistId;
          getIt<Variables>().generalVariables.popUpWidget = pickListAlertContent(socketMessage: response);
          getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
        }
      }
      if (messageData["module"] == "dispute") {
        //activity
        if (messageData["activity"] == "Raised") {
          SocketDisputeResponse response = SocketDisputeResponse.fromJson(message.payloadAsJson as Map<String, dynamic>);
          getIt<Variables>().generalVariables.socketMessageId = response.body.disputeId.toString();
          Future.delayed(const Duration(seconds: 2), () {
            getIt<Variables>().generalVariables.popUpWidget = disputeAlertContent(socketMessage: response);
            getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
          });
        }
      }
      if (messageData["module"] == "bts") {
        //activity
        if (messageData["activity"] == "New Alert") {
          SocketBtsResponse response = SocketBtsResponse.fromJson(message.payloadAsJson as Map<String, dynamic>);
          getIt<Variables>().generalVariables.socketMessageId = response.body.btsId.toString();
          Future.delayed(const Duration(seconds: 2), () {
            getIt<Variables>().generalVariables.popUpWidget = btsAlertContent(socketMessage: response);
            getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
          });
        }
      }
    }*/
    /*if(response.actorId != getIt<Variables>().generalVariables.userData.userProfile.id){
      if(response.event =="refresh"){
        switch (messageData["module"]) {
          case "picklist":
            {
              if(getIt<Variables>().generalVariables.userData.userProfile.employeeType == "store_keeper"){
              scaffoldKey.currentContext!.read<PickListDetailsBloc>().add(PickListDetailsRefreshEvent(socketMessage: response));
              }
            }
          case "bts":
            {
              scaffoldKey.currentContext!.read<BackToStoreBloc>().add(BackToStoreRefreshEvent(socketMessage: response));
            }
          case "catchweight":
            {
              if(getIt<Variables>().generalVariables.userData.userProfile.employeeType == "store_keeper"){
              scaffoldKey.currentContext!.read<CatchWeightBloc>().add(CatchWeightRefreshEvent(socketMessage: response));
              }
            }
          default:
            {}
        }
      }
      else if(response.event =="alert"){
        switch (messageData["module"]) {
          case "picklist":
            {
                getIt<Variables>().generalVariables.popUpWidget = btsAlertContent(socketMessage: response);
                getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
            }
          case "bts":
            {
                getIt<Variables>().generalVariables.popUpWidget = btsAlertContent(socketMessage: response);
                getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
            }
          case "dispute":
            {
              getIt<Variables>().generalVariables.popUpWidget = btsAlertContent(socketMessage: response);
              getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
            }
          case "catchweight":
            {
              if(getIt<Variables>().generalVariables.userData.userProfile.employeeType == "store_keeper"){
                getIt<Variables>().generalVariables.popUpWidget = btsAlertContent(socketMessage: response);
                getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
              }
            }
          case "sorter_triplist":
            {
              if(getIt<Variables>().generalVariables.userData.userProfile.employeeType == "store_keeper"){
                getIt<Variables>().generalVariables.popUpWidget = btsAlertContent(socketMessage: response);
                getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
              }
            }
          case "loader_triplist":
            {
              if(getIt<Variables>().generalVariables.userData.userProfile.employeeType == "store_keeper"){
                getIt<Variables>().generalVariables.popUpWidget = btsAlertContent(socketMessage: response);
                getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
              }
            }
          case "loader_pickup":
            {
              if(getIt<Variables>().generalVariables.userData.userProfile.employeeType == "store_keeper"){
                getIt<Variables>().generalVariables.popUpWidget = btsAlertContent(socketMessage: response);
                getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
              }
            }
          case "ro_trip":
            {
              if(getIt<Variables>().generalVariables.userData.userProfile.employeeType == "store_keeper"){
                getIt<Variables>().generalVariables.popUpWidget = btsAlertContent(socketMessage: response);
                getIt<Functions>().showAnimatedDialog(context: navigatorKey.currentContext!, isFromTop: false, isCloseDisabled: false);
              }
            }
          default:
            {}
        }
      }
    }*/
  }

  Widget pickListAlertContent({required SocketPickListMessageResponse socketMessage}) {
    return BlocConsumer<PickListBloc, PickListState>(
      listenWhen: (PickListState previous, PickListState current) {
        return previous != current;
      },
      buildWhen: (PickListState previous, PickListState current) {
        return previous != current;
      },
      listener: (BuildContext context, PickListState state) {
        if (state is PickListError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (BuildContext context, PickListState state) {
        return SizedBox(
          height: getIt<Functions>().getWidgetHeight(height: 400),
          width: getIt<Functions>().getWidgetWidth(width: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/catch_weight/alert_clock.svg",
                height: getIt<Functions>().getWidgetHeight(height: 47),
                width: getIt<Functions>().getWidgetWidth(width: 47),
                fit: BoxFit.fill,
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
              Text(
                getIt<Variables>().generalVariables.currentLanguage.pickListAlert,
                style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0xff282F3A), fontSize: getIt<Functions>().getTextSize(fontSize: 20)),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                    height: getIt<Functions>().getWidgetHeight(height: 1),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffFFFFFF),
                        Color(0xffBBC6CD),
                      ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    ),
                  )),
                  Container(
                    height: getIt<Functions>().getWidgetHeight(height: 68),
                    width: getIt<Functions>().getWidgetWidth(width: 240),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xffBBC6CD), width: 0.5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          socketMessage.body.totalItems,
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 28), fontWeight: FontWeight.w600, color: const Color(0xff007838)),
                        ),
                        Text(
                          getIt<Variables>().generalVariables.currentLanguage.totalItems,
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: getIt<Functions>().getWidgetHeight(height: 1),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffBBC6CD),
                        Color(0xffFFFFFF),
                      ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    ),
                  )),
                ],
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: 105),
                width: getIt<Functions>().getWidgetWidth(width: 465),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${getIt<Variables>().generalVariables.currentLanguage.picklist} #${socketMessage.body.picklistNum}",
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 18 : 16),
                          color: const Color(0xff282F3A),
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${getIt<Variables>().generalVariables.currentLanguage.createdBy} : ${socketMessage.body.createdBy}",
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 12),
                          color: const Color(0xff282F3A),
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${getIt<Variables>().generalVariables.currentLanguage.created} : ${socketMessage.body.createdTime}",
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 12),
                              color: const Color(0xff282F3A),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 38)),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xffE0E7EC),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.ignoreNow.toUpperCase(),
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        Navigator.pop(context);
                        if (getIt<Variables>().generalVariables.selectedIndex == 1) {
                          context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 1));
                          context.read<NavigationBloc>().add(const NavigationInitialEvent());
                        } else {
                          if (getIt<Variables>().generalVariables.indexName !=
                              getIt<Variables>().generalVariables.currentUserBottomNavigationList[1].navigateTo) {
                            context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 1));
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                          }
                        }
                        Future.delayed(const Duration(seconds: 10), () {
                          getIt<Variables>().generalVariables.socketMessageId = "";
                        });
                      },
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xff007838),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.attend.toUpperCase(),
                            style: TextStyle(
                                color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget disputeAlertContent({required SocketDisputeResponse socketMessage}) {
    return BlocConsumer<DisputeMainBloc, DisputeMainState>(
      listenWhen: (DisputeMainState previous, DisputeMainState current) {
        return previous != current;
      },
      buildWhen: (DisputeMainState previous, DisputeMainState current) {
        return previous != current;
      },
      listener: (BuildContext context, DisputeMainState state) {
        if (state is DisputeMainError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (BuildContext context, DisputeMainState state) {
        return SizedBox(
          height: getIt<Functions>().getWidgetHeight(height: 400),
          width: getIt<Functions>().getWidgetWidth(width: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/catch_weight/alert_clock.svg",
                height: getIt<Functions>().getWidgetHeight(height: 47),
                width: getIt<Functions>().getWidgetWidth(width: 47),
                fit: BoxFit.fill,
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
              Text(
                getIt<Variables>().generalVariables.currentLanguage.disputeAlert,
                style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0xff282F3A), fontSize: getIt<Functions>().getTextSize(fontSize: 20)),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                    height: getIt<Functions>().getWidgetHeight(height: 1),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffFFFFFF),
                        Color(0xffBBC6CD),
                      ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    ),
                  )),
                  Container(
                    height: getIt<Functions>().getWidgetHeight(height: 68),
                    width: getIt<Functions>().getWidgetWidth(width: 240),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xffBBC6CD), width: 0.5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          socketMessage.body.disputeInfo.disputeQty,
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 28), fontWeight: FontWeight.w600, color: const Color(0xff007838)),
                        ),
                        Text(
                          getIt<Variables>().generalVariables.currentLanguage.requiredQty,
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: getIt<Functions>().getWidgetHeight(height: 1),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffBBC6CD),
                        Color(0xffFFFFFF),
                      ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    ),
                  )),
                ],
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: 105),
                width: getIt<Functions>().getWidgetWidth(width: 465),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${getIt<Variables>().generalVariables.currentLanguage.dispute} #${socketMessage.body.disputeInfo.disputeNum}",
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 18 : 16),
                          color: const Color(0xff282F3A),
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${getIt<Variables>().generalVariables.currentLanguage.createdBy} : ${socketMessage.body.disputeInfo.reporterType}",
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 12),
                          color: const Color(0xff282F3A),
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${getIt<Variables>().generalVariables.currentLanguage.created} : ${socketMessage.body.disputeInfo.dt}",
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 12),
                              color: const Color(0xff282F3A),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "  |  ",
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 12),
                              color: const Color(0xff282F3A),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${getIt<Variables>().generalVariables.currentLanguage.reason} : ${socketMessage.body.disputeInfo.unavailableReasonName}",
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 12),
                              color: const Color(0xff282F3A),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 38)),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xffE0E7EC),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.ignoreNow.toUpperCase(),
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        Navigator.pop(context);
                        if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "store_keeper" ||
                            getIt<Variables>().generalVariables.userData.userProfile.employeeType == "loader") {
                          if (getIt<Variables>().generalVariables.selectedIndex == 4) {
                            context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 4));
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                          } else {
                            if (getIt<Variables>().generalVariables.indexName !=
                                getIt<Variables>().generalVariables.currentUserBottomNavigationList[4].navigateTo) {
                              context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 4));
                              context.read<NavigationBloc>().add(const NavigationInitialEvent());
                            }
                          }
                        }
                        if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "sorter") {
                          if (getIt<Variables>().generalVariables.selectedIndex == 3) {
                            context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 3));
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                          } else {
                            if (getIt<Variables>().generalVariables.indexName !=
                                getIt<Variables>().generalVariables.currentUserBottomNavigationList[3].navigateTo) {
                              context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 3));
                              context.read<NavigationBloc>().add(const NavigationInitialEvent());
                            }
                          }
                        }
                        Future.delayed(const Duration(seconds: 10), () {
                          getIt<Variables>().generalVariables.socketMessageId = "";
                        });
                      },
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xff007838),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.attend.toUpperCase(),
                            style: TextStyle(
                                color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget btsAlertContent({required SocketBtsResponse socketMessage}) {
    return BlocConsumer<BackToStoreBloc, BackToStoreState>(
      listenWhen: (BackToStoreState previous, BackToStoreState current) {
        return previous != current;
      },
      buildWhen: (BackToStoreState previous, BackToStoreState current) {
        return previous != current;
      },
      listener: (BuildContext context, BackToStoreState state) {
        if (state is BackToStoreError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (BuildContext context, BackToStoreState state) {
        return SizedBox(
          height: getIt<Functions>().getWidgetHeight(height: 400),
          width: getIt<Functions>().getWidgetWidth(width: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/catch_weight/alert_clock.svg",
                height: getIt<Functions>().getWidgetHeight(height: 47),
                width: getIt<Functions>().getWidgetWidth(width: 47),
                fit: BoxFit.fill,
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
              Text(
                getIt<Variables>().generalVariables.currentLanguage.btsAlert,
                style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0xff282F3A), fontSize: getIt<Functions>().getTextSize(fontSize: 20)),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                    height: getIt<Functions>().getWidgetHeight(height: 1),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffFFFFFF),
                        Color(0xffBBC6CD),
                      ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    ),
                  )),
                  Container(
                    height: getIt<Functions>().getWidgetHeight(height: 68),
                    width: getIt<Functions>().getWidgetWidth(width: 240),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xffBBC6CD), width: 0.5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          socketMessage.body.quantity,
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 28), fontWeight: FontWeight.w600, color: const Color(0xff007838)),
                        ),
                        Text(
                          getIt<Variables>().generalVariables.currentLanguage.requiredQty.toUpperCase(),
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: getIt<Functions>().getWidgetHeight(height: 1),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffBBC6CD),
                        Color(0xffFFFFFF),
                      ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    ),
                  )),
                ],
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: 105),
                width: getIt<Functions>().getWidgetWidth(width: 465),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      socketMessage.body.itemName,
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 18 : 16),
                          color: const Color(0xff282F3A),
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${getIt<Variables>().generalVariables.currentLanguage.location} : ${socketMessage.body.locationName}",
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 16 : 14),
                          color: const Color(0xff282F3A),
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "${getIt<Variables>().generalVariables.currentLanguage.reported} : ${socketMessage.body.reportedBy}",
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 12),
                          color: const Color(0xff282F3A),
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${socketMessage.body.itemCode} | ",
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 12),
                              color: const Color(0xff282F3A),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase()} : ${socketMessage.body.entryTime}",
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 12),
                              color: const Color(0xff282F3A),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 38)),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xffE0E7EC),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.ignoreNow.toUpperCase(),
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        Navigator.pop(context);
                        if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "store_keeper" ||
                            getIt<Variables>().generalVariables.userData.userProfile.employeeType == "loader") {
                          if (getIt<Variables>().generalVariables.selectedIndex == 3) {
                            context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 3));
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                          } else {
                            if (getIt<Variables>().generalVariables.indexName !=
                                getIt<Variables>().generalVariables.currentUserBottomNavigationList[3].navigateTo) {
                              context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 3));
                              context.read<NavigationBloc>().add(const NavigationInitialEvent());
                            }
                          }
                        }
                        if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "sorter") {
                          if (getIt<Variables>().generalVariables.selectedIndex == 2) {
                            context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 2));
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                          } else {
                            if (getIt<Variables>().generalVariables.indexName !=
                                getIt<Variables>().generalVariables.currentUserBottomNavigationList[2].navigateTo) {
                              context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 2));
                              context.read<NavigationBloc>().add(const NavigationInitialEvent());
                            }
                          }
                        }
                        Future.delayed(const Duration(seconds: 10), () {
                          getIt<Variables>().generalVariables.socketMessageId = "";
                        });
                      },
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xff007838),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.attend.toUpperCase(),
                            style: TextStyle(
                                color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /* Widget catchWeightAlertContent() {
    return BlocConsumer<CatchWeightBloc, CatchWeightState>(
      listenWhen: (CatchWeightState previous, CatchWeightState current) {
        return previous != current;
      },
      buildWhen: (CatchWeightState previous, CatchWeightState current) {
        return previous != current;
      },
      listener: (BuildContext context, CatchWeightState state) {},
      builder: (BuildContext context, CatchWeightState state) {
        return SizedBox(
          height: getIt<Functions>().getWidgetHeight(height: 400),
          width: getIt<Functions>().getWidgetWidth(width: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/catch_weight/alert_clock.svg",
                height: getIt<Functions>().getWidgetHeight(height: 47),
                width: getIt<Functions>().getWidgetWidth(width: 47),
                fit: BoxFit.fill,
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
              Text(
                "Catch Weight Alert !",
                style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0xff282F3A), fontSize: getIt<Functions>().getTextSize(fontSize: 20)),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 1),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xffFFFFFF),
                            Color(0xffBBC6CD),
                          ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                        ),
                      )),
                  Container(
                    height: getIt<Functions>().getWidgetHeight(height: 66),
                    width: getIt<Functions>().getWidgetWidth(width: 240),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xffBBC6CD), width: 0.5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "37",
                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 28), fontWeight: FontWeight.w600, color: const Color(0xff007838)),
                        ),
                        Text(
                          getIt<Variables>().generalVariables.currentLanguage.requiredQty.toUpperCase(),
                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 1),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xffBBC6CD),
                            Color(0xffFFFFFF),
                          ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                        ),
                      )),
                ],
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
              Expanded(
                child: SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 105),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "One More Night Hostel",
                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 18), color: const Color(0xff282F3A), fontWeight: FontWeight.w600),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          "Mutton Leg Boneless - Aus Origin - KG",
                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 16), color: const Color(0xff282F3A), fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        "Request By : Ava Johnson",
                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff282F3A), fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode} : MB002 | Ship to Code : SF1937",
                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff282F3A), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 38)),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xffE0E7EC),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            'IGNORE NOW',
                            style: TextStyle(color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xff007838),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            'ATTEND',
                            style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }*/
}
