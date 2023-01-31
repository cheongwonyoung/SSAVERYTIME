// check calendar screen

import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CalendarScreenStates();
}

class _CalendarScreenStates extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [Text("CalendarScreen")],
      ),
    );
  }
}