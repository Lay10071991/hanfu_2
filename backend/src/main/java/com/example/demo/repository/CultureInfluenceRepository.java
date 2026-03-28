package com.example.demo.repository;

import com.example.demo.entity.CultureInfluence;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CultureInfluenceRepository extends JpaRepository<CultureInfluence, Long> {

    /**
     * 根据排序顺序查找文化影响列表
     *
     * @return 文化影响列表
     */
    List<CultureInfluence> findAllByOrderByIdAsc();
}
