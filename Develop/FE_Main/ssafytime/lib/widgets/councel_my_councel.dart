import 'package:flutter/material.dart';
import 'package:ssafytime/custom_button.dart';
import 'package:get/get.dart';

import '../controllers/councel_controller.dart';
import 'councel_list_item.dart';



class CMyCouncel extends StatelessWidget {

  CMyCouncel({Key? key}) : super(key: key);

  MyCouncelController controller = Get.put(MyCouncelController());


  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        width: 390, height: 666,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 진행 중인 상담 ==============================================
              for (int i=0; i < controller.myCouncelList.length; i++) ... [
                if (controller.myCouncelStartTimeList[i] <= controller.doubleTypeCurrentTime.value &&
                    controller.doubleTypeCurrentTime.value <= controller.myCouncelEndTimeList[i]) ... [
                CouncelListItem(
                  startTime: controller.myCouncelStartTimeList[i],
                  endTime: controller.myCouncelEndTimeList[i],
                  rezTime: controller.myCouncelList[i].value.rezTime,
                  currentTime: controller.doubleTypeCurrentTime.value,
                  title: controller.myCouncelList[i].value.title,
                  reject : controller.myCouncelList[i].value.reject,
                  state: controller.myCouncelList[i].value.state,
                ),
                Divider(thickness: 2, height: 6, color: Color(0xffC3C6CF),),
                ]
              ],

              // 승인된 상담 ============================================== state == 2 인 것중에 진행중이 아닌거
              for (int i=0; i < controller.myCouncelList.length; i++) ... [
                if (controller.myCouncelList[i].value.state == 2 &&
                !(controller.myCouncelStartTimeList[i] <= controller.doubleTypeCurrentTime.value &&
                    controller.doubleTypeCurrentTime.value <= controller.myCouncelEndTimeList[i])) ... [
                  CouncelListItem(
                    startTime: controller.myCouncelStartTimeList[i],
                    endTime: controller.myCouncelEndTimeList[i],
                    rezTime: controller.myCouncelList[i].value.rezTime,
                    currentTime: controller.doubleTypeCurrentTime.value,
                    title: controller.myCouncelList[i].value.title,
                    reject : controller.myCouncelList[i].value.reject,
                    state: controller.myCouncelList[i].value.state,
                  ),
                  Divider(thickness: 2, height: 6, color: Color(0xffC3C6CF),),
                ]
              ],

              // 승인 대기중인 상담 ==============================================
              for (int i=0; i < controller.myCouncelList.length; i++) ... [
                if (controller.myCouncelList[i].value.state == 1) ... [
                  CouncelListItem(
                    startTime: controller.myCouncelStartTimeList[i],
                    endTime: controller.myCouncelEndTimeList[i],
                    rezTime: controller.myCouncelList[i].value.rezTime,
                    currentTime: controller.doubleTypeCurrentTime.value,
                    title: controller.myCouncelList[i].value.title,
                    reject : controller.myCouncelList[i].value.reject,
                    state: controller.myCouncelList[i].value.state,
                  ),
                  Divider(thickness: 2, height: 6, color: Color(0xffC3C6CF),),
                ]
              ],

              // 종료 or 거절 된 상담 ==============================================
              for (int i=0; i < controller.myCouncelList.length; i++) ... [
                if (controller.myCouncelList[i].value.state == 3 ||
                    controller.myCouncelList[i].value.state == 4) ... [
                  CouncelListItem(
                    startTime: controller.myCouncelStartTimeList[i],
                    endTime: controller.myCouncelEndTimeList[i],
                    rezTime: controller.myCouncelList[i].value.rezTime,
                    currentTime: controller.doubleTypeCurrentTime.value,
                    title: controller.myCouncelList[i].value.title,
                    reject : controller.myCouncelList[i].value.reject,
                    state: controller.myCouncelList[i].value.state,
                  ),
                  Divider(thickness: 2, height: 6, color: Color(0xffC3C6CF),),
                ]
              ],


            ],
          ),
        ),
      ),
    );
  }
}

//
// 현재 시간, 년 월 일 시 분 을 숫자로 변환
double calculatorTime(DateTime time) {
  String s = '';
  String t = '';
  s = time.year.toString() + time.month.toString() + time.day.toString();
  t = (time.hour.toInt() + (time.minute.toInt()/60)).toStringAsFixed(2).toString();
  double v = double.parse((s+t));
  return v;
}
