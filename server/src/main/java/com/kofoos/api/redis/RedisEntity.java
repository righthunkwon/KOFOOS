package com.kofoos.api.redis;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Builder;
import lombok.Getter;
import org.springframework.data.redis.core.RedisHash;

import java.time.LocalDateTime;

@Getter
@Builder
@RedisHash(value = "product", timeToLive = 30)
public class RedisEntity {

    private String barcode;
    private String name;
    private LocalDateTime createdAt;
    private String imgUrl;
    private String deviceId;
    private String itemNo;
    private int productId;
    private int userId;


}
