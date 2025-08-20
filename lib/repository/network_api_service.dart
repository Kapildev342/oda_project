
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/env.dart';
import 'package:oda/resources/variables.dart';
import 'app_exception.dart';
import 'base_api_service.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future<dynamic> getInitialFunction({
    required String url,
    required Map<String, dynamic> query,
    required String method,
    CancelToken? globalCancelToken,
  }) async {
    dynamic responseJson;
    try {
      String uri = AppEnvironment.baseUrl + AppEnvironment.apiVersion + url;
      Map<String, dynamic> body = query;
      debugPrint("uri : $uri");
      debugPrint("body : $body");
      debugPrint("getIt<Variables>().generalVariables.isLoggedIn : ${getIt<Variables>().generalVariables.isLoggedIn}");
      debugPrint("headers : ${getIt<Variables>().generalVariables.loggedHeaders.toJson()}");
      switch (method) {
        case "get":
          {
            Response response = await getIt<Variables>().dio.get(
                  uri,
                  options: Options(headers: getIt<Variables>().generalVariables.loggedHeaders.toJson()),
                  data: body,
                  cancelToken: globalCancelToken,
                );
            responseJson = returnDioResponse(response);
          }
        case "post":
          {
            Response response = await getIt<Variables>().dio.post(
                  uri,
                  options: Options(headers: getIt<Variables>().generalVariables.loggedHeaders.toJson()),
                  data: body,
                  cancelToken: globalCancelToken,
                );
            responseJson = returnDioResponse(response);
          }
        case "put":
          {
            Response response = await getIt<Variables>().dio.put(
                  uri,
                  options: Options(headers: getIt<Variables>().generalVariables.loggedHeaders.toJson()),
                  data: body,
                  cancelToken: globalCancelToken,
                );
            responseJson = returnDioResponse(response);
          }
        case "patch":
          {
            Response response = await getIt<Variables>().dio.patch(
                  uri,
                  options: Options(headers: getIt<Variables>().generalVariables.loggedHeaders.toJson()),
                  data: body,
                  cancelToken: globalCancelToken,
                );
            responseJson = returnDioResponse(response);
          }
        case "delete":
          {
            Response response = await getIt<Variables>().dio.delete(
                  uri,
                  options: Options(headers: getIt<Variables>().generalVariables.loggedHeaders.toJson()),
                  data: body,
                  cancelToken: globalCancelToken,
                );
            responseJson = returnDioResponse(response);
          }
        default:
          {
            Response response = await getIt<Variables>().dio.get(
                  uri,
                  options: Options(headers: getIt<Variables>().generalVariables.loggedHeaders.toJson()),
                  data: body,
                  cancelToken: globalCancelToken,
                );
            responseJson = returnDioResponse(response);
          }
      }
    } on DioException catch (error) {
      handleDioError(error);
    }
    debugPrint("responseJson : $responseJson");
    return responseJson;
  }

  dynamic returnDioResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = response.data;
        return responseJson;
      case 201:
        dynamic responseJson = response.data;
        return responseJson;
      case 400:
        throw DioException(requestOptions: RequestOptions(data: response.data));
      case 401:
        throw DioException(requestOptions: RequestOptions(data: response.data));
      case 402:
        throw DioException(requestOptions: RequestOptions(data: response.data));
      case 403:
        throw DioException(requestOptions: RequestOptions(data: response.data));
      case 404:
        throw DioException(requestOptions: RequestOptions(data: response.data));
      case 405:
        throw DioException(requestOptions: RequestOptions(data: response.data));
      case 406:
        throw DioException(requestOptions: RequestOptions(data: response.data));
      case 407:
        throw DioException(requestOptions: RequestOptions(data: response.data));
      case 500:
      default:
        throw FetchDataException('${getIt<Variables>().generalVariables.currentLanguage.errorOccurred} ${response.statusCode}');
    }
  }

  void handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      switch (statusCode) {
        case 400:
          debugPrint("Bad Request: Check your input.");
          throw FetchDataException(error.response?.data["response"] ?? getIt<Variables>().generalVariables.currentLanguage.badRequest);
        case 401:
          debugPrint("Unauthorized: Authentication required.");
          throw FetchDataException(error.response?.data["response"] ?? getIt<Variables>().generalVariables.currentLanguage.unauthorized);
        case 403:
          debugPrint("Forbidden: Access is denied.");
          throw FetchDataException(error.response?.data["response"] ?? getIt<Variables>().generalVariables.currentLanguage.forbidden);
        case 404:
          debugPrint("Not Found: The resource does not exist.");
          throw FetchDataException(error.response?.data["response"] ?? getIt<Variables>().generalVariables.currentLanguage.notFound);
        case 500:
          debugPrint("Internal Server Error: Something went wrong on the server.");
          throw FetchDataException(error.response?.data["response"] ?? getIt<Variables>().generalVariables.currentLanguage.internalServerError);
        default:
          debugPrint("Unhandled Status Code: $statusCode");
          throw FetchDataException(error.response?.data["response"] ?? "${getIt<Variables>().generalVariables.currentLanguage.unhandledStatusCode} $statusCode");
      }
    } else {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          debugPrint("Connection Timeout: Could not connect to the server.");
          throw FetchDataException(error.response?.data["response"] ?? getIt<Variables>().generalVariables.currentLanguage.connectionTimeout);
        case DioExceptionType.sendTimeout:
          debugPrint("Send Timeout: Failed to send the request.");
          throw FetchDataException(error.response?.data["response"] ?? getIt<Variables>().generalVariables.currentLanguage.sendTimeout);
        case DioExceptionType.receiveTimeout:
          debugPrint("Receive Timeout: Server took too long to respond.");
          throw FetchDataException(error.response?.data["response"] ?? getIt<Variables>().generalVariables.currentLanguage.receiveTimeout);
        case DioExceptionType.cancel:
          debugPrint(error.response?.data["response"] ?? "${getIt<Variables>().generalVariables.currentLanguage.requestCancelled} ${error.message}");

        case DioExceptionType.unknown:
          debugPrint("Other Error: ${error.message}");
          throw FetchDataException(error.response?.data["response"] ?? "${getIt<Variables>().generalVariables.currentLanguage.other} ${error.message}");
        case DioExceptionType.connectionError:
          debugPrint("Connection Error: ${error.message}");
          throw FetchDataException(error.response?.data["response"] ?? getIt<Variables>().generalVariables.currentLanguage.connectionError);
        case DioExceptionType.badResponse:
          debugPrint("Bad Response Error: ${error.message}");
          throw FetchDataException(error.response?.data["response"] ?? getIt<Variables>().generalVariables.currentLanguage.badResponse);
        case DioExceptionType.badCertificate:
          debugPrint("Bad Certificate Error: ${error.message}");
          throw FetchDataException(error.response?.data["response"] ?? getIt<Variables>().generalVariables.currentLanguage.badCertificate);
      }
    }
  }
}
