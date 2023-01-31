package com.ssafy.ssafytime.repository;

import com.ssafy.ssafytime.domain.schedule.ScheduleEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ScheduleRepository extends JpaRepository<ScheduleEntity, Long> {
//    List<ScheduleEntity> findScheduleEntityByDateAndStartTimeGreaterThanAndEndTimeLessThan(String date, String startTime, String endTime);
    List<ScheduleEntity> findByTrackCodeAndDateAndStartTimeLessThanAndEndTimeGreaterThan(int trackCode, String date, int startTime, int endTime);
}
