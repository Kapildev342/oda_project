// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:oda/local_database/pick_list_box/pick_list.dart';

CatchWeightFilterModel catchWeightFilterModelFromJson(String str) => CatchWeightFilterModel.fromJson(json.decode(str));

String catchWeightFilterModelToJson(CatchWeightFilterModel data) => json.encode(data.toJson());

class CatchWeightFilterModel {
  final String status;
  final FilterResponse response;

  CatchWeightFilterModel({
    required this.status,
    required this.response,
  });

  factory CatchWeightFilterModel.fromJson(Map<String, dynamic> json) => CatchWeightFilterModel(
        status: json["status"] ?? "",
        response: FilterResponse.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class FilterResponse {
  final List<Filter> filters;

  FilterResponse({
    required this.filters,
  });

  factory FilterResponse.fromJson(Map<String, dynamic> json) => FilterResponse(
        filters: List<Filter>.from((json["filters"] ?? []).map((x) => Filter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "filters": List<dynamic>.from(filters.map((x) => x.toJson())),
      };
}

/*class Filter {
  String type;
  String label;
  String selection;
  List<FilterOptionsResponse> options;
  bool getOptions;
  bool status;

  Filter({
    required this.type,
    required this.label,
    required this.selection,
    required this.options,
    required this.getOptions,
    required this.status,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        type: json["type"] ?? '',
        label: json["label"] ?? '',
        selection: json["selection"] ?? '',
        options: List<FilterOptionsResponse>.from((json["options"] ?? []).map((x) => FilterOptionsResponse.fromJson(x))),
        status: json["status"] ?? false,
        getOptions: json["get_options"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "label": label,
        "selection": selection,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "get_options": getOptions,
        "status": status,
      };
}*/
