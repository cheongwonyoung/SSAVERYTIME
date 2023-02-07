package com.ssafy.ssafytime.api.firebase;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import lombok.Value;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.InputStream;
@Component
@Slf4j
public class FCMInitializer {

//    @Value("${firebase/ssafytime-firebase-adminsdk-uq8xh-c0ce82262a.json}")
//    private String credential;

    @PostConstruct
    public void initialize(){
        ClassPathResource resource = new ClassPathResource("firebase/ssafytime-firebase-adminsdk-uq8xh-c0ce82262a.json");

        try (InputStream stream = resource.getInputStream()) {
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(stream))
                    .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                log.info("FirebaseApp initialization complete");
            }
        }catch (Exception e){
            e.printStackTrace();
//            throw new ApiException(ExceptionEnum.INTERNAL_SERVER_ERROR);
        }

    }
}