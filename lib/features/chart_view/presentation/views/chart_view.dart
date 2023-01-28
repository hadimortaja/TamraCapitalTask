import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:dio/dio.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tamra_task/core/value/colors.dart';
import 'package:tamra_task/core/widgets/custom_text.dart';
import 'package:tamra_task/data/controllers/app_controller.dart';

class ChartView extends StatefulWidget {
  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  @override
  void initState() {
    Get.find<AppController>().openFile(
        url: "https://query1.finance.yahoo.com/v7/finance/download/SPUS",
        fileName: "finance.csv");

    super.initState();
  }

  DateTimeRange? _selectedDateRange;
  var startDate;
  var endDate;

  void _show() async {
    final DateTimeRange? result = await showDateRangePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      // Rebuild the UI
      print(result.start.toString());
      print(result.end.toString());
      setState(() {
        _selectedDateRange = result;
        startDate =
            result.start.millisecondsSinceEpoch.toString().substring(0, 10);
        endDate = result.end.millisecondsSinceEpoch.toString().substring(0, 10);
        print(startDate);
        print(endDate);
        Get.find<AppController>().openFile(
            url:
                "https://query1.finance.yahoo.com/v7/finance/download/SPUS?period1=$startDate&period2=$endDate",
            fileName: "finance.csv");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          width: Get.width,
          height: 80.h,
          child: Row(
            children: [
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Get.find<AppController>().openFile(
                            url:
                                "https://query1.finance.yahoo.com/v7/finance/download/SPUS?interval=1d",
                            fileName: "finance.csv");
                      },
                      child: CustomText(
                        "1 Day",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.whiteColor,
                      ))),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Get.find<AppController>().openFile(
                          url:
                              "https://query1.finance.yahoo.com/v7/finance/download/SPUS?interval=1wk",
                          fileName: "finance.csv");
                    },
                    child: CustomText(
                      "1 Week",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.whiteColor,
                    )),
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Get.find<AppController>().openFile(
                          url:
                              "https://query1.finance.yahoo.com/v7/finance/download/SPUS?interval=1mo",
                          fileName: "finance.csv");
                    },
                    child: CustomText(
                      "1 Month",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.whiteColor,
                    )),
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      _show();
                    },
                    child: CustomText(
                      "Range",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.whiteColor,
                    )),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: CustomText(
            "تمرا",
            fontSize: 15.sp,
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        body: GetBuilder<AppController>(
          init: AppController(),
          builder: (controller) {
            return Center(
              child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(),
                  series: <ChartSeries>[
                    CandleSeries<ChartData, dynamic>(
                        enableTooltip: true,
                        dataSource: controller.candles,
                        xAxisName: "Date",
                        enableSolidCandles: true,
                        borderWidth: 10.w,
                        xValueMapper: (ChartData data, _) => data.x,
                        highValueMapper: (ChartData data, _) => data.high,
                        lowValueMapper: (ChartData data, _) => data.low,
                        openValueMapper: (ChartData data, _) => data.open,
                        closeValueMapper: (ChartData data, _) => data.close),
                  ]),
            );
          },
        ));
  }
}

class ChartData {
  final dynamic x;
  final double? open;
  final double? high;
  final double? low;
  final double? close;
  ChartData({this.x, this.open, this.high, this.low, this.close});
}
