package com.example.demo.controller;

import com.example.demo.entity.Comment;
import com.example.demo.entity.Post;
import com.example.demo.entity.User;
import com.example.demo.repository.CommentRepository;
import com.example.demo.repository.PostRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/comments")
public class CommentController {

    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public List<Map<String, Object>> getAllComments() {
        return commentRepository.findAll().stream().map(comment -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", comment.getId());
            map.put("content", comment.getContent());
            map.put("createTime", comment.getCreateTime());
            map.put("updateTime", comment.getUpdateTime());
            
            Post post = postRepository.findById(comment.getPost().getId()).orElse(null);
            map.put("postTitle", post != null ? post.getTitle() : "Unknown Post");
            
            User user = userRepository.findById(comment.getUserId()).orElse(null);
            map.put("username", user != null ? user.getUsername() : "Unknown User");
            
            return map;
        }).collect(Collectors.toList());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteComment(@PathVariable Long id) {
        commentRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/user/{userId}")
    public List<Map<String, Object>> getCommentsByUserId(@PathVariable Long userId) {
        return commentRepository.findByUserIdOrderByCreateTimeDesc(userId).stream().map(comment -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", comment.getId());
            map.put("content", comment.getContent());
            map.put("createTime", comment.getCreateTime());
            map.put("updateTime", comment.getUpdateTime());

            Post post = postRepository.findById(comment.getPost().getId()).orElse(null);
            map.put("postId", post != null ? post.getId() : null);
            map.put("postTitle", post != null ? post.getTitle() : "Unknown Post");
            map.put("postCategory", post != null ? post.getCategory() : "");

            User user = userRepository.findById(comment.getUserId()).orElse(null);
            map.put("username", user != null ? user.getUsername() : "Unknown User");

            return map;
        }).collect(Collectors.toList());
    }
}
