import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tamra_task/core/value/colors.dart';
import 'package:tamra_task/data/controllers/app_controller.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetBuilder<AppController>(
                  init: AppController(),
                  builder: (controller) => Visibility(
                        visible: controller.isAvailable,
                        child: GestureDetector(
                          onTap: () async {
                            await controller.authenticateUser();
                          },
                          child: Container(
                            width: 40.w,
                            height: 40.h,

                            decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: AppColors.primaryColor),
                            // ignore: prefer_const_constructors
                            child: Center(
                                child: const Icon(
                              Icons.fingerprint,
                              color: AppColors.whiteColor,
                            )),
                          ),
                        ),
                      )),
            ],
          ),
        ],
      ),
    );
  }
}
