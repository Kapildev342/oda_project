// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/repository_model/trip_list/trip_list_time_line_info_model.dart';
import 'package:oda/screens/out_bound/out_bound_detail_screen.dart';
import 'package:oda/screens/out_bound/out_bound_entry_screen.dart';
import 'package:oda/screens/pick_list/pick_list_details_screen.dart';
import 'package:oda/screens/trip_list/trip_list_detail_screen.dart';
import 'package:oda/screens/trip_list/trip_list_entry_screen.dart';
import 'package:oda/screens/warehouse_pickup/warehouse_pickup_detail_screen.dart';
import 'package:oda/screens/warehouse_pickup/warehouse_pickup_summary_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';
import 'constants.dart';

enum AppPermissionStatus {
  permissionGranted,
  permissionDenied,
  permissionRestricted,
  permissionLimited,
  permissionPermanentlyDenied,
  serviceDisabled,
}

class Functions {
  double getWidgetHeight({required double height}) {
    double variableHeightValue = (getIt<Variables>().generalVariables.isDeviceTablet ? 1024 : 917) / height;
    return getIt<Variables>().generalVariables.height / variableHeightValue;
  }

  double getWidgetWidth({required double width}) {
    double variableWidthValue = (getIt<Variables>().generalVariables.isDeviceTablet ? 768 : 412) / width;
    return getIt<Variables>().generalVariables.width / variableWidthValue;
  }

  double getTextSize({required double fontSize}) {
    return getIt<Variables>().generalVariables.text!.scale(fontSize);
  }

  Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else {
      Directory documentsDir = await getApplicationDocumentsDirectory();
      String documentsPath = documentsDir.path;
      Directory folderDir = Directory('$documentsPath/ODA_Reports');
      if (!await folderDir.exists()) {
        await folderDir.create(recursive: true);
      }
      return folderDir;
    }
  }

  Future<void> sharedSetValue({required String type, required String key, required value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (type) {
      case "string":
        prefs.setString(key, value);
      case "int":
        prefs.setInt(key, value);
      case "bool":
        prefs.setBool(key, value);
      default:
        prefs.setDouble(key, value);
    }
  }

  Future<String?> sharedGetValue({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  void showAnimatedDialog({
    required BuildContext context,
    required bool isFromTop,
    required bool isCloseDisabled,
    bool? isBackEnabled,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AnimatedAlertDialog(isFromTop: isFromTop, isCloseDisabled: isCloseDisabled, isBackEnabled: isBackEnabled ?? false);
      },
    );
  }

  List<String> getSuggestions({required String query, required List<String> data}) {
    List<String> matches = <String>[];
    matches.addAll(data);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<String> getStringToList({required String value, required String quantity, required String weightUnit}) {
    List<String> splitList = [];
    splitList = value.split(",");
    for (int i = 0; i < splitList.length; i++) {
      splitList[i] = (double.parse(splitList[i])).toStringAsFixed(3);
    }
    String requiredQuantity = "$quantity $weightUnit";
    splitList.insert(0, requiredQuantity);
    splitList.insert(0, "image");
    return splitList;
  }

  List<CatchWeightItem> getStringToCatchWeight({required String value}) {
    List<String> splitList = [];
    splitList = value.split(",");
    for (int i = 0; i < splitList.length; i++) {
      splitList[i] = (double.parse(splitList[i])).toStringAsFixed(3);
    }
    return List.generate(splitList.length, (i) {
      return CatchWeightItem(data: splitList[i], isSelected: false, isSelectedAlready: false);
    });
  }

  String durationToString({required String timeStamp, required DateTime currentTime}) {
    String returnValue = "00:00:00";
    if (timeStamp != "") {
      Duration d = currentTime.difference(DateTime.fromMillisecondsSinceEpoch((int.parse(timeStamp)) * 1000));
      num totalSeconds = d.inSeconds;
      num totalHours = totalSeconds ~/ 3600;
      String totalHoursString = totalHours < 10 ? "0$totalHours" : "$totalHours";
      num totalMinutes = (totalSeconds - (totalHours * 3600)) ~/ 60;
      String totalMinutesString = totalMinutes < 10 ? "0$totalMinutes" : "$totalMinutes";
      num seconds = (totalSeconds - ((totalHours * 3600) + (totalMinutes * 60)));
      String totalSecondsString = seconds < 10 ? "0$seconds" : "$seconds";
      returnValue = "$totalHoursString:$totalMinutesString:$totalSecondsString";
    }
    return returnValue;
  }

  String formatNumber({required String qty}) {
    num x = num.parse(qty);
    if (x % 1 == 0) {
      return x.toInt().toString(); // Convert to int if no decimal part
    } else {
      return x.toStringAsFixed(3).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
    }
  }

  Future<void> convertingListToCsv({required List<Map<String, dynamic>> tripMainDataList}) async {
    List<String> headers = getAllKeys(tripMainDataList).toList();
    List<List<dynamic>> csvData = [
      headers, // Add headers as first row
      ...tripMainDataList.map((item) {
        return headers.map((key) {
          var value = item[key];
          if (value is List && value.isNotEmpty && value.first is Map) {
            // Convert List<Map<String, dynamic>> to a string, maintaining array structure
            return jsonEncode(value);
          } else {
            return value ?? '';
          }
        }).toList();
      })
    ];
    String csvString = const ListToCsvConverter().convert(csvData);
    File tempFile = File("${(await getIt<Functions>().getDownloadsDirectory())!.path}/csvFile");
    await tempFile.writeAsString(csvString);
  }

  Future<List<Map<String, dynamic>>> convertingCSVToList() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    List<Map<String, dynamic>> jsonData = [];
    if (result != null) {
      File file = File(result.files.single.path!);
      String csvString = await file.readAsString();
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);
      List<String> headers = csvTable.first.map((e) => e.toString()).toList();
      jsonData = csvTable.skip(1).map((row) {
        Map<String, dynamic> jsonMap = {};
        for (int i = 0; i < headers.length; i++) {
          String key = headers[i];
          String value = row[i].toString();
          if (value.startsWith("[") && value.endsWith("]")) {
            jsonMap[key] = jsonDecode(value);
          } else {
            jsonMap[key] = value;
          }
        }
        return jsonMap;
      }).toList();
    }
    return jsonData;
  }

  Set<String> getAllKeys(List<Map<String, dynamic>> jsonData) {
    Set<String> keys = {};
    for (var item in jsonData) {
      item.forEach((key, value) {
        if (value is List && value.isNotEmpty && value.first is Map) {
          keys.add(key);
        } else {
          keys.add(key);
        }
      });
    }
    return keys;
  }

  Future<List<TimelineInfo>> timelineInfoFunction({required String pageRoute}) async {
    switch (pageRoute) {
      case PickListDetailsScreen.id:
        {
          await getIt<Variables>().repoImpl.getPickListTimeLineInfo(
              query: {"picklist_id": getIt<Variables>().generalVariables.picklistItemData.id},
              method: "post",
              module: ApiEndPoints().pickListModule).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                TripListTimeLineApiModel tripListTimeLineApiModel = TripListTimeLineApiModel.fromJson(value);
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(tripListTimeLineApiModel.response.timelineInfo);
              }
            }
          });
          return getIt<Variables>().generalVariables.timelineInfo;
        }
      case TripListEntryScreen.id:
        {
          await getIt<Variables>().repoImpl.getSorterTripListTimeLineInfo(
              query: {"trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId},
              method: "post",
              module: ApiEndPoints().sorterModule).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                TripListTimeLineApiModel tripListTimeLineApiModel = TripListTimeLineApiModel.fromJson(value);
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(tripListTimeLineApiModel.response.timelineInfo);
              }
            }
          });
          return getIt<Variables>().generalVariables.timelineInfo;
        }
      case TripListDetailScreen.id:
        {
          await getIt<Variables>().repoImpl.getSorterTripListTimeLineInfo(
              query: {"trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId},
              method: "post",
              module: ApiEndPoints().loaderModule).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                TripListTimeLineApiModel tripListTimeLineApiModel = TripListTimeLineApiModel.fromJson(value);
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(tripListTimeLineApiModel.response.timelineInfo);
              }
            }
          });
          return getIt<Variables>().generalVariables.timelineInfo;
        }
      case OutBoundEntryScreen.id:
        {
          await getIt<Variables>().repoImpl.getSorterTripListTimeLineInfo(
              query: {"trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId},
              method: "post",
              module: ApiEndPoints().loaderModule).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                TripListTimeLineApiModel tripListTimeLineApiModel = TripListTimeLineApiModel.fromJson(value);
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(tripListTimeLineApiModel.response.timelineInfo);
              }
            }
          });
          return getIt<Variables>().generalVariables.timelineInfo;
        }
      case OutBoundDetailScreen.id:
        {
          await getIt<Variables>().repoImpl.getSorterTripListTimeLineInfo(
              query: {"trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId},
              method: "post",
              module: ApiEndPoints().loaderModule).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                TripListTimeLineApiModel tripListTimeLineApiModel = TripListTimeLineApiModel.fromJson(value);
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(tripListTimeLineApiModel.response.timelineInfo);
              }
            }
          });
          return getIt<Variables>().generalVariables.timelineInfo;
        }
      case WarehousePickupDetailScreen.id:
        {
          await getIt<Variables>().repoImpl.getWarehouseTimeLineInfo(
              query: {"trip_id": getIt<Variables>().generalVariables.soListMainIdData.tripId},
              method: "post",
              module: ApiEndPoints().loaderModule).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                TripListTimeLineApiModel tripListTimeLineApiModel = TripListTimeLineApiModel.fromJson(value);
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(tripListTimeLineApiModel.response.timelineInfo);
              }
            }
          });
          return getIt<Variables>().generalVariables.timelineInfo;
        }
      case WarehousePickupSummaryScreen.id:
        {
          await getIt<Variables>().repoImpl.getWarehouseTimeLineInfo(
              query: {"trip_id": getIt<Variables>().generalVariables.soListMainIdData.tripId},
              method: "post",
              module: ApiEndPoints().loaderModule).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                TripListTimeLineApiModel tripListTimeLineApiModel = TripListTimeLineApiModel.fromJson(value);
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(tripListTimeLineApiModel.response.timelineInfo);
              }
            }
          });
          return getIt<Variables>().generalVariables.timelineInfo;
        }
      default:
        {
          await getIt<Variables>().repoImpl.getSorterTripListTimeLineInfo(
              query: {"trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId},
              method: "post",
              module: ApiEndPoints().sorterModule).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                TripListTimeLineApiModel tripListTimeLineApiModel = TripListTimeLineApiModel.fromJson(value);
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(tripListTimeLineApiModel.response.timelineInfo);
              }
            }
          });
          return getIt<Variables>().generalVariables.timelineInfo;
        }
    }
  }

  Future<UploadFileClass> uploadImages({
    required ImageSource source,
    int? maxImages,
    required Function function,
    required BuildContext context,
    File? file,
  }) async {
    try {
      function();
      List<String> uploadImageUrls = [];
      List<String> uploadImageNames = [];
      List<File> images = [];
      if (file == null) {
        images = await pickImages(source: source, maxImages: maxImages ?? 1, context: context);
      } else {
        images.add(file);
      }
      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          String? s3path = await uploadFileUsingAws(
            file: images[i],
            accessKey: getIt<Variables>().generalVariables.initialSetupValues.s3.accessKey,
            secretKey: getIt<Variables>().generalVariables.initialSetupValues.s3.secretKey,
            bucket: getIt<Variables>().generalVariables.initialSetupValues.s3.bucketName,
            region: getIt<Variables>().generalVariables.initialSetupValues.s3.region,
            destDir: getIt<Variables>().generalVariables.initialSetupValues.s3.path,
          );
          if (s3path != null) {
            Uri uri = Uri.parse(s3path);
            String fileName = uri.pathSegments.last;
            uploadImageUrls.add(s3path);
            uploadImageNames.add("${getIt<Variables>().generalVariables.initialSetupValues.s3.path.replaceAll("/", "")}/$fileName");
          }
        }
      }
      return UploadFileClass(urlsList: uploadImageUrls, urlsNameList: uploadImageNames);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<File>> pickImages({
    required ImageSource source,
    required int maxImages,
    required BuildContext context,
  }) async {
    List<File> resultList = [];
    List<Asset> multiImage = [];
    AppPermissionStatus permissionStatus = await checkPermissions(source == ImageSource.camera ? "camera" : "gallery");
    if (permissionStatus == AppPermissionStatus.permissionPermanentlyDenied) {
      if (context.mounted) {
        getIt<Widgets>().flushBarWidget(context: context, message: "You permanently denied the permission for camera & gallery");
      }
    } else if (permissionStatus == AppPermissionStatus.permissionDenied || permissionStatus == AppPermissionStatus.permissionRestricted) {
      if (context.mounted) {
        getIt<Widgets>().flushBarWidget(context: context, message: "You denied the permission for camera & gallery");
      }
    } else {
      if (source == ImageSource.gallery) {
        try {
          multiImage = await MultiImagePicker.pickImages(
            androidOptions: AndroidOptions(
              maxImages: maxImages,
              hasCameraInPickerPage: false,
              actionBarColor: const Color(0xFFE7741E),
              actionBarTitleColor: Colors.white,
              statusBarColor: const Color(0xFFE7741E),
              actionBarTitle: "Select Photo",
              allViewTitle: "All Photos",
              useDetailsView: false,
              selectCircleStrokeColor: const Color(0xFFE7741E),
            ),
            selectedAssets: [],
          );
          if (multiImage.isNotEmpty) {
            for (var element in multiImage) {
              File file = await getImageFileFromAssets(asset: element);
              resultList.add(file);
            }
          }
        } catch (e) {
          if (e is PathAccessException) {
            throw e.message;
          } else if (e is NoImagesSelectedException) {
          } else {
            throw e.toString();
          }
        }
      } else {
        var picker = ImagePicker();
        try {
          XFile? image = await picker.pickImage(source: ImageSource.camera);
          if (image != null) {
            resultList = [File(image.path)];
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
    return resultList;
  }

  Future<File> getImageFileFromAssets({required Asset asset}) async {
    final byteData = await asset.getByteData();
    final tempFile = File("${(await getDownloadsDirectory())!.path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    return file;
  }

  Future<String?> uploadFileUsingAws({
    required File file,
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required String destDir,
    Map<String, String>? metadata,
  }) async {
    String fileName = file.path.split("/").last.split(".").first;
    String fileFormat = file.path.split("/").last.split(".").last;
    String? url = await AwsS3.uploadFile(
      accessKey: accessKey,
      secretKey: secretKey,
      file: file,
      bucket: bucket,
      destDir: destDir,
      region: region,
      metadata: metadata,
      filename: "$fileName${DateTime.now().millisecondsSinceEpoch}.$fileFormat",
    );
    return url;
  }

  Future<AppPermissionStatus> checkPermissions(String source) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (source == "camera") {
      await Permission.camera.request();
      PermissionStatus status = await Permission.camera.status;
      if (status.isDenied) {
        return AppPermissionStatus.permissionDenied;
      } else if (status.isGranted) {
        return AppPermissionStatus.permissionGranted;
      } else if (status.isLimited) {
        return AppPermissionStatus.permissionLimited;
      } else {
        return AppPermissionStatus.permissionPermanentlyDenied;
      }
    } else {
      if (androidInfo.version.sdkInt >= 33) {
        await Permission.photos.request();
        PermissionStatus status = await Permission.photos.status;
        if (status.isDenied) {
          return AppPermissionStatus.permissionDenied;
        } else if (status.isGranted) {
          return AppPermissionStatus.permissionGranted;
        } else if (status.isLimited) {
          return AppPermissionStatus.permissionLimited;
        } else {
          return AppPermissionStatus.permissionPermanentlyDenied;
        }
      } else {
        await Permission.storage.request();
        PermissionStatus status = await Permission.storage.status;
        if (status.isDenied) {
          return AppPermissionStatus.permissionDenied;
        } else if (status.isGranted) {
          return AppPermissionStatus.permissionGranted;
        } else if (status.isLimited) {
          return AppPermissionStatus.permissionLimited;
        } else {
          return AppPermissionStatus.permissionPermanentlyDenied;
        }
      }
    }
  }

  Future<List<File>> warehouseUploadImages({
    required ImageSource source,
    int? maxImages,
    required Function function,
    required BuildContext context,
    File? file,
  }) async {
    function();
    List<File> images = [];
    if (file == null) {
      images = await pickImages(source: source, maxImages: maxImages ?? 1, context: context);
    } else {
      images.add(file);
    }
    return images;
  }

  int quantityValue({int? quantity, int? returnQuantity,required String tripReturnStatus}) {
    if (returnQuantity == null) {
      return quantity ?? 0;
    } else {
      if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer") {
        if (tripReturnStatus.toLowerCase() == "completed") {
          return returnQuantity;
        } else {
          return quantity ?? 0;
        }
      } else {
        return returnQuantity;
      }
    }
  }
}

class UploadFileClass {
  final List<String> urlsList;
  final List<String> urlsNameList;

  const UploadFileClass({required this.urlsList, required this.urlsNameList});
}

class NumberRangeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    if (!RegExp(r'^\d*\.?\d{0,2}$').hasMatch(text)) return oldValue;
    final double? value = double.tryParse(text);
    if (value == null || value < 0 || value > 100) return oldValue;
    return newValue;
  }
}
