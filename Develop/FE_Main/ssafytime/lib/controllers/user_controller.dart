import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ssafytime/controllers/loading_controller.dart';
import 'package:ssafytime/model/councel_detail.dart';
import 'package:ssafytime/models/attendance_model.dart';
import 'package:ssafytime/models/recruitment.dart';
import 'package:ssafytime/models/user_atten_model.dart';
import 'package:ssafytime/models/user_model.dart';
import 'package:ssafytime/repositories/home_repository.dart';
import 'package:ssafytime/repositories/user_repository.dart';
import 'package:ssafytime/services/auth_service.dart';
import 'package:ssafytime/widgets/notification_infomation.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  static UserController get to => Get.find();

  List<String> attenCategory = [
    "absentR",
    "absentO",
    "attenT",
    "attenN",
    "lateR",
    "lateO"
  ];

  final atten = AttenModel().obs;

  final userAtten = UserAtten().obs;

  final carouselItemList = <dynamic>[].obs;
  final carouselItemListWidget = <Widget>[].obs;

  final dateF = new DateFormat("yy-MM-dd");
  final timeF = new DateFormat("yy-MM-dd HH:mm");

  UserRepo userApi = UserRepo(token: AuthService.to.accessToken.value);
  HomeRepo homeApi = HomeRepo(token: AuthService.to.accessToken.value);

  var oncommingCouncel = CouncelDetail().obs; // 기한이 임박한 상담
  int councelTime = 999999999999;

  Recruitment recruitmentList = Recruitment(data: []);
  RxInt recruitCnt = 0.obs;

  @override
  void onInit() async {
    await initFetch();
    fetchRecruitmentInfo();
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<void> initFetch() async {
    carouselItemList.clear();
    loadingController.to.setIsLoading(true);
    await fetchUser();
    await fetchAttence();
    await fetchNotice();
    setCaroselItemList();
    setAtten();
    loadingController.to.setIsLoading(false);
  }

  Future<void> fetchUser() async {
    User? userInfo = await userApi.fetchUserInfo();
    log("${userInfo?.userEmail}");
    if (userInfo != null) {
      var fcmToken = await userApi.fetchFcmToken();
      bool res = await userApi.updateFcmToken(fcmToken);
      if (res) {
        log("Login : Success / FcmToken : Success");
        AuthService.to.user(userInfo);
      } else {
        log("Login : Success / FcmToken : Failed");
      }
    } else {
      log("Login : Failed / FcmToken : Failed");
    }
  }

  Future<void> fetchAttence() async {
    atten(await homeApi.fetchAttendence());
  }

  Future<void> fetchNotice() async {
    var data = await homeApi.fetchNotice();
    if (data != null) {
      carouselItemList.add(data);
    }
  }

  Future<void> fetchHomeSurvey() async {
    var data = await homeApi.fetchHomeSurvey();

    if (data != null) {
      carouselItemList.add(data);
    }
  }

  void setAtten() {
    Map<String, int> attenRaw = {};
    atten.value.attendance?.forEach(
        (e) => {attenRaw[attenCategory[e.category ?? 0]] = e.count ?? 0});

    userAtten(UserAtten(
      absentO: attenRaw['absentO'] ?? 0,
      absentR: attenRaw['absentR'] ?? 0,
      lateR: attenRaw['lateR'] ?? 0,
      lateO: attenRaw['lateO'] ?? 0,
      attenN: attenRaw['attenN'] ?? 0,
      attenT: attenRaw['attenT'] ?? 0,
    ));
  }

  void setCaroselItemList() {
    carouselItemListWidget.clear();
    if (carouselItemList.length > 0) {
      carouselItemList.forEach((element) {
        switch (element.notiType) {
          case 1:
            carouselItemListWidget.add(CNI(
                opacity: 1,
                myIcon: FontAwesomeIcons.bullhorn,
                iconColor: 0xffFF5449,
                title: element.title,
                detail: Text(dateF.format(element.createDateTime)),
                isComplete: ""));
            break;
          case 2:
            carouselItemListWidget.add(CNI(
                opacity: 1,
                myIcon: FontAwesomeIcons.pen,
                iconColor: 0xff0079D1,
                title: element.title,
                detail: Text(
                    "${timeF.format(element.startDate)} ~ ${timeF.format(element.endDate)}"),
                isComplete: ""));
            break;
          case 3:
            carouselItemListWidget.add(CNI(
                opacity: 1,
                myIcon: FontAwesomeIcons.userGroup,
                iconColor: 0xff686ADB,
                title: element.title,
                detail:
                    Text("${dateF.format(element.rezDate)} ${element.rezTime}"),
                isComplete: ""));
            break;
        }
      });
    } else {
      carouselItemListWidget.add(CNI(
          opacity: 1,
          myIcon: FontAwesomeIcons.spinner,
          iconColor: 0xff808080,
          title: "로딩 중",
          detail: Text("로딩 중"),
          isComplete: ""));
    }
    log("캐로셀 길이 ${carouselItemList.length}");
    log("캐로셀위젯 길이 ${carouselItemListWidget.length}");
  }

  Future fetchOncommingCouncel() async {
    int? userId = AuthService.to.user.value.userIdx;
    int? isAdmin = AuthService.to.user.value.isAdmin;

    if (userId == null || isAdmin == null) {
      return;
    }

    var res = await http.get(
        Uri.parse("http://i8a602.p.ssafy.io:9090/meet/${userId}/${isAdmin}"));
    var data = json.decode(res.body);

    var date = DateTime.now();
    int current = date.year * 100000000 +
        date.month * 1000000 +
        date.day * 10000 +
        date.hour * 100 +
        date.minute;

    for (int i = 0; i < data.length; i++) {
      final obj = CouncelDetail.fromJson(data[i]).obs;
      final int Time =
          calculatorTimeOfClass(obj.value.rezDate, obj.value.rezTime).round();
      if (obj.value.state == 2 && Time < councelTime) {
        councelTime = Time;
        oncommingCouncel = obj;
      }
    }
  }

  double calculatorTimeOfClass(DateTime? rezDate, double rezTime) {
    if (rezDate == null) {
      return 999999999999;
    }
    String year = rezDate.year.toString();
    String mon = rezDate.month.toString();
    String day = rezDate.day.toString();
    mon.length == 1 ? mon = '0' + mon : null;
    day.length == 1 ? day = '0' + day : null;
    String tmpDate = year + mon + day;
    double dateValue = double.parse(tmpDate);

    // 13.0 -> 1300 으로 , 14.5 -> 1430 으로
    double rezHour = rezTime;
    double rezMin = rezHour % 1;
    rezHour -= rezMin;
    double rezHourToMin = rezMin * 60;
    double timeFinal = rezHour * 100 + rezHourToMin;

    return dateValue * 10000 + timeFinal;
  }

  Future fetchRecruitmentInfo() async {
    var res = await http.get(Uri.parse("http://i8a602.p.ssafy.io:9090/job"));
    var data = json.decode(res.body);

    recruitmentList = Recruitment.fromJson(data);
    recruitCnt.value = recruitmentList.data.length;
  }
}
