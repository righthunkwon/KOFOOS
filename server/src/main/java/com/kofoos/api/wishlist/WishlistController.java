package com.kofoos.api.wishlist;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kofoos.api.entity.Product;
import com.kofoos.api.image.controller.ImageController;
import com.kofoos.api.image.service.ImageService;
import com.kofoos.api.product.dto.ProductDetailDto;
import com.kofoos.api.product.service.ProductService;
import com.kofoos.api.wishlist.dto.FolderDto;
import com.kofoos.api.wishlist.dto.ProductDto;
import com.kofoos.api.common.dto.WishlistFolderDto;
import com.kofoos.api.wishlist.dto.WishlistDto;
import org.springframework.expression.ParseException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/wishlist")
public class WishlistController {


    private WishlistService wishlistService;
    private ImageService imageService;

    private ProductService productService;



    public WishlistController(WishlistService wishlistService, ImageService imageService, ProductService productService) {

        this.wishlistService = wishlistService;
        this.imageService = imageService;
        this.productService = productService;
    }

    @ResponseBody
    @PostMapping("/product/like")
    public ResponseEntity<Map<String, Object>> likeProduct(@RequestBody Map<String, Object> req)
            throws ParseException {
        Map<String, Object> result = new HashMap<String, Object>();

        int productId = (Integer) req.get("productId");
        String deviceId = (String)  req.get("deviceId");

        System.out.println("========="+productId);

        wishlistService.like(productId,deviceId);


        //ok상태코드 리턴
        return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);
    }

    @ResponseBody
    @PostMapping("/product/unlike")
    public ResponseEntity<Map<String, Object>> unlikeProduct(@RequestBody Map<String, Object> req)
            throws ParseException {
        Map<String, Object> result = new HashMap<>();
        int productId = (Integer) req.get("productId");
        String deviceId = (String) req.get("deviceId");
        System.out.println("Product ID to unlike: " + productId);
        wishlistService.unlike(productId, deviceId);

        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @ResponseBody
    @PostMapping("/product/cancel")
    public ResponseEntity<Map<String, Object>> cencelLikeProduct(@RequestBody Map<String, Object> req)
            throws ParseException {
        Map<String, Object> result = new HashMap<String, Object>();

        List<Integer> itemIds = (List<Integer>) req.get("wishlistItemIds");
        String deviceId = (String)  req.get("deviceId");

        System.out.println("[ 좋아요 취소 ("+ itemIds.toString()+" )]");

        wishlistService.cancel(itemIds);


        //ok상태코드 리턴
        return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);
    }


    @ResponseBody
    @PostMapping("/product/check")
    public ResponseEntity<Map<String, Object>> checkBought(@RequestBody Map<String, Object> req)
            throws ParseException {
        Map<String, Object> result = new HashMap<String, Object>();

        List<Integer> itemIds = (List<Integer>) req.get("wishlistItemIds");
        int bought = (Integer)  req.get("bought");
        String deviceId = (String)req.get("deviceId");

        System.out.println("[ 구매여부 체크 ("+itemIds.toString()+" / "+ bought + " )]");

        wishlistService.check(itemIds,bought);


        //ok상태코드 리턴
        return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);
    }

    @ResponseBody
    @PostMapping("/folder/create")
    public ResponseEntity<Map<String, Object>> createFolder(@RequestBody Map<String, Object> req)
            throws ParseException {
        Map<String, Object> result = new HashMap<String, Object>();

        String folderName = (String) req.get("wishlist_folderName");
        String deviceId = (String)  req.get("deviceId");

        System.out.println("[ 폴더 생성 ("+folderName+" / "+ deviceId + " )]");

        wishlistService.create(folderName,deviceId);


        //ok상태코드 리턴
        return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);
    }

    @ResponseBody
    @PostMapping("/folder/delete")
    public ResponseEntity<Map<String, Object>> deleteFolder(@RequestBody Map<String, Object> req)
            throws ParseException {
        Map<String, Object> result = new HashMap<String, Object>();

        Integer folderId = (Integer) req.get("wishlist_folderId");
        String deviceId = (String)  req.get("deviceId");

        System.out.println("[ 폴더 삭제 ("+folderId+" / "+ deviceId + " )]");

        wishlistService.delete(folderId,deviceId);


        //ok상태코드 리턴
        return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);
    }
    @ResponseBody
    @PostMapping("/folder/list")
    public ResponseEntity<Map<String, Object>> findFolderList(@RequestBody Map<String, Object> req)
            throws ParseException, JsonProcessingException {
        Map<String, Object> result = new HashMap<String, Object>();

        String deviceId = (String)  req.get("deviceId");

        System.out.println("[ 폴더 리스트 조회 ( deviceId : "+deviceId +")]");

       List<FolderDto> folderList =  wishlistService.findFolderList(deviceId);

        System.out.println("[결과]"+folderList.toString());

        result.put("folderList", folderList);
        //ok상태코드 리턴
        return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);
    }

    @ResponseBody
    @PostMapping("/folder/move")
    public ResponseEntity<Map<String, Object>> moveItems(@RequestBody Map<String, Object> req)
            throws ParseException, JsonProcessingException {
        Map<String, Object> result = new HashMap<String, Object>();

        List<Integer> items = (List<Integer>) req.get("wishlistItemId");
        int folderId = (Integer) req.get("wishlistFolderId");

        System.out.println("[ 폴더 이동 ( folderId : "+folderId +"/"+items.toString()+")]");

        wishlistService.moveItems(items,folderId);

        //ok상태코드 리턴
        return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);
    }

    @PostMapping("/detection/insert")
    public ResponseEntity<Map<String, Object>> saveImageUploadItem(@RequestPart("file") MultipartFile file, @RequestParam("deviceId") String deviceId, @RequestParam("itemNo") String itemNo) throws ParseException, IOException {
        Map<String, Object> result = new HashMap<String, Object>();

        System.out.println("/detection/insert!!!");
        int imageId = imageService.saveImage(file,itemNo);

        System.out.println("이미지 id: "+ imageId);

        System.out.println("디바이스 id: "+deviceId);


        int productId = 999999999;
        System.out.println("아이템 No: "+itemNo);

        Product productByItemNo = null;
        if(itemNo != null){
            Optional<Product> productByItemNoOrNone = productService.findProductByItemNoOrNone(itemNo);
            if (productByItemNoOrNone.isPresent()){
                productByItemNo = productByItemNoOrNone.get();
                System.out.println("product 엔티티: " +productByItemNo.toString());
                productId = productByItemNo.getId();
            }

        }

        System.out.println("상품 id: "+productId);
        // wishlist_folder_id, product_id, image_id, bought=0
        wishlistService.insertImage(deviceId,productId,imageId);

        //ok상태코드 리턴
        return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);
    }


}