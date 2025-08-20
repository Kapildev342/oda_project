// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import 'package:oda/repository/repo_impl.dart';
import 'package:oda/repository_model/general/general_variables.dart';

class Variables {
  GeneralVariables generalVariables = GeneralVariables.fromJson({});
  Dio dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 25), receiveTimeout: const Duration(seconds: 25), sendTimeout: const Duration(seconds: 25)));
  RepoImpl repoImpl = RepoImpl();
}
