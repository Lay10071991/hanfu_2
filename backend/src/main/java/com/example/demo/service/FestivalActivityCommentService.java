package com.example.demo.service;

import com.example.demo.entity.FestivalActivity;
import com.example.demo.entity.FestivalActivityComment;
import com.example.demo.repository.FestivalActivityCommentRepository;
import com.example.demo.repository.FestivalActivityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class FestivalActivityCommentService {

    @Autowired
    private FestivalActivityCommentRepository commentRepository;

    @Autowired
    private FestivalActivityRepository activityRepository;

    public List<FestivalActivityComment> getCommentsByActivityId(Long activityId) {
        return commentRepository.findByActivityId(activityId);
    }

    public FestivalActivityComment createComment(Long activityId, String userName, String content) {
        Optional<FestivalActivity> activityOptional = activityRepository.findById(activityId);
        if (!activityOptional.isPresent()) {
            throw new IllegalArgumentException("Activity not found with id: " + activityId);
        }

        FestivalActivity activity = activityOptional.get();
        FestivalActivityComment comment = new FestivalActivityComment(activity, userName, content);
        return commentRepository.save(comment);
    }

    public boolean deleteComment(Long id) {
        if (commentRepository.existsById(id)) {
            commentRepository.deleteById(id);
            return true;
        }
        return false;
    }

    public void deleteCommentsByActivityId(Long activityId) {
        List<FestivalActivityComment> comments = commentRepository.findByActivityId(activityId);
        commentRepository.deleteAll(comments);
    }
}
