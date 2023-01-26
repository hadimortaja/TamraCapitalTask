import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:tamra_task/features/chart_view/presentation/views/chart_view.dart';

class AppController extends GetxController {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  List<BiometricType>? listOfBiometrics;
  bool isAuthenticated = false;
  bool isAvailable = false;
  @override
  void onInit() {
    isBiometricAvailable();
    getListOfBiometricTypes();
  }

  isBiometricAvailable() async {
    try {
      this.isAvailable = await _localAuthentication.canCheckBiometrics;
      update(['AuthFinger']);
    } on PlatformException catch (e) {
      print(e);
    }
    isAvailable
        ? log('Biometric is available!')
        : log('Biometric is unavailable.');
  }

  getListOfBiometricTypes() async {
    try {
      this.listOfBiometrics =
          await _localAuthentication.getAvailableBiometrics();
      log('listOfBiometrics $listOfBiometrics');
      update(['AuthFinger']);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  authenticateUser() async {
    try {
      this.isAuthenticated = await _localAuthentication.authenticate(
        localizedReason:
            "Please authenticate to view your transaction overview",
        options: const AuthenticationOptions(
            useErrorDialogs: false, stickyAuth: true),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            cancelButton: 'cancel',
            goToSettingsButton: 'settings',
            goToSettingsDescription: 'Please set up your Touch ID.',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ],
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (isAuthenticated) {
      Get.offAll(ChartView());
    }
  }
}
