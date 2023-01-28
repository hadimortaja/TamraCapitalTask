import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tamra_task/data/controllers/app_controller.dart';
import 'package:tamra_task/features/chart_view/presentation/views/chart_view.dart';
import 'package:tamra_task/features/home_view/presentation/views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        Get.put(AppController());
        return GetMaterialApp(
            title: "Tamra Task",
            theme: ThemeData(
              fontFamily: "montserrat",
              scaffoldBackgroundColor: const Color(0xffFBFBFB),
            ),
            defaultTransition: Transition.fadeIn,
            transitionDuration: const Duration(milliseconds: 300),
            debugShowCheckedModeBanner: false,

            // supportedLocales: [
            //   Locale('en', 'US'),
            // ],
            home: ChartView());
      },
    );
  }
}
