package com.ssafy.ssafytime.jwt;

import com.ssafy.ssafytime.db.entity.User;
import com.ssafy.ssafytime.db.repository.UserRepository;
import jdk.nashorn.internal.parser.Token;
import org.springframework.stereotype.Component;
import org.webjars.NotFoundException;


@Component
public class RefreshTokenValidator {
    private final TokenProvider tokenProvider;
    private final UserRepository userRepository;

    public RefreshTokenValidator(
            final TokenProvider tokenProvider,
            final UserRepository userRepository
    ){
        this.tokenProvider = tokenProvider;
        this.userRepository = userRepository;
    }


    public boolean validate(final String userIdx, String refreshToken){
        final User user = getSavedRefreshToken(userIdx);
        return tokenProvider.validateRefreshToken(refreshToken)&& user.hasSameValue(refreshToken);
    }

    private User getSavedRefreshToken(final String userIdx){
        return userRepository.findByUserEmail(userIdx)
                .orElseThrow(() -> new NotFoundException("리프레수 토큰을 찾을 수 없습니다."));
    }

}
