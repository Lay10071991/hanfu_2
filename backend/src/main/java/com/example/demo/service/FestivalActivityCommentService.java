package com.example.demo.service;

import com.example.demo.entity.FestivalActivity;
import com.example.demo.entity.FestivalActivityComment;
import com.example.demo.repository.FestivalActivityCommentRepository;
import com.example.demo.repository.FestivalActivityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class FestivalActivityCommentService {

    @Autowired
    private FestivalActivityCommentRepository commentRepository;

    @Autowired
    private FestivalActivityRepository activityRepository;

    /**
     * 根据活动ID获取评论列表
     */
    public List<FestivalActivityComment> getCommentsByActivityId(Long activityId) {
        return commentRepository.findByActivityId(activityId);
    }

    /**
     * 创建评论
     */
    public FestivalActivityComment createComment(Long activityId, String userName, String content) {
        Optional<FestivalActivity> activityOptional = activityRepository.findById(activityId);
        if (!activityOptional.isPresent()) {
            throw new IllegalArgumentException("Activity not found with id: " + activityId);
        }

        FestivalActivity activity = activityOptional.get();
        FestivalActivityComment comment = new FestivalActivityComment(activity, userName, content);
        comment.setCreateTime(new Date());
        return commentRepository.save(comment);
    }

    /**
     * 删除评论
     */
    public boolean deleteComment(Long id) {
        if (commentRepository.existsById(id)) {
            commentRepository.deleteById(id);
            return true;
        }
        return false;
    }

    /**
     * 批量删除评论
     */
    public void deleteCommentsByActivityId(Long activityId) {
        List<FestivalActivityComment> comments = commentRepository.findByActivityId(activityId);
        commentRepository.deleteAll(comments);
    }
}