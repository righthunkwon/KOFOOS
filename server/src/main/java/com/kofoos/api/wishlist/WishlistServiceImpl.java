package com.kofoos.api.wishlist;

import com.kofoos.api.repository.*;
import com.kofoos.api.wishlist.dto.FolderDto;
import com.kofoos.api.wishlist.dto.ProductDto;
import com.kofoos.api.entity.*;
import com.kofoos.api.wishlist.dto.WishlistDetectionDto;
import com.kofoos.api.wishlist.dto.WishlistDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class WishlistServiceImpl implements WishlistService {
    final private WishlistRepository wishlistRepository;
    final private FolderRepository folderRepository;
    final private UserRepository userRepository;
    final private ProductRepository productRepository;

    final private ImageRepository imageRepository;
    final String DEFAULT = "default";


    @Override
    @Transactional
    public void like(int id, String deviceId) {

        User currentUser = userRepository.findUserIdByDeviceId(deviceId);
        System.out.println("==============" + currentUser.getId());

        WishlistFolder folder = folderRepository.findFolderByUserIdAndName(currentUser.getId(), DEFAULT);
        // System.out.println("폴더 id: " + folder.getId());

        if (folder == null) {
            WishlistFolder newfolder = WishlistFolder.builder()
                    .name(DEFAULT)
                    .user(currentUser)
                    .build();

            folder = folderRepository.save(newfolder);

        }

        Optional<Product> productById = productRepository.findById(id);
        Product currentProduct = productById.orElseThrow(() -> new IllegalArgumentException("Product not found"));

        Optional<WishlistItem> existWishlistItem = wishlistRepository.findWishlistItemByWishlistFolderIdAndProductId(id, folder.getId());

        if (!existWishlistItem.isPresent()) {
            WishlistItem wishlistItem = WishlistItem.builder()
                    .product(currentProduct)
                    .wishlistFolder(folder)
                    .image(currentProduct.getImage())
                    .bought(0)
                    .build();
            productRepository.upLike(currentProduct.getId());
            wishlistRepository.save(wishlistItem);
            System.out.println("Product " + id + " added to wishlist");
        } else {
            System.out.println("Product " + id + " already in wishlist");
        }

    }

    @Override
    @Transactional
    public void unlike(int id, String deviceId) {

        User currentUser = userRepository.findUserIdByDeviceId(deviceId);
        System.out.println("User ID: " + currentUser.getId());
        WishlistFolder folder = folderRepository.findFolderByUserIdAndName(currentUser.getId(), DEFAULT);

        if (folder == null) {
            throw new IllegalArgumentException("Default wishlist folder not found");
        }
        System.out.println("folder.getId() = " + folder.getId());
        System.out.println("id = " + id);
        Optional<WishlistItem> wishlistItem = wishlistRepository.findWishlistItemByWishlistFolderIdAndProductId(id, folder.getId());

        if (wishlistItem.isPresent()) {
            productRepository.downLike(wishlistItem.get().getProduct().getId());
            wishlistRepository.delete(wishlistItem.get());
        } else {
            throw new IllegalArgumentException("Wishlist item not found");
        }
    }


    @Transactional
    @Override
    public void moveItems(List<Integer> itemIds, int targetFolderId) {
        for (int itemId : itemIds) {
            wishlistRepository.updateFolderId(itemId, targetFolderId);
        }
    }

    @Transactional
    @Override
    public void cancel(List<Integer> itemIds) {
        for (Integer itemId : itemIds) {
            wishlistRepository.deleteById(itemId);

        }
    }

    // 채팅으로 칠게

    @Override
    public void create(String folderName, String deviceId) {

        User currentUser = userRepository.findUserIdByDeviceId(deviceId);

        WishlistFolder newFolder = WishlistFolder.builder()
                .name(folderName)
                .user(currentUser)
                .build();

        folderRepository.save(newFolder);
    }

    @Override
    public void delete(Integer folderId, String deviceId) {

        folderRepository.deleteById((folderId));

    }

    @Override
    public List<FolderDto> findFolderList(String deviceId) {

        User user = userRepository.findUserIdByDeviceId(deviceId);
        List<FolderDto> folders = folderRepository.findFolderByUserId(user.getId());

        for (FolderDto folder : folders) {
            folder.setItems(wishlistRepository.findProductsByFolderId(folder.getFolderId()));
        }

        return folders;
    }


    @Override
    public List<WishlistDto> findFolder(int folderId) {
        return wishlistRepository.findProductsByFolderId(folderId);
    }

    @Transactional
    @Override

    public void check(List<Integer> itemIds, int bought) {
        for (int wishlistItemId : itemIds) {

            int result = wishlistRepository.updateBought(wishlistItemId, bought);

            System.out.println("업데이트 결과: " + result);
        }

    }

    @Override
    public int findDefaultFolderId(String deviceId) {
        User user = userRepository.findUserIdByDeviceId(deviceId);

        WishlistFolder folder = folderRepository.findFolderByUserIdAndName(user.getId(), "default");


        return folder.getId();
    }

    @Override
    public void insertImage(String deviceId, int id, int imageId) {


        User currentUser = userRepository.findUserIdByDeviceId(deviceId);
        System.out.println("==============" + currentUser.getId());
        Optional<Image> byId = imageRepository.findById(imageId);
        Image image = byId.get();
        WishlistFolder folder = folderRepository.findFolderByUserIdAndName(currentUser.getId(), DEFAULT);
        Optional<Product> p = productRepository.findById(id);
        Product product;
        WishlistItem wishlistItem;
        if (!p.isPresent()) {
            wishlistItem = WishlistItem.builder()
                    .image(image)
                    .wishlistFolder(folder)
                    .bought(0)
                    .build();

        } else {
            product = p.get();
            wishlistItem = WishlistItem.builder()
                    .image(image)
                    .wishlistFolder(folder)
                    .bought(0)
                    .product(product)
                    .build();
        }

        wishlistRepository.save(wishlistItem);





    }


}
