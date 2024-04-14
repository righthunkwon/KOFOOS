//package com.kofoos.api.config;
//
//import org.springframework.context.annotation.Configuration;
//import org.springframework.web.servlet.config.annotation.CorsRegistry;
//import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
//
//@Configuration
//public class CorsConfig implements WebMvcConfigurer {
//
//    @Override
//    public void addCorsMappings(CorsRegistry registry) {
//        registry.addMapping("/**")
//                .allowedMethods("GET","POST")
//                .allowedOrigins("http://192.168.1.94:8080").allowedHeaders("*")
//                .allowCredentials(true)
//                .maxAge(3000);
//    }
//}
