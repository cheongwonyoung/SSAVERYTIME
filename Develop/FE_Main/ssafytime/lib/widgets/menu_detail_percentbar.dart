import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:ssafytime/widgets/custom_text.dart';

class MDetailPercentBar extends StatelessWidget {
  
  final String title;
  final int amount; // 현재 양
  final int total;
  final String unit; // 단위

  
  const MDetailPercentBar({Key? key,
    this.title = 'no data',
    this.amount = 0,
    this.total = 1000,
    this.unit = 'g'
  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.teal,
      // width: 42,
      width:63,
      height: 190,
      child: Column(
        children: [
          CustomText(content: title, fontSize: 11,),
          SizedBox(height: 4,),
          Container(
            width: 20,
            height: 150,
            child: FAProgressBar(
              direction: Axis.vertical,
              verticalDirection: VerticalDirection.up,
              animatedDuration: Duration(milliseconds: 1000),
              backgroundColor: Color(0xffD6D6D6),
              // currentValue: NutritionTable().getPercent(amount, total),
              currentValue: (amount*100 ~/ total).toDouble(),
            ),
          ),
          SizedBox(height: 4,),
          CustomText(content: '${amount}${unit}', fontSize: 10.5,)
        ],
      ),
    );
  }
}


// 영양 성분 테이블
class NutritionTable {
  // 탄 단 지 = 45 : 15 : 40
  // 하루 2200kcal 섭취 기준 = 990 330 880 -> 248g : 83g : 220g
  // 나트륨 3000mg 기준
  Map table = {
    'cho' : 248,
    'pro' : 83,
    'fat' : 97,
    'salt' : 3000,
    'kcal' : 2200,
  };

  double getPercent(int value, int total) {
    return (value / total)*100;
  }

}