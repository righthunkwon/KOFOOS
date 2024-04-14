package com.kofoos.api.history.controller;

import com.kofoos.api.common.dto.HistoryDto;
import com.kofoos.api.entity.History;
import com.kofoos.api.entity.Product;
import com.kofoos.api.history.dto.HistoryProductDto;
import com.kofoos.api.history.service.HistoryService;
import com.kofoos.api.product.dto.ProductDetailDto;
import com.kofoos.api.product.dto.RequestId;
import com.kofoos.api.redis.RedisEntity;
import com.kofoos.api.redis.RedisService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/history")
public class HistoryController {

    private final HistoryService historyService;
    private final RedisService redisService;

    @PostMapping("/sql")
    public ResponseEntity<?> getHistoriesSql(@RequestBody RequestId requestId){
        System.out.println("++++++++++++++Controller deviceId = " + requestId.getDeviceId());
        List<HistoryProductDto> productDetailDtos = historyService.HistoryDetail(requestId.getDeviceId());
        return new ResponseEntity<>(productDetailDtos, HttpStatus.OK);
    }

    @PostMapping("/redis")
    public ResponseEntity<?> getHistoriesRedis(@RequestBody RequestId requestId){
        System.out.println("deviceId = " + requestId.getDeviceId());
        List<Object> histories = redisService.getRecentViewedItems(requestId.getDeviceId());
        return new ResponseEntity<>(histories,HttpStatus.OK);

    }

    @PostMapping("/all")
    public ResponseEntity<?> getHistories(@RequestBody RequestId requestId){

        List<HistoryProductDto> mysql = historyService.HistoryDetail(requestId.getDeviceId());
        List<HistoryProductDto> allList = new ArrayList<>(mysql);
        List<Object> redis = redisService.getRecentViewedItems(requestId.getDeviceId());
        if (redis != null && !redis.isEmpty()) {
            List<HistoryProductDto> redisProducts = redis.stream().map(o -> {
                RedisEntity redisEntity = (RedisEntity) o;
                return HistoryProductDto.builder()
                        .barcode(redisEntity.getBarcode())
//                        .imgurl(redisEntity.getImgUrl())
                        .itemNo(redisEntity.getDeviceId())
                        .build();
            }).collect(Collectors.toList());
            allList.addAll(redisProducts);
        }
        List<HistoryProductDto> userHistories = allList.stream()
                .distinct()
                .collect(Collectors.toList());
        // 날짜별로 정렬 확인필요
        return new ResponseEntity<>(userHistories,HttpStatus.OK);

    }

    @Scheduled(fixedDelay = 300000)
    @Transactional
    public void updateSql(){
        Map<String, List<HistoryProductDto>> redisHistories = redisService.getAllRedisHistories();
        for(String s:redisHistories.keySet()){
            List<HistoryProductDto> keyRedis = redisHistories.get(s);   // 레디스
            List<HistoryDto> histories = historyService.Histories(s);   // sql
            for(HistoryProductDto dto: keyRedis){
                System.out.println("dto.toString() = " + dto.getProductId());
                System.out.println("dto.getUserId() = " + dto.getUserId());
                System.out.println("dto.getCreatedAt() = " + dto.getCreatedAt());
            }
            
            if(keyRedis.size()>=histories.size()){
                for(HistoryDto dto : histories.subList(0,histories.size())){
                    historyService.removeHistory(dto.getId());
                }
                for(HistoryProductDto dto : keyRedis.subList(0,keyRedis.size())){
                    historyService.insert(dto);
                }
            }
            else{
                for(HistoryDto dto : histories.subList(0,keyRedis.size())){
                    historyService.removeHistory(dto.getId());
                }
                for(HistoryProductDto dto : keyRedis.subList(0,keyRedis.size())){
                    historyService.insert(dto);
                }
            }

        }
        System.out.println("++++++++++++++++성공?");
    }


}
