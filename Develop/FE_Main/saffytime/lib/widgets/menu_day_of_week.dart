import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saffytime/widgets/menu_book_item.dart';
import '../controllers/menu_week_controller.dart';
import 'menu_detail.dart';

class MDay0fWeek extends StatelessWidget {

  MDay0fWeek({Key? key}) : super(key: key);

  MenuPickDayController controller = Get.put(MenuPickDayController());

  @override
  Widget build(BuildContext context) {

    DateTime dt = DateTime.now();
    Map<int, List> dayList = {
      0 : ['월', dt.subtract(Duration(days: dt.weekday - 1)).day.toString()],
      1 : ['화', dt.subtract(Duration(days: dt.weekday - 2)).day.toString()],
      2 : ['수', dt.subtract(Duration(days: dt.weekday - 3)).day.toString()],
      3 : ['목', dt.subtract(Duration(days: dt.weekday - 4)).day.toString()],
      4 : ['금', dt.subtract(Duration(days: dt.weekday - 5)).day.toString()],
    };

    return Obx(() => Column(
        children: [
          Container(
            color: Colors.black12,
            // width: 390,
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int idx = 0; idx < 5; idx ++) ...[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                    width: 76.8,
                    child: InkWell(
                      onTap: () {
                        print('클릭');
                        controller.selectDay(idx);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(dayList[idx]![0], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900,
                                color: (controller.myPick.value == idx ? Color(0xff3396F4) : Color(0x40000000))),),
                          ),
                          Container(
                            child: Text(dayList[idx]![1], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900,
                                color: (controller.myPick.value == idx ? Color(0xff3396F4) : Color(0x40000000))),),
                          ),
                          Container(
                            width: 65,
                            color: (controller.myPick.value == idx ? Color(0xff3396F4) : Color(0x003396F4)),
                            height: 3,
                          )
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(thickness: 1, width: 1, color: Color(0xffC3C6CF)),
                ],
              ],
            ),
          ),

          // 메뉴 카드들 ================================
          Container(
            color: Colors.teal,
            height: 610,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.menuofday.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    openMenuDetail(controller.menuofday[index].id);
                  },
                  child: MIW(
                    imgUrl: controller.menuofday[index].imageUrl,
                    foodKcal: controller.menuofday[index].kcal,
                      mainMenu: controller.menuofday[index].mainMenu,
                      subMenuList: ['깍두기', '단무지'],
                  ),
                );
              }
            )
          )
        ],
      ),
    );
  }
}



