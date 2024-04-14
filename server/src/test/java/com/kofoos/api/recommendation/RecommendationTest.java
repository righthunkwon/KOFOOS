//package com.kofoos.api.recommendation;
//
//import com.kofoos.api.entity.Product;
//import com.kofoos.api.repository.ProductRepository;
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
//import org.springframework.boot.test.context.SpringBootTest;
//
//
//import java.util.List;
//import java.util.stream.IntStream;
//
//import static org.junit.jupiter.api.Assertions.*;
//
//@SpringBootTest
//@AutoConfigureMockMvc
//public class RecommendationTest {
//
//    @Autowired
//    ProductRepository pr;
//
//    @Test
//    @DisplayName("[상품페이지] 유사한 상품 추천")
//    public void 같은카테고리내의제품을좋아요순으로10개이하로추천하는가(){
//        // 해태포키
//        // product_id: 1163, category: 59
//        final int productId = 1163;
//        final String cat1 = "Snack/Chocolate/Cereal";
//        final String cat2 = "Snack";
//        List<Product> result = pr.findRelatedProductsOrderByLike(cat1, cat2);
//        int len = result.size();
//
//        // 10개이하인가
//        assertTrue(len < 11);
//
//        //좋아요 숫자가 내림차순으로 정렬되어 있는가?
//        assertTrue(IntStream.range(1, len).allMatch(i->result.get(i).getLike() <= result.get(i-1).getLike()) );
//
//        // 같은 카테고리 내에 있는가
//        assertTrue(result.stream().allMatch(product -> product.getCategory().getCat2().equals("Snack")));
//    }
//
//    @Test
//    @DisplayName("[메인 페이지] 인기순 + 조회순 추천")
//    public void 현재인기있는상품10개이하추천하는가(){
//        List<Product> result = pr.findHotProductsOrderByLikeAndHit();
//        int len = result.size();
//
//        // 10개이하인가
//        assertTrue(len < 11);
//
//        // 스코어가 내림차순으로 정렬되어 있는가?
//        assertTrue(IntStream.range(1, len)
//                .allMatch(i->( (result.get(i).getLike()*0.7+result.get(i).getHit()*0.3)
//                        <= (result.get(i-1).getLike()*0.7 + result.get(i).getHit()*0.3)
//                )));
//    }
//
//}
