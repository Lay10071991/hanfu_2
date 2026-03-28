package com.example.demo.repository;

import com.example.demo.entity.ClothingComponent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ClothingComponentRepository extends JpaRepository<ClothingComponent, Long> {

    /**
     * 根据名称查找服饰部件
     */
    Optional<ClothingComponent> findByName(String name);

    /**
     * 根据类型查找服饰部件
     */
    List<ClothingComponent> findByTypeOrderBySortOrderAsc(String type);

    /**
     * 查询所有服饰部件并按排序号排序
     */
    List<ClothingComponent> findAllByOrderBySortOrderAsc();
}
