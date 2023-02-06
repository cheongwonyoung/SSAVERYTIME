package com.ssafy.ssafytime.api.controller;


import com.ssafy.ssafytime.db.dto.lunchMenu.LunchMenuResponseDto;
import com.ssafy.ssafytime.exception.ResponseHandler;
import com.ssafy.ssafytime.api.service.lunchMenu.LunchMenuServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;

@RestController
public class LunchMenuController {

    @Autowired
    LunchMenuServiceImpl lunchMenuService;

    @GetMapping("menu/today")
    public ResponseEntity<Object> todayMenu(@RequestParam("region") int region) {
        List<LunchMenuResponseDto> menu = lunchMenuService.getTodayMenu(region);
        if (!menu.isEmpty())
            return ResponseHandler.generateResponse(true, "OK", HttpStatus.OK, lunchMenuService.getTodayMenu(region));
        else
            return ResponseHandler.generateResponse(false, "EMPTY", HttpStatus.NOT_FOUND, null);
    }

    @GetMapping("menu/week")
    public ResponseEntity<Object> WeekMenu(@RequestParam("region") int region) {
        HashMap<Integer, List<LunchMenuResponseDto>> menu = lunchMenuService.getWeekMenu(region);
        if (!menu.isEmpty())
            return ResponseHandler.generateResponse(true, "OK", HttpStatus.OK, lunchMenuService.getWeekMenu(region));
        else
            return ResponseHandler.generateResponse(false, "EMPTY", HttpStatus.NOT_FOUND, null);
    }

    @GetMapping("menu/detail")
    public ResponseEntity<Object> menuDetail(@RequestParam("id") Long id) {
        return ResponseHandler.generateResponse(true, "OK", HttpStatus.OK, lunchMenuService.getMenuDetail(id));
    }
}