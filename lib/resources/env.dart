enum Environment { dev, prod, staging }

abstract class AppEnvironment {
  static late String baseUrl;
  static late String title;
  static late String appVersion;
  static late String apiVersion;
  static late Environment _environment;
  static Environment get environment => _environment;
  static setupEnv(Environment env) {
    _environment = env;
    switch (env) {
      case Environment.dev:
        {
          baseUrl = "http://192.168.1.251:1014/";
          apiVersion = "api/v1/";
          title = "[D]ODA-EWF";
          appVersion = "1.0.0";
          break;
        }
      case Environment.staging:
        {
          baseUrl = "https://ewf-oda.quickiz.com/";
          apiVersion = "api/v1/";
          title = "[T]ODA-EWF";
          appVersion = "1.0.0";
          break;
        }
      case Environment.prod:
        {
          baseUrl = "";
          apiVersion = "";
          title = "ODA-EWF";
          appVersion = "1.0.0";
          break;
        }
    }
  }
}
