package com.example.demo.repository;

import com.example.demo.entity.ShapeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ShapeTypeRepository extends JpaRepository<ShapeType, Long> {

    /**
     * 根据名称查找形制分类
     *
     * @param name 形制名称
     * @return 形制分类
     */
    Optional<ShapeType> findByName(String name);

    /**
     * 根据排序顺序查找形制分类列表
     *
     * @return 形制分类列表
     */
    List<ShapeType> findAllByOrderBySortOrderAsc();

    /**
     * 根据排序顺序查找前N个形制分类
     *
     * @param limit 限制数量
     * @return 形制分类列表
     */
    List<ShapeType> findTop4ByOrderBySortOrderAsc();
}
