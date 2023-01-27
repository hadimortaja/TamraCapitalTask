import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tamra_task/core/value/animate_do.dart';
import 'package:tamra_task/core/value/colors.dart';
import 'package:tamra_task/core/widgets/custom_text.dart';
import 'package:tamra_task/data/controllers/app_controller.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
 AppController appController =Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText("مرحبا بك",
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
color: AppColors.whiteColor,

        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
              CustomText("يرجى النقر على الزر بالاسفل للدخول للصفحة التالية",
              fontSize: 15.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 30.h,),

              SlideInLeft(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    GestureDetector(
                                onTap: () async {
                                  await appController.authenticateUser();
                                },
                                child: Container(
                                  width: 160.w,
                                  height: 40.h,

                                  decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                      shape: BoxShape.rectangle,
                                      color: Colors.blue),
                                  // ignore: prefer_const_constructors
                                  child: Center(
                                      child: const Icon(
                                    Icons.fingerprint,
                                    color: AppColors.whiteColor,
                                  )),
                                ),
                              ),

                  ],
                ),
              ),
              SizedBox(height: 30.h,),
            ],
          ),
        ],
      ),
    );
  }
}
