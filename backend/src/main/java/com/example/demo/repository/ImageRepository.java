package com.example.demo.repository;

import com.example.demo.entity.Image;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ImageRepository extends JpaRepository<Image, Long> {

    /**
     * 根据路径查找图片
     *
     * @param path 图片相对路径
     * @return 图片实体
     */
    Optional<Image> findByPath(String path);

    /**
     * 根据实体类型和实体ID查找图片列表
     *
     * @param entityType 实体类型
     * @param entityId   实体ID
     * @return 图片列表
     */
    List<Image> findByEntityTypeAndEntityId(String entityType, Long entityId);

    /**
     * 根据类别查找图片列表
     *
     * @param category 图片类别
     * @return 图片列表
     */
    List<Image> findByCategory(String category);

    /**
     * 根据实体类型查找图片列表
     *
     * @param entityType 实体类型
     * @return 图片列表
     */
    List<Image> findByEntityType(String entityType);

    /**
     * 根据状态查找图片列表
     *
     * @param status 状态
     * @return 图片列表
     */
    List<Image> findByStatus(String status);

    /**
     * 删除指定路径的图片
     *
     * @param path 图片路径
     */
    void deleteByPath(String path);

    /**
     * 根据实体类型和实体ID删除图片
     *
     * @param entityType 实体类型
     * @param entityId   实体ID
     */
    void deleteByEntityTypeAndEntityId(String entityType, Long entityId);
}
