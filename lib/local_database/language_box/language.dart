// Package imports:
import 'package:hive/hive.dart';

part 'language.g.dart';

@HiveType(typeId: 7)
class LanguageData extends HiveObject {
  @HiveField(0)
  late List<LanguageListModel> languageList;

  @HiveField(1)
  late List<Map<String, dynamic>> languageValueString;

  LanguageData({
    required this.languageList,
    required this.languageValueString,
  });

  factory LanguageData.fromJson(Map<String, dynamic> json) => LanguageData(
        languageList: List<LanguageListModel>.from((json["language_list"] ?? []).map((x) => LanguageListModel.fromJson(x))),
        languageValueString: List<Map<String, dynamic>>.from(json["language_value_string"] ?? []),
      );

  Map<String, dynamic> toJson() => {
        "language_list": languageList,
        "language_value_string": languageValueString,
      };
}

@HiveType(typeId: 8)
class LanguageListModel extends HiveObject {
  @HiveField(0)
  late String code;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String isDefault;

  LanguageListModel({
    required this.code,
    required this.name,
    required this.isDefault,
  });

  factory LanguageListModel.fromJson(Map<String, dynamic> json) => LanguageListModel(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        isDefault: json["is_default"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "is_default": isDefault,
      };
}
