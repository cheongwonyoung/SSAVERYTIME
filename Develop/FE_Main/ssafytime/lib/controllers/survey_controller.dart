import 'dart:developer';

import 'package:get/get.dart';
import 'package:ssafytime/controllers/loading_controller.dart';
import 'package:ssafytime/flutter_survey-0.1.4/models/question_result.dart';
import 'package:ssafytime/models/survey_option_model.dart';
import 'package:ssafytime/models/survey_result_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ssafytime/services/auth_service.dart';

class SurveyController extends GetxController {
  static SurveyController get to => Get.find();

  SurveyController({required this.surveyIdx, required this.surveyTitle});

  final surveyIdx;
  final String surveyTitle;
  final questions = <SurveyOption>[].obs;
  final surveyResult = <SurveyResult>[];
//   final answerResultList = [];
  final answerIdxList = [].obs;
  final questionIdxList = [].obs;
  final Map<String, int> answerIdxMap = {};

  @override
  void onInit() {
    log("SurveyController : ${Get.arguments}");
    setSurveyOptions();
    super.onInit();
    loadingController.to.setIsLoading(false);
  }

  Future<void> setSurveyOptions() async {
    var response = await http.get(Uri.parse(
        "http://i8a602.p.ssafy.io:9090/surveys/survey/questions/$surveyIdx"));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      //   log("print : " + data.toString());
      var questionList =
          List<SurveyOption>.from(data.map((x) => SurveyOption.fromJson(x)));
      questionList.sort((a, b) => a.questionIdx.compareTo(b.questionIdx));
      questionList.forEach((element) {
        questionIdxList.add(element.questionIdx);
      });
      questions.addAll(questionList);
      questions.forEach((e) {
        e.optionList.forEach((option) {
          answerIdxMap[option.optionContent] = option.id;
        });
      });
      var tmp = Map.fromIterable(questions[0].optionList,
          key: (e) => e.optionContent, value: (e) => null);
      log("print : " + tmp.toString());
      questions.refresh();
      log("print : " + questions[0].optionList[0].optionContent);
      log("answer Map : ${answerIdxMap}");
    }
  }

  Future<String> sendSurveyResult(List<QuestionResult> result) async {
    // result.forEach((element) {
    //   List<String> answerResultList = [];
    //   element.answers.forEach((e) {
    //     if (answerIdxMap.containsKey(e)) {
    //       answerResultList.add("${answerIdxMap[e]}");
    //     } else {
    //       answerResultList.add(e);
    //     }
    //   });
    //   log("answers : $answerResultList");
    // });

    result.asMap().forEach((index, element) {
      surveyResult.add(SurveyResult(
          questionId: questionIdxList[index],
          response: element.answers.length > 1 ? "" : element.answers[0]));
    });

    var res = await http.post(
        Uri.parse(
            "http://i8a602.p.ssafy.io:9090/surveys/survey/answers/${surveyIdx}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${AuthService.to.accessToken.value}"
        },
        body: json.encode(surveyResult));

    if (res.statusCode == 200) {
      var resConduct = await http.post(
          Uri.parse(
              "http://i8a602.p.ssafy.io:9090/surveys/survey/conduct/${surveyIdx}"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${AuthService.to.accessToken.value}"
          });
      if (resConduct.statusCode == 200) {
        Get.back();
        return "설문조사 전송 성공";
      } else {
        return "설문조사 전송 실패";
      }
    } else {
      return "설문조사 전송 실패";
    }
  }
}
