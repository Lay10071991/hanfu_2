package com.example.demo.repository;

import com.example.demo.entity.FestivalActivityComment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FestivalActivityCommentRepository extends JpaRepository<FestivalActivityComment, Long> {

    /**
     * 根据活动ID获取评论列表
     */
    List<FestivalActivityComment> findByActivityId(Long activityId);
}