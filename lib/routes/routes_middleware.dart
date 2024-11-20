import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safetracker/data/repositories/authentication/auth_repository.dart';
import 'package:safetracker/routes/routes.dart';

class SRouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route){
    return AuthenticationRepository.instance.isAuthencticated ? null : const RouteSettings(name: SRoutes.login);
  }
}