import 'dart:developer';
import 'dart:io';

import 'package:candlesticks/candlesticks.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:path_provider/path_provider.dart';
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

  //Excel File
  List<ChartData> candles = [];
  String pathFile = "";
  List dataCsv = [];
  Future<List<ChartData>> _loadCSV(pathNew) async {
    final lines = File(pathNew).readAsLinesSync();
    lines.removeAt(0);
    for (var line in lines) {
      List<String> values = line.split(',');

      dataCsv.add({
        "Date": values[0].toString(),
        "Open": values[1].toString(),
        "High": values[2].toString(),
        "Low": values[3].toString(),
        "Close": values[4].toString(),
        "Volume": values[6].toString(),
      });
    }
    print(dataCsv);
    return (dataCsv)
        .map((e) => ChartData(
            //High, low, open, and close values all are same
            x: DateTime.parse(e["Date"]),
            open: double.parse(e["Open"]),
            high: double.parse(e["High"]),
            low: double.parse(e["Low"]),
            close: double.parse(e["Close"])))
        .toList();
  }

  Future openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);
    if (file == null) return;

    _loadCSV(file.path).then((value) {
      // setState(() {
      candles = value;
      // });
      update();
    });
  }

  Future<File?> downloadFile(String url, String? name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    try {
      if (await file.exists()) {
        print("file deleted $file");
        await file.delete();
        candles.clear();
        dataCsv.clear();
      }

      final resonse = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0));
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(resonse.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }
}
