// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:oda/bloc/back_to_store/add_back_to_store/add_back_to_store_bloc.dart';
import 'package:oda/bloc/back_to_store/back_to_store/back_to_store_bloc.dart';
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/edited_packages/drop_down_lib/drop_down_search_field.dart';
import 'package:oda/repository_model/back_to_store/add_back_to_store_init_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';

class AddBackStoreScreen extends StatefulWidget {
  static const String id = "add_bts_screen";
  const AddBackStoreScreen({super.key});

  @override
  State<AddBackStoreScreen> createState() => _AddBackStoreScreenState();
}

class _AddBackStoreScreenState extends State<AddBackStoreScreen> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController reasonSearchFieldController = TextEditingController();
  final TextEditingController itemSearchFieldController = TextEditingController();
  final TextEditingController locationSearchFieldController = TextEditingController();
  SuggestionsBoxController reasonSuggestionBoxController = SuggestionsBoxController();
  SuggestionsBoxController itemSuggestionBoxController = SuggestionsBoxController();
  SuggestionsBoxController locationSuggestionBoxController = SuggestionsBoxController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    itemSearchFieldController.clear();
    quantityController.clear();
    reasonSearchFieldController.clear();
    locationSearchFieldController.clear();
    notesController.clear();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        context.read<AddBackToStoreBloc>().formatError = false;
        context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
      }
    });
    context.read<AddBackToStoreBloc>().add(const AddBackToStoreInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        AddBackToStoreBloc().add(const AddBackToStoreSetStateEvent(stillLoading: true));
        getIt<Variables>().generalVariables.indexName = getIt<Variables>().generalVariables.btsRouteList[getIt<Variables>().generalVariables.btsRouteList.length - 1];
        context.read<NavigationBloc>().add(const NavigationInitialEvent());
        getIt<Variables>().generalVariables.btsRouteList.removeAt(getIt<Variables>().generalVariables.btsRouteList.length - 1);
      },
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 480) {
          return Container(
            color: const Color(0xffEEF4FF),
            child: ListView(
              children: [
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 117),
                  width: getIt<Functions>()
                      .getWidgetWidth(width: Orientation.portrait == MediaQuery.of(context).orientation ? getIt<Variables>().generalVariables.width : getIt<Variables>().generalVariables.height),
                  child: AppBar(
                    backgroundColor: const Color(0xffEEF4FF),
                    leading: IconButton(
                      onPressed: () {
                        AddBackToStoreBloc().add(const AddBackToStoreSetStateEvent(stillLoading: true));
                        getIt<Variables>().generalVariables.indexName = getIt<Variables>().generalVariables.btsRouteList[getIt<Variables>().generalVariables.btsRouteList.length - 1];
                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                        getIt<Variables>().generalVariables.btsRouteList.removeAt(getIt<Variables>().generalVariables.btsRouteList.length - 1);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    titleSpacing: 0,
                    title: Text(
                      getIt<Variables>().generalVariables.currentLanguage.addBts,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: 26), color: const Color(0xff282F3A)),
                    ),
                    actions: const [SizedBox()],
                  ),
                ),
                BlocConsumer<AddBackToStoreBloc, AddBackToStoreState>(
                  listenWhen: (AddBackToStoreState previous, AddBackToStoreState current) {
                    return previous != current;
                  },
                  buildWhen: (AddBackToStoreState previous, AddBackToStoreState current) {
                    return previous != current;
                  },
                  listener: (BuildContext context, AddBackToStoreState state) {
                    if (state is AddBackToStoreSuccess) {
                      FocusManager.instance.primaryFocus!.unfocus();
                      context.read<AddBackToStoreBloc>().updateLoader = false;
                      context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                      itemSearchFieldController.clear();
                      quantityController.clear();
                      reasonSearchFieldController.clear();
                      locationSearchFieldController.clear();
                      notesController.clear();
                      context.read<AddBackToStoreBloc>().add(const AddBackToStoreInitialEvent());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                    if (state is AddBackToStoreFailure) {
                      FocusManager.instance.primaryFocus!.unfocus();
                      context.read<AddBackToStoreBloc>().updateLoader = false;
                      context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                    }
                    if (state is AddBackToStoreError) {
                      FocusManager.instance.primaryFocus!.unfocus();
                      context.read<AddBackToStoreBloc>().updateLoader = false;
                      context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (BuildContext context, AddBackToStoreState state) {
                    return Container(
                      height: getIt<Functions>().getWidgetHeight(height: 563),
                      width: getIt<Functions>()
                          .getWidgetWidth(width: Orientation.portrait == MediaQuery.of(context).orientation ? getIt<Variables>().generalVariables.width : getIt<Variables>().generalVariables.height),
                      margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 88),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.selectItem,
                                        style: TextStyle(color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                      ),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 45),
                                        child: buildDropButton(fromWhere:"item"),
                                      ),
                                      context.read<AddBackToStoreBloc>().selectedItemEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                      context.read<AddBackToStoreBloc>().selectedItemEmpty
                                          ? Text(
                                              getIt<Variables>().generalVariables.currentLanguage.pleaseSelectAlterNativeItem,
                                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: getIt<Functions>().getWidgetWidth(width: 20),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.quantity,
                                        style: TextStyle(color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                      ),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 45),
                                        child: TextFormField(
                                          controller: quantityController,
                                          focusNode: focusNode,
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          inputFormatters: [
                                            NumberInputFormatter(onError: (value) {
                                              context.read<AddBackToStoreBloc>().formatError = value;
                                              context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                            })
                                          ],
                                          onChanged: (value) {
                                            context.read<AddBackToStoreBloc>().quantityTextEmpty = value.isEmpty ? true : false;
                                            context.read<AddBackToStoreBloc>().selectedQuantity = value.isEmpty ? "" : value;
                                            context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                          },
                                          decoration: InputDecoration(
                                              fillColor: const Color(0xffffffff),
                                              filled: true,
                                              contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                              hintText: getIt<Variables>().generalVariables.currentLanguage.enterQuantity,
                                              hintStyle: TextStyle(color: const Color(0xff8A8D8E), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                          validator: (value) => value!.isEmpty ? 'Please enter your quantity' : null,
                                        ),
                                      ),
                                      context.read<AddBackToStoreBloc>().quantityTextEmpty
                                          ? Text(
                                              context.read<AddBackToStoreBloc>().isZeroValue
                                                  ? "You can't add a zero quantity items, please check & update new value"
                                                  : context.read<AddBackToStoreBloc>().formatError
                                                      ? "${getIt<Variables>().generalVariables.currentLanguage.lessThan10000} (ex: 9999.999)."
                                                      : context.read<AddBackToStoreBloc>().quantityTextEmpty
                                                          ? getIt<Variables>().generalVariables.currentLanguage.pleaseEnterQuantity
                                                          : "",
                                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 88),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.reason,
                                        style: TextStyle(color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                      ),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 45),
                                        child: buildDropButton(fromWhere:"reason"),
                                      ),
                                      context.read<AddBackToStoreBloc>().selectedReasonEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                      context.read<AddBackToStoreBloc>().selectedReasonEmpty
                                          ? Text(
                                              getIt<Variables>().generalVariables.currentLanguage.pleaseSelectReason,
                                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: getIt<Functions>().getWidgetWidth(width: 20),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.location,
                                        style: TextStyle(color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                      ),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 45),
                                        child: buildDropButton(fromWhere:"location"),
                                      ),
                                      context.read<AddBackToStoreBloc>().selectedLocationEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                      context.read<AddBackToStoreBloc>().selectedLocationEmpty
                                          ? Text(
                                              getIt<Variables>().generalVariables.currentLanguage.pleaseSelectLocation,
                                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getIt<Variables>().generalVariables.currentLanguage.notes,
                                style: TextStyle(color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                              TextFormField(
                                controller: notesController,
                                keyboardType: TextInputType.text,
                                minLines: 4,
                                maxLines: 4,
                                onChanged: (value) {
                                  context.read<AddBackToStoreBloc>().noteTextEmpty = value.isEmpty ? true : false;
                                  context.read<AddBackToStoreBloc>().selectedNotes = value.isEmpty ? "" : value;
                                  context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                },
                                decoration: InputDecoration(
                                    fillColor: const Color(0xffffffff),
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15), vertical: getIt<Functions>().getWidgetHeight(height: 15)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xff007AFF), width: 0.73)),
                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                    hintText: getIt<Variables>().generalVariables.currentLanguage.writeHere,
                                    hintStyle: TextStyle(color: const Color(0xff8A8D8E), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                              ),
                              context.read<AddBackToStoreBloc>().noteTextEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                              context.read<AddBackToStoreBloc>().noteTextEmpty
                                  ? Text(
                                      getIt<Variables>().generalVariables.currentLanguage.pleaseEnterTheComments,
                                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 53)),
                          context.read<AddBackToStoreBloc>().updateLoader
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
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xffE0E7EC),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        minimumSize: Size(
                                          getIt<Functions>().getWidgetWidth(width: 235),
                                          getIt<Functions>().getWidgetHeight(height: 50),
                                        ),
                                        maximumSize: Size(
                                          getIt<Functions>().getWidgetWidth(width: 235),
                                          getIt<Functions>().getWidgetHeight(height: 50),
                                        ),
                                      ),
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus!.unfocus();
                                        context.read<AddBackToStoreBloc>().updateLoader = false;
                                        context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                        itemSearchFieldController.clear();
                                        quantityController.clear();
                                        reasonSearchFieldController.clear();
                                        locationSearchFieldController.clear();
                                        notesController.clear();
                                        context.read<AddBackToStoreBloc>().add(const AddBackToStoreInitialEvent());
                                      },
                                      child: Text(
                                        getIt<Variables>().generalVariables.currentLanguage.cancel,
                                        style: TextStyle(color: const Color(0xff6F6F6F), fontSize: getIt<Functions>().getTextSize(fontSize: 15), fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xff007838),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          minimumSize: Size(
                                            getIt<Functions>().getWidgetWidth(width: 235),
                                            getIt<Functions>().getWidgetHeight(height: 50),
                                          ),
                                          maximumSize: Size(
                                            getIt<Functions>().getWidgetWidth(width: 235),
                                            getIt<Functions>().getWidgetHeight(height: 50),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (context.read<AddBackToStoreBloc>().selectedItemName == "" || context.read<AddBackToStoreBloc>().selectedItem == "") {
                                            context.read<AddBackToStoreBloc>().selectedItemEmpty = true;
                                            context.read<AddBackToStoreBloc>().quantityTextEmpty = false;
                                            context.read<AddBackToStoreBloc>().selectedReasonEmpty = false;
                                            context.read<AddBackToStoreBloc>().selectedLocationEmpty = false;
                                            context.read<AddBackToStoreBloc>().noteTextEmpty = false;
                                            context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                          } else if (quantityController.text == "") {
                                            context.read<AddBackToStoreBloc>().selectedItemEmpty = false;
                                            context.read<AddBackToStoreBloc>().quantityTextEmpty = true;
                                            context.read<AddBackToStoreBloc>().selectedReasonEmpty = false;
                                            context.read<AddBackToStoreBloc>().selectedLocationEmpty = false;
                                            context.read<AddBackToStoreBloc>().noteTextEmpty = false;
                                            context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                          } else if (context.read<AddBackToStoreBloc>().selectedReasonName == "" || context.read<AddBackToStoreBloc>().selectedReason == "") {
                                            context.read<AddBackToStoreBloc>().selectedItemEmpty = false;
                                            context.read<AddBackToStoreBloc>().quantityTextEmpty = false;
                                            context.read<AddBackToStoreBloc>().selectedReasonEmpty = true;
                                            context.read<AddBackToStoreBloc>().selectedLocationEmpty = false;
                                            context.read<AddBackToStoreBloc>().noteTextEmpty = false;
                                            context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                          } else if (context.read<AddBackToStoreBloc>().selectedLocationName == "" || context.read<AddBackToStoreBloc>().selectedLocation == "") {
                                            context.read<AddBackToStoreBloc>().selectedItemEmpty = false;
                                            context.read<AddBackToStoreBloc>().quantityTextEmpty = false;
                                            context.read<AddBackToStoreBloc>().selectedReasonEmpty = false;
                                            context.read<AddBackToStoreBloc>().selectedLocationEmpty = true;
                                            context.read<AddBackToStoreBloc>().noteTextEmpty = false;
                                            context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                          } else if (notesController.text == "") {
                                            context.read<AddBackToStoreBloc>().selectedItemEmpty = false;
                                            context.read<AddBackToStoreBloc>().quantityTextEmpty = false;
                                            context.read<AddBackToStoreBloc>().selectedReasonEmpty = false;
                                            context.read<AddBackToStoreBloc>().selectedLocationEmpty = false;
                                            context.read<AddBackToStoreBloc>().noteTextEmpty = true;
                                            context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                          } else {
                                            if (quantityController.text == "." || double.parse(quantityController.text) == 0.0) {
                                              quantityController.text = "0.0";
                                              context.read<AddBackToStoreBloc>().isZeroValue = true;
                                              context.read<AddBackToStoreBloc>().quantityTextEmpty = false;
                                              context.read<AddBackToStoreBloc>().formatError = false;
                                              context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                            } else {
                                              context.read<AddBackToStoreBloc>().updateLoader = true;
                                              context.read<AddBackToStoreBloc>().selectedItemEmpty = false;
                                              context.read<AddBackToStoreBloc>().quantityTextEmpty = false;
                                              context.read<AddBackToStoreBloc>().selectedReasonEmpty = false;
                                              context.read<AddBackToStoreBloc>().selectedLocationEmpty = false;
                                              context.read<AddBackToStoreBloc>().noteTextEmpty = false;
                                              context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                              context.read<AddBackToStoreBloc>().add(const AddBackToStoreAddEvent());
                                            }
                                          }
                                        },
                                        child: Center(
                                          child: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.add,
                                            style: TextStyle(color: const Color(0xffFFFFFF), fontSize: getIt<Functions>().getTextSize(fontSize: 15), fontWeight: FontWeight.w600),
                                          ),
                                        )),
                                  ],
                                )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        else {
          return Container(
            color: const Color(0xffEEF4FF),
            child: Column(
              children: [
                SizedBox(
                  child: AppBar(
                    backgroundColor: const Color(0xffEEF4FF),
                    automaticallyImplyLeading: false,
                    title: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            AddBackToStoreBloc().add(const AddBackToStoreSetStateEvent(stillLoading: true));
                            getIt<Variables>().generalVariables.indexName = getIt<Variables>().generalVariables.btsRouteList[getIt<Variables>().generalVariables.btsRouteList.length - 1];
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                            getIt<Variables>().generalVariables.btsRouteList.removeAt(getIt<Variables>().generalVariables.btsRouteList.length - 1);
                          },
                          child: const Icon(Icons.arrow_back),
                        ),
                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8.58)),
                        Text(
                          getIt<Variables>().generalVariables.currentLanguage.addBts,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: 22), color: const Color(0xff282F3A)),
                        ),
                      ],
                    ),
                    actions: const [SizedBox()],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: BlocConsumer<AddBackToStoreBloc, AddBackToStoreState>(
                          listenWhen: (AddBackToStoreState previous, AddBackToStoreState current) {
                            return previous != current;
                          },
                          buildWhen: (AddBackToStoreState previous, AddBackToStoreState current) {
                            return previous != current;
                          },
                          listener: (BuildContext context, AddBackToStoreState state) {
                            if (state is AddBackToStoreSuccess) {
                              FocusManager.instance.primaryFocus!.unfocus();
                             context.read<AddBackToStoreBloc>().updateLoader = false;
                              context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                              itemSearchFieldController.clear();
                              quantityController.clear();
                              reasonSearchFieldController.clear();
                              locationSearchFieldController.clear();
                              notesController.clear();
                              context.read<AddBackToStoreBloc>().add(const AddBackToStoreInitialEvent());
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                            }
                            if (state is AddBackToStoreFailure) {
                              FocusManager.instance.primaryFocus!.unfocus();
                              context.read<AddBackToStoreBloc>().updateLoader = false;
                              context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                            }
                            if (state is AddBackToStoreError) {
                              FocusManager.instance.primaryFocus!.unfocus();
                              context.read<AddBackToStoreBloc>().updateLoader = false;
                              context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                            }
                          },
                          builder: (BuildContext context, AddBackToStoreState state) {
                            return Container(
                              width: getIt<Variables>().generalVariables.width,
                              margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                              child: ListView(
                                children: [
                                  Text(
                                    getIt<Variables>().generalVariables.currentLanguage.selectItem,
                                    style: TextStyle(color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                  ),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                  SizedBox(
                                    height: getIt<Functions>().getWidgetHeight(height: 45),
                                    child: buildDropButton(fromWhere:"item"),
                                  ),
                                  context.read<AddBackToStoreBloc>().selectedItemEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                  context.read<AddBackToStoreBloc>().selectedItemEmpty
                                      ? Text(
                                          getIt<Variables>().generalVariables.currentLanguage.pleaseSelectAlterNativeItem,
                                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                                  Text(
                                    getIt<Variables>().generalVariables.currentLanguage.quantity,
                                    style: TextStyle(color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                  ),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                  SizedBox(
                                    height: getIt<Functions>().getWidgetHeight(height: 45),
                                    child: TextFormField(
                                      controller: quantityController,
                                      focusNode: focusNode,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: [
                                        NumberInputFormatter(onError: (value) {
                                          context.read<AddBackToStoreBloc>().formatError = value;
                                          context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                        })
                                      ],
                                      onChanged: (value) {
                                        context.read<AddBackToStoreBloc>().quantityTextEmpty = value.isEmpty ? true : false;
                                        context.read<AddBackToStoreBloc>().selectedQuantity = value.isEmpty ? "" : value;
                                        context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                      },
                                      decoration: InputDecoration(
                                        fillColor: const Color(0xffffffff),
                                        filled: true,
                                        contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        hintText: getIt<Variables>().generalVariables.currentLanguage.enterQuantity,
                                        hintStyle: TextStyle(color: const Color(0xff8A8D8E), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                      ),
                                      validator: (value) => value!.isEmpty ? 'Please enter your quantity' : null,
                                    ),
                                  ),
                                  Text(
                                    context.read<AddBackToStoreBloc>().isZeroValue
                                        ? "You can't add a zero quantity items, please check & update new value"
                                        : context.read<AddBackToStoreBloc>().formatError
                                            ? "${getIt<Variables>().generalVariables.currentLanguage.lessThan10000} (ex: 9999.999)."
                                            : context.read<AddBackToStoreBloc>().quantityTextEmpty
                                                ? getIt<Variables>().generalVariables.currentLanguage.pleaseEnterQuantity
                                                : "",
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                  ),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                                  Text(
                                    getIt<Variables>().generalVariables.currentLanguage.reason,
                                    style: TextStyle(color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                  ),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                  SizedBox(
                                    height: getIt<Functions>().getWidgetHeight(height: 45),
                                    child: buildDropButton(fromWhere:"reason"),
                                  ),
                                  context.read<AddBackToStoreBloc>().selectedReasonEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                  context.read<AddBackToStoreBloc>().selectedReasonEmpty
                                      ? Text(
                                          getIt<Variables>().generalVariables.currentLanguage.pleaseSelectReason,
                                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                                  Text(
                                    getIt<Variables>().generalVariables.currentLanguage.location,
                                    style: TextStyle(color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                  ),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                  SizedBox(
                                    height: getIt<Functions>().getWidgetHeight(height: 45),
                                    child: buildDropButton(fromWhere:"location"),
                                  ),
                                  context.read<AddBackToStoreBloc>().selectedLocationEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                  context.read<AddBackToStoreBloc>().selectedLocationEmpty
                                      ? Text(
                                          getIt<Variables>().generalVariables.currentLanguage.pleaseSelectLocation,
                                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                                  Text(
                                    getIt<Variables>().generalVariables.currentLanguage.notes,
                                    style: TextStyle(color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                  ),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                  TextFormField(
                                    controller: notesController,
                                    keyboardType: TextInputType.text,
                                    minLines: 4,
                                    maxLines: 4,
                                    onChanged: (value) {
                                      context.read<AddBackToStoreBloc>().noteTextEmpty = value.isEmpty ? true : false;
                                      context.read<AddBackToStoreBloc>().selectedNotes = value.isEmpty ? "" : value;
                                      context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                    },
                                    decoration: InputDecoration(
                                        fillColor: const Color(0xffffffff),
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15), vertical: getIt<Functions>().getWidgetHeight(height: 15)),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xff007AFF), width: 0.73)),
                                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        hintText: getIt<Variables>().generalVariables.currentLanguage.writeHere,
                                        hintStyle: TextStyle(color: const Color(0xff8A8D8E), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                  ),
                                  context.read<AddBackToStoreBloc>().noteTextEmpty ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)) : const SizedBox(),
                                  context.read<AddBackToStoreBloc>().noteTextEmpty
                                      ? Text(
                                          getIt<Variables>().generalVariables.currentLanguage.pleaseEnterTheComments,
                                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                    ],
                  ),
                ),
                BlocConsumer<AddBackToStoreBloc, AddBackToStoreState>(
                  builder: (BuildContext context, AddBackToStoreState state) {
                    return context.read<AddBackToStoreBloc>().updateLoader
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
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffE0E7EC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size(
                              getIt<Functions>().getWidgetWidth(width: 180),
                              getIt<Functions>().getWidgetHeight(height: 45),
                            ),
                            maximumSize: Size(
                              getIt<Functions>().getWidgetWidth(width: 180),
                              getIt<Functions>().getWidgetHeight(height: 45),
                            ),
                          ),
                          onPressed: () {
                            FocusManager.instance.primaryFocus!.unfocus();
                            context.read<AddBackToStoreBloc>().updateLoader = false;
                            context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                            itemSearchFieldController.clear();
                            quantityController.clear();
                            reasonSearchFieldController.clear();
                            locationSearchFieldController.clear();
                            notesController.clear();
                            context.read<AddBackToStoreBloc>().add(const AddBackToStoreInitialEvent());
                          },
                          child: FittedBox(
                            child: Text(
                              getIt<Variables>().generalVariables.currentLanguage.cancel,
                              style: TextStyle(color: const Color(0xff6F6F6F), fontSize: getIt<Functions>().getTextSize(fontSize: 15), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff007838),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: Size(
                                getIt<Functions>().getWidgetWidth(width: 180),
                                getIt<Functions>().getWidgetHeight(height: 45),
                              ),
                              maximumSize: Size(
                                getIt<Functions>().getWidgetWidth(width: 180),
                                getIt<Functions>().getWidgetHeight(height: 45),
                              ),
                            ),
                            onPressed: () {
                              if (context.read<AddBackToStoreBloc>().selectedItemName == "" || context.read<AddBackToStoreBloc>().selectedItem == "") {
                                context.read<AddBackToStoreBloc>().selectedItemEmpty = true;
                                context.read<AddBackToStoreBloc>().quantityTextEmpty = false;
                                context.read<AddBackToStoreBloc>().selectedReasonEmpty = false;
                                context.read<AddBackToStoreBloc>().selectedLocationEmpty = false;
                                context.read<AddBackToStoreBloc>().noteTextEmpty = false;
                                context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                              } else if (quantityController.text == "") {
                                context.read<AddBackToStoreBloc>().selectedItemEmpty = false;
                                context.read<AddBackToStoreBloc>().quantityTextEmpty = true;
                                context.read<AddBackToStoreBloc>().selectedReasonEmpty = false;
                                context.read<AddBackToStoreBloc>().selectedLocationEmpty = false;
                                context.read<AddBackToStoreBloc>().noteTextEmpty = false;
                                context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                              } else if (context.read<AddBackToStoreBloc>().selectedReasonName == "" || context.read<AddBackToStoreBloc>().selectedReason == "") {
                                context.read<AddBackToStoreBloc>().selectedItemEmpty = false;
                                context.read<AddBackToStoreBloc>().quantityTextEmpty = false;
                                context.read<AddBackToStoreBloc>().selectedReasonEmpty = true;
                                context.read<AddBackToStoreBloc>().selectedLocationEmpty = false;
                                context.read<AddBackToStoreBloc>().noteTextEmpty = false;
                                context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                              } else if (context.read<AddBackToStoreBloc>().selectedLocationName == "" || context.read<AddBackToStoreBloc>().selectedLocation == "") {
                                context.read<AddBackToStoreBloc>().selectedItemEmpty = false;
                                context.read<AddBackToStoreBloc>().quantityTextEmpty = false;
                                context.read<AddBackToStoreBloc>().selectedReasonEmpty = false;
                                context.read<AddBackToStoreBloc>().selectedLocationEmpty = true;
                                context.read<AddBackToStoreBloc>().noteTextEmpty = false;
                                context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                              } else if (notesController.text == "") {
                                context.read<AddBackToStoreBloc>().selectedItemEmpty = false;
                                context.read<AddBackToStoreBloc>().quantityTextEmpty = false;
                                context.read<AddBackToStoreBloc>().selectedReasonEmpty = false;
                                context.read<AddBackToStoreBloc>().selectedLocationEmpty = false;
                                context.read<AddBackToStoreBloc>().noteTextEmpty = true;
                                context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                              } else {
                                if (quantityController.text == "." || double.parse(quantityController.text) == 0.0) {
                                  quantityController.text = "0.0";
                                  context.read<AddBackToStoreBloc>().isZeroValue = true;
                                  context.read<AddBackToStoreBloc>().quantityTextEmpty = false;
                                  context.read<AddBackToStoreBloc>().formatError = false;
                                  context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                } else {
                                  context.read<AddBackToStoreBloc>().updateLoader = true;
                                  context.read<AddBackToStoreBloc>().isZeroValue = false;
                                  context.read<AddBackToStoreBloc>().formatError = false;
                                  context.read<AddBackToStoreBloc>().selectedItemEmpty = false;
                                  context.read<AddBackToStoreBloc>().quantityTextEmpty = false;
                                  context.read<AddBackToStoreBloc>().selectedReasonEmpty = false;
                                  context.read<AddBackToStoreBloc>().selectedLocationEmpty = false;
                                  context.read<AddBackToStoreBloc>().noteTextEmpty = false;
                                  context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent());
                                  context.read<AddBackToStoreBloc>().add(const AddBackToStoreAddEvent());
                                }
                              }
                            },
                            child: Center(
                              child: Text(
                                getIt<Variables>().generalVariables.currentLanguage.add,
                                style: TextStyle(color: const Color(0xffFFFFFF), fontSize: getIt<Functions>().getTextSize(fontSize: 15), fontWeight: FontWeight.w600),
                              ),
                            )),
                      ],
                    );
                  }, listener: (BuildContext context, AddBackToStoreState state) {  },
                ),
                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget buildDropButton({required String fromWhere}) {
    return Container(
      height: getIt<Functions>().getWidgetHeight(height: 45),
      decoration: BoxDecoration(color: const Color(0xffffffff), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: fromWhere == "item"
            ? changeAltItem
            : fromWhere == "reason"
                ? changeReason
                : changeLocation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  fromWhere == "item"
                      ? context.read<AddBackToStoreBloc>().selectedItemName ?? getIt<Variables>().generalVariables.currentLanguage.chooseItem
                      : fromWhere == "reason"
                          ? context.read<AddBackToStoreBloc>().selectedReasonName ?? getIt<Variables>().generalVariables.currentLanguage.chooseReason
                          : context.read<AddBackToStoreBloc>().selectedLocationName ?? getIt<Variables>().generalVariables.currentLanguage.chooseReason,
                  style: fromWhere == "item"
                      ? TextStyle(
                          fontSize: context.read<AddBackToStoreBloc>().selectedItemName == null ? 12 : 15,
                          color: context.read<AddBackToStoreBloc>().selectedItemName == null ? Colors.grey.shade500 : Colors.black)
                      : fromWhere == "reason"
                          ? TextStyle(
                              fontSize: context.read<AddBackToStoreBloc>().selectedReasonName == null ? 12 : 15,
                              color: context.read<AddBackToStoreBloc>().selectedReasonName == null ? Colors.grey.shade500 : Colors.black)
                          : TextStyle(
                              fontSize: context.read<AddBackToStoreBloc>().selectedLocationName == null ? 12 : 15,
                              color: context.read<AddBackToStoreBloc>().selectedLocationName == null ? Colors.grey.shade500 : Colors.black),
                ),
              ),
              fromWhere == "item"
                  ? context.read<AddBackToStoreBloc>().selectedItemName != null
                      ? InkWell(
                          onTap: () {
                            context.read<AddBackToStoreBloc>().selectedItemName = null;
                            context.read<AddBackToStoreBloc>().selectedItemEmpty = false;
                            context.read<AddBackToStoreBloc>().selectedItem = "";
                            context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent(stillLoading: false));
                          },
                          child: const Icon(
                            Icons.close,
                            size: 15,
                            color: Color(0xff8A8D8E),
                          ))
                      : const Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: Color(0xff8A8D8E),
                          size: 15,
                        )
                  : fromWhere == "reason"
                      ? context.read<AddBackToStoreBloc>().selectedReasonName != null
                          ? InkWell(
                              onTap: () {
                                context.read<AddBackToStoreBloc>().selectedReasonName = null;
                                context.read<AddBackToStoreBloc>().selectedReasonEmpty = false;
                                context.read<AddBackToStoreBloc>().selectedReason = "";
                                context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent(stillLoading: false));
                              },
                              child: const Icon(
                                Icons.close,
                                size: 15,
                                color: Color(0xff8A8D8E),
                              ))
                          : const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Color(0xff8A8D8E),
                              size: 15,
                            )
                      : context.read<AddBackToStoreBloc>().selectedLocationName != null
                          ? InkWell(
                              onTap: () {
                                context.read<AddBackToStoreBloc>().selectedLocationName = null;
                                context.read<AddBackToStoreBloc>().selectedLocationEmpty = false;
                                context.read<AddBackToStoreBloc>().selectedLocation = "";
                                context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent(stillLoading: false));
                              },
                              child: const Icon(
                                Icons.close,
                                size: 15,
                                color: Color(0xff8A8D8E),
                              ))
                          : const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Color(0xff8A8D8E),
                              size: 15,
                            ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> changeAltItem() async {
    List<AddBackToStoreInitItem> searchItems = context.read<BackToStoreBloc>().addBackToStoreInitModel.response.items;
    await showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, modelSetState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.chooseItem,
                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 26), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            "assets/catch_weight/close-circle.svg",
                            height: getIt<Functions>().getWidgetHeight(height: 32),
                            width: getIt<Functions>().getWidgetWidth(width: 32),
                            fit: BoxFit.fill,
                          ))
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffffffff),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        suffixIcon: itemSearchFieldController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  itemSearchFieldController.clear();
                                  context.read<AddBackToStoreBloc>().selectedItemEmpty = false;
                                  context.read<AddBackToStoreBloc>().selectedItemName = null;
                                  context.read<AddBackToStoreBloc>().selectedItem = "";
                                  context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent(stillLoading: false));
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Color(0xff8A8D8E),
                                ))
                            : const Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Color(0xff8A8D8E),
                                size: 15,
                              ),
                        hintText: getIt<Variables>().generalVariables.currentLanguage.chooseItem,
                        hintStyle: TextStyle(color: const Color(0xff8A8D8E), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                    onChanged: (value) {
                      searchItems = context.read<BackToStoreBloc>().addBackToStoreInitModel.response.items.where((element) => element.itemName.toLowerCase().contains(value.toLowerCase())).toList();
                      if (mounted) modelSetState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: searchItems.isNotEmpty
                        ? ListView.separated(
                      itemCount: searchItems.length,
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                      itemBuilder: (ctx, index) => ListTile(
                        title: Text(
                          searchItems[index].itemName,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.read<AddBackToStoreBloc>().selectedItemName = searchItems[index].itemName;
                          context.read<AddBackToStoreBloc>().selectedItemEmpty = false;
                          context.read<AddBackToStoreBloc>().selectedItem = searchItems[index].id;
                          context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent(stillLoading: false));
                        },
                      ),
                    )
                        : Center(child: Text(getIt<Variables>().generalVariables.currentLanguage.noDataFound)),
                  ),
                ],
              ),
            );
          });
        });
    if (mounted) setState(() {});
  }

  Future<void> changeReason() async {
    List<AddBackToStoreInitReason> searchReasons = context.read<BackToStoreBloc>().addBackToStoreInitModel.response.reasons;
    await showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, modelSetState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.chooseReason,
                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 26), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            "assets/catch_weight/close-circle.svg",
                            height: getIt<Functions>().getWidgetHeight(height: 32),
                            width: getIt<Functions>().getWidgetWidth(width: 32),
                            fit: BoxFit.fill,
                          ))
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffffffff),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        suffixIcon: reasonSearchFieldController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  reasonSearchFieldController.clear();
                                  context.read<AddBackToStoreBloc>().selectedReasonEmpty = false;
                                  context.read<AddBackToStoreBloc>().selectedReasonName = "";
                                  context.read<AddBackToStoreBloc>().selectedReason = "";
                                  context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent(stillLoading: false));
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Color(0xff8A8D8E),
                                ))
                            : const Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Color(0xff8A8D8E),
                                size: 15,
                              ),
                        hintText: getIt<Variables>().generalVariables.currentLanguage.chooseReason,
                        hintStyle: TextStyle(color: const Color(0xff8A8D8E), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                    onChanged: (value) {
                      searchReasons =
                          context.read<BackToStoreBloc>().addBackToStoreInitModel.response.reasons.where((element) => element.label.toLowerCase().contains(value.toLowerCase())).toList();
                      if (mounted) modelSetState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: searchReasons.isNotEmpty
                        ? ListView.separated(
                      itemCount: searchReasons.length,
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                      itemBuilder: (ctx, index) => ListTile(
                        title: Text(
                          searchReasons[index].label,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.read<AddBackToStoreBloc>().selectedReasonName = searchReasons[index].label;
                          context.read<AddBackToStoreBloc>().selectedReasonEmpty = false;
                          context.read<AddBackToStoreBloc>().selectedReason = searchReasons[index].id;
                          context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent(stillLoading: false));
                        },
                      ),
                    )
                        : Center(child: Text(getIt<Variables>().generalVariables.currentLanguage.noDataFound)),
                  ),
                ],
              ),
            );
          });
        });
    if (mounted) setState(() {});
  }

  Future<void> changeLocation() async {
    List<AddBackToStoreInitLocation> searchReasons = context.read<BackToStoreBloc>().addBackToStoreInitModel.response.locations;
    await showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, modelSetState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.chooseLocation,
                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 26), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            "assets/catch_weight/close-circle.svg",
                            height: getIt<Functions>().getWidgetHeight(height: 32),
                            width: getIt<Functions>().getWidgetWidth(width: 32),
                            fit: BoxFit.fill,
                          ))
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffffffff),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        suffixIcon: locationSearchFieldController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  locationSearchFieldController.clear();
                                  context.read<AddBackToStoreBloc>().selectedLocationEmpty = false;
                                  context.read<AddBackToStoreBloc>().selectedLocationName = "";
                                  context.read<AddBackToStoreBloc>().selectedLocation = "";
                                  context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent(stillLoading: false));
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Color(0xff8A8D8E),
                                ))
                            : const Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Color(0xff8A8D8E),
                                size: 15,
                              ),
                        hintText: getIt<Variables>().generalVariables.currentLanguage.chooseLocation,
                        hintStyle: TextStyle(color: const Color(0xff8A8D8E), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                    onChanged: (value) {
                      searchReasons =
                          context.read<BackToStoreBloc>().addBackToStoreInitModel.response.locations.where((element) => element.label.toLowerCase().contains(value.toLowerCase())).toList();
                      if (mounted) modelSetState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: searchReasons.isNotEmpty
                        ? ListView.separated(
                      itemCount: searchReasons.length,
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                      itemBuilder: (ctx, index) => ListTile(
                        title: Text(
                          searchReasons[index].label,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.read<AddBackToStoreBloc>().selectedLocationName = searchReasons[index].label;
                          context.read<AddBackToStoreBloc>().selectedLocationEmpty = false;
                          context.read<AddBackToStoreBloc>().selectedLocation = searchReasons[index].id;
                          context.read<AddBackToStoreBloc>().add(const AddBackToStoreSetStateEvent(stillLoading: false));
                        },
                      ),
                    )
                        : Center(child: Text(getIt<Variables>().generalVariables.currentLanguage.noDataFound)),
                  ),
                ],
              ),
            );
          });
        });
    if (mounted) setState(() {});
  }
}
