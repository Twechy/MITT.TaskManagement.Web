import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseClient {
  // chrome.exe --user-data-dir="C:/Chrome dev session" --disable-web-security

  late Dio dio = Dio();
  late SharedPreferences _prefs;
  static String BaseUrl = '';

  final int _connectTimeout = 20000;

  BaseClient() {
    _createDio();
  }

  Future _createDio() async {
    _prefs = await SharedPreferences.getInstance();

    var jwtToken = _prefs.getString('jwtToken') ?? '';
    dio = Dio(BaseOptions(
      baseUrl: BaseUrl,
      connectTimeout: _connectTimeout,
      headers: Map.from(
        {
          'Authorization': 'Bearer $jwtToken',
        },
      ),
    ));
  }

  Future<Response> get(String path,
          {Map<String, dynamic>? queryParameters, Options? options}) async =>
      await dio.get(
        BaseUrl + path,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response> post(String path, dynamic data,
          {Map<String, dynamic>? queryParameters}) async =>
      await dio.post(path, data: data, queryParameters: queryParameters);
}
