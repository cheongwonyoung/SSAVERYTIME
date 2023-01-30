import 'package:flutter/material.dart';

// 마이 스크린 사진 학번 있는 위젯
class MUI extends StatefulWidget {

  final String imgURL;
  final int studentID;
  final String name;

  const MUI({Key? key,
    required this.name,
    required this.imgURL,
    required this.studentID,}) : super(key: key);

  @override
  State<MUI> createState() => _MUIState();
}

class _MUIState extends State<MUI> {
  @override
  Widget build(BuildContext context) {
    String imgUrl = widget.imgURL;
    String studentID = widget.studentID.toString();
    String name = widget.name;

    return Container(
      width: 390, height: 80,
      color: Colors.black12,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Container(
            child: FittedBox(
              fit: BoxFit.contain,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(imgUrl),),
            ),
          ),
          SizedBox(width: 10,),
          Container(
              child:Text('${studentID} ${name}',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24))
          )
        ],
      ),
    );
  }
}
