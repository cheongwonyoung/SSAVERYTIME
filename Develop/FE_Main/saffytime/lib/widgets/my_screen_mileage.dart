import 'package:flutter/material.dart';

// 마이 스크린 마일리지 위젯
class MMileage extends StatefulWidget {

  final int myMileage;

  const MMileage({Key? key,
    required this.myMileage}) : super(key: key);

  @override
  State<MMileage> createState() => _MMileageState();
}

class _MMileageState extends State<MMileage> {
  @override
  Widget build(BuildContext context) {

    String myMileage = convertMileage(widget.myMileage);

    return Container(
      width: 390, height: 72,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('마일리지', style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.w900),)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(myMileage, style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.w900),),
                SizedBox(width: 8,),
                Text('마일리지', style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.w900),)
              ],
            ),
          )
        ],
      ),
    );
  }
}

// int 30000 -> String 30,000 이렇게 바꾸는 함수
String convertMileage(int money) {
  List tmp = money.toString().split("");
  String res = '';
  int cnt = 1;
  for (int i = tmp.length-1; i > -1; i--) {
    if (cnt > 1 && cnt %3 == 1) {
      res = ',' + res;
    }
    res = tmp[i] + res;
    cnt ++;
  }

  return res;
}