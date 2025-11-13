import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:supa_architecture/api_client/interceptors/persistent_url_interceptor.dart';
import 'package:supa_architecture/supa_architecture_platform_interface.dart';

extension DioInterceptorExtension on Dio {
  addCookieStorageInterceptor() {
    if (!kIsWeb) {
      interceptors
          .add(SupaArchitecturePlatform.instance.cookieStorage.interceptor);
    }
  }

  addBaseUrlInterceptor() {
    if (!kIsWeb) {
      interceptors.add(PersistentUrlInterceptor());
    }
  }
}
