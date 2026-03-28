package com.example.demo.controller;

import com.example.demo.entity.FestivalActivity;
import com.example.demo.entity.FestivalActivityComment;
import com.example.demo.service.FestivalActivityCommentService;
import com.example.demo.service.FestivalActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/festival-activity")
public class FestivalActivityController {

    @Autowired
    private FestivalActivityService service;

    @Autowired
    private FestivalActivityCommentService commentService;

    /**
     * 获取所有节庆活动
     */
    @GetMapping
    public List<FestivalActivity> getAll() {
        return service.findAll();
    }

    /**
     * 根据ID获取节庆活动
     */
    @GetMapping("/{id}")
    public ResponseEntity<FestivalActivity> getById(@PathVariable Long id) {
        return service.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 创建单个节庆活动
     */
    @PostMapping
    public FestivalActivity create(@RequestBody FestivalActivity activity) {
        return service.create(activity);
    }

    /**
     * 批量创建节庆活动
     */
    @PostMapping("/batch")
    public List<FestivalActivity> createBatch(@RequestBody List<FestivalActivity> activities) {
        return service.createBatch(activities);
    }

    /**
     * 更新节庆活动
     */
    @PutMapping("/{id}")
    public ResponseEntity<FestivalActivity> update(@PathVariable Long id, @RequestBody FestivalActivity activity) {
        return service.update(id, activity)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 删除节庆活动
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (service.delete(id)) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    /**
     * 批量删除节庆活动
     */
    @DeleteMapping("/batch")
    public ResponseEntity<Void> deleteBatch(@RequestBody List<Long> ids) {
        service.deleteBatch(ids);
        return ResponseEntity.noContent().build();
    }

    /**
     * 清空所有节庆活动
     */
    @DeleteMapping("/all")
    public ResponseEntity<Void> deleteAll() {
        service.deleteAll();
        return ResponseEntity.noContent().build();
    }

    /**
     * 获取指定活动的评论列表
     */
    @GetMapping("/{id}/comments")
    public List<FestivalActivityComment> getComments(@PathVariable Long id) {
        return commentService.getCommentsByActivityId(id);
    }

    /**
     * 为指定活动添加评论
     */
    @PostMapping("/{id}/comments")
    public FestivalActivityComment addComment(@PathVariable Long id, @RequestBody CommentRequest request) {
        return commentService.createComment(id, request.getUserName(), request.getContent());
    }

    // 评论请求DTO
    static class CommentRequest {
        private String userName;
        private String content;

        public String getUserName() {
            return userName;
        }

        public void setUserName(String userName) {
            this.userName = userName;
        }

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }
    }
}
