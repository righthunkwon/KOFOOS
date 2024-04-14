package com.kofoos.api.recommendation.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.Scheduled;

import java.util.Random;

@Configuration
public class RecommendationConfig {
    private Integer randomSeed = 0;

    @Scheduled(fixedDelay=1000*60*60*24*3)
    private void setRandomSeed(){
        Random random = new Random();
        this.randomSeed = random.nextInt(1000);
    }

    @Bean
    public Integer randomSeed(){
        return randomSeed;
    }
}
