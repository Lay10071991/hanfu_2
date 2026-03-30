package com.example.demo.controller;

import com.example.demo.entity.FestivalActivity;
import com.example.demo.entity.FestivalActivityComment;
import com.example.demo.entity.FestivalActivityRegistration;
import com.example.demo.service.FestivalActivityCommentService;
import com.example.demo.service.FestivalActivityRegistrationService;
import com.example.demo.service.FestivalActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/festival-activity")
public class FestivalActivityController {

    @Autowired
    private FestivalActivityService service;

    @Autowired
    private FestivalActivityCommentService commentService;

    @Autowired
    private FestivalActivityRegistrationService registrationService;

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

    /**
     * 获取指定活动的报名人数
     */
    @GetMapping("/{id}/registration/count")
    public ResponseEntity<Map<String, Object>> getRegistrationCount(@PathVariable Long id) {
        long count = registrationService.getRegistrationCount(id);
        Map<String, Object> response = new HashMap<>();
        response.put("count", count);
        return ResponseEntity.ok(response);
    }

    /**
     * 检查用户是否已报名
     */
    @GetMapping("/{id}/registration/check")
    public ResponseEntity<Map<String, Object>> checkRegistration(
            @PathVariable Long id,
            @RequestParam Long userId) {
        boolean isRegistered = registrationService.isRegistered(id, userId);
        Map<String, Object> response = new HashMap<>();
        response.put("isRegistered", isRegistered);
        return ResponseEntity.ok(response);
    }

    /**
     * 用户报名活动
     */
    @PostMapping("/{id}/registration")
    public ResponseEntity<Map<String, Object>> register(
            @PathVariable Long id,
            @RequestBody RegistrationRequest request) {
        try {
            FestivalActivityRegistration registration = registrationService.register(id, request.getUserId());
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "报名成功");
            response.put("registration", registration);
            return ResponseEntity.ok(response);
        } catch (IllegalStateException e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * 用户取消报名
     */
    @DeleteMapping("/{id}/registration")
    public ResponseEntity<Map<String, Object>> cancelRegistration(
            @PathVariable Long id,
            @RequestParam Long userId) {
        boolean cancelled = registrationService.cancelRegistration(id, userId);
        Map<String, Object> response = new HashMap<>();
        if (cancelled) {
            response.put("success", true);
            response.put("message", "取消报名成功");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "未找到报名记录");
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * 获取活动的所有报名记录
     */
    @GetMapping("/{id}/registrations")
    public List<FestivalActivityRegistration> getRegistrations(@PathVariable Long id) {
        return registrationService.getRegistrationsByActivityId(id);
    }

    // 报名请求DTO
    static class RegistrationRequest {
        private Long userId;

        public Long getUserId() {
            return userId;
        }

        public void setUserId(Long userId) {
            this.userId = userId;
        }
    }
}
