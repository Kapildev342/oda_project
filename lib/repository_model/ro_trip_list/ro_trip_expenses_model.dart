
import 'dart:convert';

RoTripExpensesModel roTripExpensesModelFromJson(String str) => RoTripExpensesModel.fromJson(json.decode(str));

String roTripExpensesModelToJson(RoTripExpensesModel data) => json.encode(data.toJson());

class RoTripExpensesModel {
  String status;
  Response response;

  RoTripExpensesModel({
    required this.status,
    required this.response,
  });

  factory RoTripExpensesModel.fromJson(Map<String, dynamic> json) => RoTripExpensesModel(
    status: json["status"]??"",
    response: Response.fromJson(json["response"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": response.toJson(),
  };
}

class Response {
  String totalExpenses;
  List<ExpenseReason> expenseReasons;
  List<ExpensesList> expensesList;

  Response({
    required this.totalExpenses,
    required this.expenseReasons,
    required this.expensesList,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    totalExpenses: json["total_expenses"]??"",
    expenseReasons: List<ExpenseReason>.from((json["expense_reasons"]??[]).map((x) => ExpenseReason.fromJson(x))),
    expensesList: List<ExpensesList>.from((json["expenses_list"]??[]).map((x) => ExpensesList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_expenses": totalExpenses,
    "expense_reasons": List<dynamic>.from(expenseReasons.map((x) => x.toJson())),
    "expenses_list": List<dynamic>.from(expensesList.map((x) => x.toJson())),
  };
}

class ExpenseReason {
  String id;
  String code;
  String description;

  ExpenseReason({
    required this.id,
    required this.code,
    required this.description,
  });

  factory ExpenseReason.fromJson(Map<String, dynamic> json) => ExpenseReason(
    id: json["id"]??"",
    code: json["code"]??"",
    description: json["description"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "description": description,
  };
}

class ExpensesList {
  String id;
  String description;
  String expenseDate;
  String amount;

  ExpensesList({
    required this.id,
    required this.description,
    required this.expenseDate,
    required this.amount,
  });

  factory ExpensesList.fromJson(Map<String, dynamic> json) => ExpensesList(
    id: json["id"]??"",
    description: json["description"]??"",
    expenseDate: json["expense_date"]??"",
    amount: json["amount"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "expense_date": expenseDate,
    "amount": amount,
  };
}
