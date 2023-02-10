package com.ssafy.ssafytime.db.dto;

import com.ssafy.ssafytime.db.entity.AlarmDefault;
import com.ssafy.ssafytime.db.entity.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/* 기본(공지사항, 상담, 설문조사) 알림 생성 & on/off 상태 변경 DTO(develop_AJH) */
@Getter
@Setter
@NoArgsConstructor
public class AlarmDefaultRequestDto {
    private Long id;
    private User user;
    private Boolean noticeAlarm;
    private Boolean surveyAlarm;
    private Boolean consultingAlarm;

    @Builder
    public AlarmDefaultRequestDto(Long id, User user, Boolean noticeAlarm, Boolean surveyAlarm, Boolean consultingAlarm) {
        this.id = id;
        this.user = user;
        this.noticeAlarm = noticeAlarm;
        this.surveyAlarm = surveyAlarm;
        this.consultingAlarm = consultingAlarm;
    }

    public AlarmDefault toEntity() {
        return AlarmDefault.builder().id(id).user(user).noticeAlarm(noticeAlarm).surveyAlarm(surveyAlarm).consultingAlarm(consultingAlarm).build();
    }
}
