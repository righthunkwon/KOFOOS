package com.kofoos.api.product.controller;

import com.kofoos.api.User.UserService;
import com.kofoos.api.common.dto.ProductDto;
import com.kofoos.api.entity.Product;
import com.kofoos.api.product.dto.ProductBoxDto;
import com.kofoos.api.product.dto.ProductDetailDto;
import com.kofoos.api.product.dto.RequestId;
import com.kofoos.api.product.service.CategoryService;
import com.kofoos.api.product.service.ProductService;
import com.kofoos.api.redis.RedisEntity;
import com.kofoos.api.redis.RedisService;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/products")
@Slf4j
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;
    private final CategoryService categoryService;
    private final RedisService redisService;
    private final UserService userService;


    // 상품 조회 바코드
    @GetMapping("/detail/{barcode}")
    public ResponseEntity<?> findProductDetailBarcode(@PathVariable String barcode){
        ProductDetailDto productDetailDto = productService.findProductByBarcode(barcode);
        return new ResponseEntity<>(productDetailDto, HttpStatus.OK);
    }

    // 상품 조회 아이템번호
    @GetMapping("/detail/no/{ItemNo}/{deviceId}")
    public ResponseEntity<?> findProductDetailItemNo(@PathVariable String ItemNo,@PathVariable String deviceId){
        ProductDetailDto productDetailDto = productService.findProductByItemNo(ItemNo);
        int userId = userService.getUserId(deviceId);
        RedisEntity redisEntity = RedisEntity.builder()
                .barcode(productDetailDto.getBarcode())
                .createdAt(LocalDateTime.now())
                .name(productDetailDto.getName())
                .imgUrl(productDetailDto.getImgurl())
                .deviceId(deviceId)
                .productId(productDetailDto.getProductId())
                .userId(userId)
                .imgUrl(productDetailDto.getImgurl())
                .itemNo(productDetailDto.getItemNo())
                .build();
        redisService.addRecentViewedItem(deviceId,redisEntity);
        return new ResponseEntity<>(productDetailDto, HttpStatus.OK);
    }

    // 카테고리 2 조회(카테고리 1선택)
    @GetMapping("/category/{cat1}")
    public ResponseEntity<?> getCat2(@PathVariable String cat1){
        List<String> cat2List = categoryService.findCat2(cat1);
        return new ResponseEntity<>(cat2List,HttpStatus.OK);
    }

    // 카테고리 3 조회 (카테고리 3 선택)
    @GetMapping("/category")
    public ResponseEntity<?> getCat3(@RequestParam String cat1,@RequestParam String cat2){
        List<String> cat3List = categoryService.findCat3(cat1,cat2);
        return new ResponseEntity<>(cat3List,HttpStatus.OK);
    }

    // 카테고리 랭킹
    @GetMapping("/category/ranking")
    public ResponseEntity<?> ranking(){
        List<String> rankList = categoryService.ranking();
        return new ResponseEntity<>(rankList,HttpStatus.OK);
    }

//    @PutMapping("/test")
//    public void test() throws IOException {
//        productService.updateGptTag();
//    }

    // 상품 검색 및 정렬
    @GetMapping("/list")
    public ResponseEntity<?> findProductsOrder(@RequestParam String cat1,@RequestParam String cat2, @RequestParam String order){
        System.out.println("cat1 = " + cat1);
        List<Integer> id = categoryService.findId(cat1,cat2);
        List<ProductBoxDto> Dtos = new ArrayList<>();
        for(int i :id){
            List<ProductBoxDto> temp = productService.findProductsOrder(i,order);
            for(ProductBoxDto p: temp){
                Dtos.add(p);
            }
        }
        Dtos.sort(ProductBoxDto::compareTo);
        return new ResponseEntity<>(Dtos,HttpStatus.OK);
    }

    // like




}
