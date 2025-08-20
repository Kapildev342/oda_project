// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oda/bloc/ro_trip_list/ro_trip_list_detail/ro_trip_list_detail_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';

class TotalAssetsWidget extends StatefulWidget {
  static const String id = "total_assets_widget";
  const TotalAssetsWidget({super.key});

  @override
  State<TotalAssetsWidget> createState() => _TotalAssetsWidgetState();
}

class _TotalAssetsWidgetState extends State<TotalAssetsWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > 480) {
        return BlocConsumer<RoTripListDetailBloc, RoTripListDetailState>(
          listenWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
            return previous != current;
          },
          buildWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
            return previous != current;
          },
          listener: (BuildContext context, RoTripListDetailState state) {
            if (state is RoTripListDetailSuccess) {
              context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
              context.read<RoTripListDetailBloc>().add(const RoTripListDetailInitialEvent());
              context.read<RoTripListDetailBloc>().updateLoader = false;
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is RoTripListDetailFailure) {
              context.read<RoTripListDetailBloc>().updateLoader = false;
              context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
            }
            if (state is RoTripListDetailError) {
              context.read<RoTripListDetailBloc>().updateLoader = false;
              context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
              ScaffoldMessenger.of(context).clearSnackBars();
              getIt<Widgets>().flushBarWidget(context: context, message: state.message);
            }
          },
          builder: (BuildContext context, RoTripListDetailState state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.totalAssets.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                        padding: EdgeInsets.symmetric(
                            horizontal: getIt<Functions>().getWidgetWidth(width: 12), vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: const ScrollPhysics(),
                          itemCount: context.read<RoTripListDetailBloc>().assetItemsList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              /* onTap: () {
                                  setState(() {
                                    context.read<RoTripListDetailBloc>().assetItemsList[index].isItemSelected = !context.read<RoTripListDetailBloc>().assetItemsList[index].isItemSelected;
                                  });
                                },*/
                              leading: Checkbox(
                                onChanged: (value) {
                                  /* setState(() {
                                      context.read<RoTripListDetailBloc>().assetItemsList[index].isItemSelected = !context.read<RoTripListDetailBloc>().assetItemsList[index].isItemSelected;
                                    });*/
                                },
                                value: context.read<RoTripListDetailBloc>().assetItemsList[index].isItemSelected,
                                checkColor: Colors.white,
                                fillColor: WidgetStatePropertyAll<Color>(context.read<RoTripListDetailBloc>().assetItemsList[index].isItemSelected
                                    ? const Color(0xff29B473)
                                    : const Color(0xffffffff)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              title: Text(
                                context.read<RoTripListDetailBloc>().assetItemsList[index].itemName,
                                style: TextStyle(
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff282F3A)),
                              ),
                              trailing: context.read<RoTripListDetailBloc>().assetItemsList[index].isItemSelected
                                  ? InkWell(
                                      onTap: context.read<RoTripListDetailBloc>().roTripDetailModel.response.assetsReturned
                                          ? () {}
                                          : () {
                                              setState(() {
                                                context.read<RoTripListDetailBloc>().assetItemsList[index].isMarkAsReceived =
                                                    !context.read<RoTripListDetailBloc>().assetItemsList[index].isMarkAsReceived;
                                              });
                                            },
                                      child: Container(
                                        width: getIt<Functions>().getWidgetWidth(width: 190),
                                        height: getIt<Functions>().getWidgetHeight(height: 36),
                                        decoration: BoxDecoration(
                                            color: const Color(0xff29B473).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(35),
                                            border: Border.all(color: const Color(0xff29B473), width: 1)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Checkbox(
                                              onChanged: (value) {
                                                if (context.read<RoTripListDetailBloc>().roTripDetailModel.response.assetsReturned) {
                                                } else {
                                                  setState(() {
                                                    context.read<RoTripListDetailBloc>().assetItemsList[index].isMarkAsReceived =
                                                        !context.read<RoTripListDetailBloc>().assetItemsList[index].isMarkAsReceived;
                                                  });
                                                }
                                              },
                                              value: context.read<RoTripListDetailBloc>().assetItemsList[index].isMarkAsReceived,
                                              checkColor: Colors.white,
                                              fillColor: WidgetStatePropertyAll<Color>(
                                                  context.read<RoTripListDetailBloc>().assetItemsList[index].isMarkAsReceived
                                                      ? const Color(0xff29B473)
                                                      : const Color(0xffffffff)),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            Text(
                                              getIt<Variables>().generalVariables.currentLanguage.markAsReceived,
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xff282F3A)),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        )),
                  ),
                ),
                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 15)),
                context.read<RoTripListDetailBloc>().roTripDetailModel.response.assetsReturned
                    ? const SizedBox()
                    : context.read<RoTripListDetailBloc>().updateLoader
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: 15),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff007AFF),
                                    minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 310), getIt<Functions>().getWidgetHeight(height: 46)),
                                    maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 310), getIt<Functions>().getWidgetHeight(height: 46)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    )),
                                onPressed: () {
                                  context.read<RoTripListDetailBloc>().updateLoader = true;
                                  context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                                  context.read<RoTripListDetailBloc>().updateAssetsList.clear();
                                  for (int i = 0; i < context.read<RoTripListDetailBloc>().assetItemsList.length; i++) {
                                    if (context.read<RoTripListDetailBloc>().assetItemsList[i].isMarkAsReceived) {
                                      context
                                          .read<RoTripListDetailBloc>()
                                          .updateAssetsList
                                          .add(context.read<RoTripListDetailBloc>().assetItemsList[i].itemId);
                                    }
                                  }
                                  context.read<RoTripListDetailBloc>().add(const RoTripListDetailUpdateAssetsEvent());
                                },
                                child: Text(
                                  getIt<Variables>().generalVariables.currentLanguage.updateAssets.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: getIt<Functions>().getTextSize(fontSize: 15), fontWeight: FontWeight.w500, color: Colors.white),
                                )),
                          ),
                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 15)),
              ],
            );
          },
        );
      } else {
        return BlocConsumer<RoTripListDetailBloc, RoTripListDetailState>(
          listenWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
            return previous != current;
          },
          buildWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
            return previous != current;
          },
          listener: (BuildContext context, RoTripListDetailState state) {},
          builder: (BuildContext context, RoTripListDetailState state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.totalAssets.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      context.read<RoTripListDetailBloc>().roTripDetailModel.response.assetsReturned
                          ? const SizedBox()
                          : context.read<RoTripListDetailBloc>().updateLoader
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 15),
                                      ),
                                    ],
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    context.read<RoTripListDetailBloc>().updateLoader = true;
                                    context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                                    context.read<RoTripListDetailBloc>().updateAssetsList.clear();
                                    for (int i = 0; i < context.read<RoTripListDetailBloc>().assetItemsList.length; i++) {
                                      if (context.read<RoTripListDetailBloc>().assetItemsList[i].isMarkAsReceived) {
                                        context
                                            .read<RoTripListDetailBloc>()
                                            .updateAssetsList
                                            .add(context.read<RoTripListDetailBloc>().assetItemsList[i].itemId);
                                      }
                                    }
                                    context.read<RoTripListDetailBloc>().add(const RoTripListDetailUpdateAssetsEvent());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: getIt<Functions>().getWidgetHeight(height: 3),
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: const Color(0xff007AFF),
                                    ),
                                    child: Center(
                                      child: Text(
                                        getIt<Variables>().generalVariables.currentLanguage.update.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                    ],
                  ),
                ),
                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                        padding:
                            EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 4), right: getIt<Functions>().getWidgetWidth(width: 12)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: const ScrollPhysics(),
                          itemCount: context.read<RoTripListDetailBloc>().assetItemsList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            onChanged: (value) {
                                              /*    setState(() {
                                                context.read<RoTripListDetailBloc>().assetItemsList[index].isItemSelected = !context.read<RoTripListDetailBloc>().assetItemsList[index].isItemSelected;
                                              });*/
                                            },
                                            value: context.read<RoTripListDetailBloc>().assetItemsList[index].isItemSelected,
                                            checkColor: Colors.white,
                                            fillColor: WidgetStatePropertyAll<Color>(
                                                context.read<RoTripListDetailBloc>().assetItemsList[index].isItemSelected
                                                    ? const Color(0xff29B473)
                                                    : const Color(0xffffffff)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                          ),
                                          Text(
                                            context.read<RoTripListDetailBloc>().assetItemsList[index].itemName,
                                            style: TextStyle(
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff282F3A)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                  context.read<RoTripListDetailBloc>().assetItemsList[index].isItemSelected
                                      ? InkWell(
                                          onTap: context.read<RoTripListDetailBloc>().roTripDetailModel.response.assetsReturned
                                              ? () {}
                                              : () {
                                                  setState(() {
                                                    context.read<RoTripListDetailBloc>().assetItemsList[index].isMarkAsReceived =
                                                        !context.read<RoTripListDetailBloc>().assetItemsList[index].isMarkAsReceived;
                                                  });
                                                },
                                          child: Container(
                                            width: getIt<Functions>().getWidgetWidth(width: 190),
                                            height: getIt<Functions>().getWidgetHeight(height: 36),
                                            decoration: BoxDecoration(
                                                color: const Color(0xff29B473).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: const Color(0xff29B473), width: 0.3)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Checkbox(
                                                  onChanged: (value) {
                                                    if (context.read<RoTripListDetailBloc>().roTripDetailModel.response.assetsReturned) {
                                                    } else {
                                                      setState(() {
                                                        context.read<RoTripListDetailBloc>().assetItemsList[index].isMarkAsReceived =
                                                            !context.read<RoTripListDetailBloc>().assetItemsList[index].isMarkAsReceived;
                                                      });
                                                    }
                                                  },
                                                  value: context.read<RoTripListDetailBloc>().assetItemsList[index].isMarkAsReceived,
                                                  checkColor: Colors.white,
                                                  fillColor: WidgetStatePropertyAll<Color>(
                                                      context.read<RoTripListDetailBloc>().assetItemsList[index].isMarkAsReceived
                                                          ? const Color(0xff29B473)
                                                          : const Color(0xffffffff)),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                ),
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.markAsReceived,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff282F3A)),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              height: 0,
                            );
                          },
                        )),
                  ),
                ),
                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
              ],
            );
          },
        );
      }
    });
  }
}

class TotalAssetsDataModel {
  bool isItemSelected;
  String itemName;
  String itemId;
  bool isMarkAsReceived;

  TotalAssetsDataModel({
    required this.isItemSelected,
    required this.itemName,
    required this.itemId,
    required this.isMarkAsReceived,
  });

  factory TotalAssetsDataModel.fromJson(Map<String, dynamic> json) => TotalAssetsDataModel(
        isItemSelected: json["is_selected"],
        itemName: json["label"] ?? '',
        itemId: json["id"] ?? '',
        isMarkAsReceived: json["is_returned"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "is_selected": isItemSelected,
        "label": itemName,
        "id": itemId,
        "is_returned": isMarkAsReceived,
      };
}
