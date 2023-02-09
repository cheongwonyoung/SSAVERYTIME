import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

// HSIW 홈스크린 스케줄 아이템 위젯
// 변수값 설명은 노션 참고
class HSIW extends StatelessWidget {

  Map table = {
    0 : {
      'category' : '데이터 없음',
      'color' : 0xff000000
    },
    1 : {
      'category' : '알고리즘',
      'color' : 0xff0082A1
    },
    2 : {
      'category' : '코딩과정',
      'color' : 0xff686ADB
    },
    3 : {
      'category' : '프로젝트',
      'color' : 0xffDE3730
    },
    4 : {
      'category' : '기타',
      'color' : 0xff0079D1
    },
  };


  final int category;
  final int onOff;
  final String title;
  final String subTitle;
  final int startTime;
  final int endTime;


  late int color = table[this.category]['color'];
  late String studyPlace = this.onOff == 0 ? '온라인' : '오프라인';
  late String classTime = getClassTime(this.startTime, this.endTime);
  late bool isClassTime = getCurrentTime() >= this.startTime*100 ? true : false;
  late double progressPercent = getPercent(this.startTime, this.endTime);
  late String categoryToString = table[this.category]['category'];


  HSIW({Key? key,
    required this.onOff,
    required this.subTitle,
    required this.title,
    required this.category,
    required this.startTime,
    required this.endTime,
    })
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 5,
          height: 160,
          color: Color(color), // option 1
        ),
        Container(
          width: 360,
          height: 160,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // option 2
                    Text(
                      categoryToString,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: Color(color), // option 1
                      ),
                    ),
                    // option 3
                    Text(
                      studyPlace,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // option 4
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Color(0xff73777F),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    // option 5
                    Text(
                      subTitle,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 28),
                    ),
                  ],
                ),
              ),
              // option 7 수업 중이냐 전이냐
              Column(
                children: [
                  // 수업 중 /////////
                  if (isClassTime == true)
                    Column(
                      children: [
                        LinearPercentIndicator(
                          width: 350,
                          lineHeight: 8,
                          barRadius: const Radius.circular(4),
                          percent: progressPercent, // optinal 6_1
                          progressColor: const Color(0xffFC6161),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // option 6
                            Text(
                              classTime,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xffABABAE),
                                  fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  // 수업 전 ============
                  if (isClassTime == false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // option 6
                        Text(
                          classTime,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xffABABAE),
                              fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}


String getClassTime(int startTime, int endTime) {
  String start = startTime.toString() + ':00';
  String  end= endTime.toString() + ':00';
  return start + ' ~ ' + end;
}

// 13:40 을 1340 으로 만들어주는 함수
int getCurrentTime() {
  DateTime time = DateTime.now().add(Duration(hours: 9));
  String hour = time.hour.toString();
  String min = time.minute.toString();
  hour.length == 1 ? hour = '0' + hour : null;
  min.length == 1 ? min = '0' + min : null;
  String tmpTime = hour + min;

  int value = int.parse(tmpTime);
  return value;
}

double getPercent(int startTime, int endTime) {
  int period = (endTime - startTime) * 60;
  int value = getCurrentTime() - startTime; // 1357
  int hour = (value ~/ 100) - startTime; // 13 - startTime
  int min = value % 100; // 57

  double percent = (hour*60 + min) / period;
  return percent;

}