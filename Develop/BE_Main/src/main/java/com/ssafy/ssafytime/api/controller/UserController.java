package com.ssafy.ssafytime.api.controller;

//import com.ssafy.ssafytime.api.dto.AttendanceDto;
//import com.ssafy.ssafytime.api.dto.AttendanceDto;
import com.ssafy.ssafytime.api.dto.FCMTokenDTO;
import com.ssafy.ssafytime.api.dto.UserDto;
import com.ssafy.ssafytime.api.request.SurveyRegisterPostReq;
import com.ssafy.ssafytime.api.service.UserService;
//import com.ssafy.ssafytime.db.entity.AttendanceId;
import com.ssafy.ssafytime.common.model.response.BaseResponseBody;
import com.ssafy.ssafytime.db.entity.User;
import io.swagger.annotations.ApiParam;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import springfox.documentation.annotations.ApiIgnore;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.Optional;

@RestController
@RequestMapping("/user")
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/signup")
    public ResponseEntity<UserDto> signup(
            @Valid @RequestBody UserDto userDto
    ) {
        return ResponseEntity.ok(userService.signup(userDto));
    }

    @GetMapping("/my-page")
    @PreAuthorize("hasAnyRole('USER','ADMIN')")
    public ResponseEntity<UserDto> getMyUserInfo(HttpServletRequest request) {
        return ResponseEntity.ok(userService.getMyUserWithAuthorities());
    }

    @GetMapping("/user/{username}")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public ResponseEntity<UserDto> getUserInfo(@PathVariable String username) {
        return ResponseEntity.ok(userService.getUserWithAuthorities(username));
    }

    @PostMapping("/alarm")
    public ResponseEntity<? extends BaseResponseBody> saveFCMToken(@RequestBody @ApiParam(value="FCM 토큰", required = true) FCMTokenDTO fcmTokenDTO, @ApiIgnore Authentication authentication) {
        UserDto userDto = userService.getMyUserWithAuthorities();  // jwt 토큰을 통해 DTO불러옴
        Optional<User> user = userService.findById(userDto.getId());  // DTO 통해 User 엔티티 불러옴
        if (user.isPresent()) {  // 유저가 존재한다면
            if (userDto.getToken() == null || userDto.getToken() != fcmTokenDTO.getFCMToken()) {  // 해당 사용자가 FCM 토큰이 없다면
                user.get().setToken(fcmTokenDTO.getFCMToken());  // 토큰 설정해서
                userService.save(user);  // 저장
            }
            return ResponseEntity.ok().body(BaseResponseBody.of(200, "Success"));
        } else {
            return ResponseEntity.ok().body(BaseResponseBody.of(401, "no user"));
        }
    }

//    @GetMapping("/attendance")
//    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
//    public ResponseEntity<AttendanceDto> getAttendance(HttpServletRequest request) {
//        Long userIdx = userService.getMyUserWithAuthorities().getUserIdx();
//        System.out.println(userIdx);
//
//        System.out.println("-----------------------여기까지는 됨---------------------");
//        return ResponseEntity.ok(userService.getAttendances(userIdx));
//    }
}


