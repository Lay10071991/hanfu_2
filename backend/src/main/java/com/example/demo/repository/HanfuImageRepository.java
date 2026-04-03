package com.example.demo.repository;

import com.example.demo.entity.HanfuImage;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface HanfuImageRepository extends JpaRepository<HanfuImage, Long> {
    List<HanfuImage> findByHanfuId(Long hanfuId);
}
