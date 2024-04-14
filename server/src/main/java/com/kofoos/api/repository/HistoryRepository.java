package com.kofoos.api.repository;

import com.kofoos.api.entity.History;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

public interface HistoryRepository extends JpaRepository<History, Integer> {
    List<History> findByUserId(int userId);

    // 사용자 ID에 따라 최근 조회한 상품의 히스토리 10개를 찾는 메서드

    List<History> findTop10ByUserIdOrderByViewTimeDesc(int userId);


    //    @Query("select h from History h where h.")


    @Query("SELECT h FROM History h JOIN fetch h.user u join fetch h.product p where u.deviceId = :deviceId order by h.viewTime desc")
    List<History> HistoryDetail(String deviceId);

    @Query("select h from History h " +
            "join fetch h.user u " +
            "join fetch h.product p " +
            "join fetch p.category c " +
            "where u.deviceId = :deviceId " +
            "order by h.viewTime desc " +
            "limit 10")
    List<History>  findTop10ByDeviceIdOrderByViewTimeDesc(String deviceId);

    void removeHistoryById(int id);

    @Modifying
    @Query(value = "insert into history(view_time, product_id, user_id) values(:viewTime, :productId, :userId)",nativeQuery = true)
    void addHistory(LocalDateTime viewTime, int productId, int userId);

}




