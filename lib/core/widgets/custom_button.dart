import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tamra_task/core/value/colors.dart';
import 'package:tamra_task/core/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? txtColor;
  final Color? btnColor;
  final String? title;
  final Function? onTap;
  final Color? borderColor;
  final FontWeight? fontWeight;
  const CustomButton({
    Key? key,
    this.height,
    this.width,
    this.txtColor,
    this.btnColor,
    this.title,
    this.onTap,
    this.borderColor,
    this.fontWeight,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        width: width ?? 342.w,
        height: height ?? 50.h,
        decoration: BoxDecoration(
          color: btnColor ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: borderColor ?? AppColors.primaryColor),
        ),
        child: Center(
          child: CustomText(
            title ?? "",
            textAlign: TextAlign.center,
            fontSize: 18.sp,
            color: txtColor ?? AppColors.whiteColor,
            fontWeight: fontWeight ?? FontWeight.bold,
            fontFamily: "tajawalb",
          ),
        ),
      ),
    );
  }
}
