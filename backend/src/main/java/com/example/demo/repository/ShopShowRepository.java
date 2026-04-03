package com.example.demo.repository;

import com.example.demo.entity.ShopShow;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ShopShowRepository extends JpaRepository<ShopShow, Long> {
    List<ShopShow> findByShopIdOrderBySortOrderAsc(Long shopId);
    List<ShopShow> findByShopId(Long shopId);
}
