package com.ssafy.ssafytime.api.controller;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Notification;
import com.ssafy.ssafytime.api.firebase.MessageDTO;
import com.ssafy.ssafytime.api.service.AlarmDefaultService;
import com.ssafy.ssafytime.api.service.MeetService;
import com.ssafy.ssafytime.db.dto.MeetInfoDto;
import com.ssafy.ssafytime.db.entity.MeetList;
import com.ssafy.ssafytime.db.repository.AlarmDefaultRepository;
import com.ssafy.ssafytime.db.repository.MeetListRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/meet")
public class MeetController {

    @Autowired
    AlarmDefaultService alarmDefaultService;

    @Autowired
    AlarmDefaultRepository alarmDefaultRepository;
    private final MeetService meetService;
    private final MeetListRepository meetListRepository;

    public MeetController(MeetService meetService,
                          MeetListRepository meetListRepository){
        this.meetService = meetService;
        this.meetListRepository = meetListRepository;
    }

    // 회원번호로 한명의 회원 조회
    // code값이 0이면 교육생 1이면 매니저
    @GetMapping(value = "/{userId}/{code}", produces = { MediaType.APPLICATION_JSON_VALUE }) // 요청을 json type의 데이터만 담고 있는 요청 처리
    public ResponseEntity<List<MeetInfoDto>> getMember(@PathVariable("userId") Long userId, @PathVariable("code") int code) {

        // 본인의 상담 예약 정보 리스트
        List<MeetInfoDto> member = null;

        // 교육생
        if(code==0){
            // Optional : 'null일 수도 있는 객체'를 감싸는 일종의 Wrapper 클래스
            member = meetService.findAllByStudentId_UserIdx(userId);

        }
        // 관리자
        else if(code==1){
            // Optional : 'null일 수도 있는 객체'를 감싸는 일종의 Wrapper 클래스
            member = meetService.findAllByManagerId_UserIdx(userId);

        }

        return new ResponseEntity(member, HttpStatus.OK);
    }

    // 거절사유 등록 ( 매니저가 등록 )
    // rez_idx는 예약된 상담의 번호, reject는 거절 사유
    @PutMapping("/update/reject")
    public ResponseEntity<String> putReject(@RequestParam("rez_idx") Long rezIdx, @RequestParam("reject") String reject) throws FirebaseMessagingException {

        // 예약된 상담의 정보 가져오기
        MeetList member = meetService.findByRezIdx(rezIdx);
        // 상태 ( 1(대기중) -> 3(거절) )
        member.setState(3L);
        // 거절사유 등록
        member.setReject(reject);
        meetService.update(member);


        Double doubleTime = 0.0;  // 상담 알림 메시지 위함
        String time = null;
        if(member.getRezTime()%1.0 == 0.5)  // 시간이 16.5 면 16:30으로 바꾸게!
            time = String.valueOf(doubleTime) + ":30";
        else
            time = String.valueOf(doubleTime) + ":00";

        // 알림 보내기
        MessageDTO messageDTO = MessageDTO.builder().title("상담 알림").body(member.getRezDate() + " " + time + " 상담 거절됨").build();  // 알림에 넣을 인자들
        List<String> registrationTokens = alarmDefaultService.getUserTokens(3, messageDTO);  // 1 : 설문, 2 : 공지 , 3: 상담 으로 설정하여 알림보낼 유저들 토큰 얻는 함수
        Notification notification = Notification.builder().setTitle(messageDTO.getTitle()).setBody(messageDTO.getBody()).setImage(null).build();  // 없으면 알림 안보내짐
        Integer FailedAlarmCnt = alarmDefaultService.sendMultiAlarms(notification, registrationTokens);
        return ResponseEntity.ok().body("FailedAlarmCnt : " + FailedAlarmCnt);
    }

    // 상담승인 등록 ( 매니저가 등록 )
    // rez_idx는 예약된 상담의 번호
    @PutMapping("/update/accept")
    public ResponseEntity<String> putAccept(@RequestParam("rez_idx") Long rezIdx) throws FirebaseMessagingException {

        // 예약된 상담의 정보 가져오기
        MeetList member = meetService.findByRezIdx(rezIdx);
        // 상태 ( 1(대기중) -> 2(승인) )
        member.setState(2L);
        meetService.update(member);

        Double doubleTime = 0.0;  // 상담 알림 메시지 위함
        String time = null;
        if(member.getRezTime()%1.0 == 0.5)  // 시간이 16.5 면 16:30으로 바꾸게!
            time = String.valueOf(doubleTime) + ":30";
        else
            time = String.valueOf(doubleTime) + ":00";

        // 알림 보내기
        MessageDTO messageDTO = MessageDTO.builder().title("상담 승인 알림").body(member.getRezDate() + " " + time + " 상담 거절됨").build();  // 알림에 넣을 인자들
        List<String> registrationTokens = alarmDefaultService.getUserTokens(3, messageDTO);  // 1 : 설문, 2 : 공지 , 3: 상담 으로 설정하여 알림보낼 유저들 토큰 얻는 함수
        Notification notification = Notification.builder().setTitle(messageDTO.getTitle()).setBody(messageDTO.getBody()).setImage(null).build();  // 없으면 알림 안보내짐
        Integer FailedAlarmCnt = alarmDefaultService.sendMultiAlarms(notification, registrationTokens);
        return ResponseEntity.ok().body("FailedAlarmCnt : " + FailedAlarmCnt);
    }

}