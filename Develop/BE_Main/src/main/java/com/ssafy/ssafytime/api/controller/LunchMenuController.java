package com.ssafy.ssafytime.api.controller;


import com.ssafy.ssafytime.service.LunchMenuServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
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
    public List<HashMap<String, Object>> todayMenu(@RequestParam("region") int region) {
        System.out.printf("0 %d%n", region);
        List<HashMap<String, Object>> menu = lunchMenuService.getTodayMenu(region);
        return menu;
    }

    @GetMapping("menu/week")
    public HashMap<String, List<HashMap<String, Object>>> WeekMenu(@RequestParam("region") int region) {
        HashMap<String, List<HashMap<String, Object>>> menu = lunchMenuService.getWeekMenu(region);
        return menu;
    }
}