package com.example.demo.controller;

import com.example.demo.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/posts")
public class PostController {

    @Autowired
    private PostService postService;

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> getAllPosts(
            @RequestParam(defaultValue = "hot") String sortBy,
            @RequestHeader(value = "X-User-Id", required = false) Long userId) {
        List<Map<String, Object>> posts = postService.getAllPosts(sortBy, userId);
        return ResponseEntity.ok(posts);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getPostById(
            @PathVariable Long id,
            @RequestHeader(value = "X-User-Id", required = false) Long userId) {
        Map<String, Object> post = postService.getPostById(id, userId);
        if (post == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(post);
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> createPost(
            @RequestBody Map<String, Object> request,
            @RequestHeader("X-User-Id") Long userId) {
        String title = (String) request.get("title");
        String content = (String) request.get("content");
        String category = (String) request.get("category");
        @SuppressWarnings("unchecked")
        List<String> images = (List<String>) request.get("images");
        
        Map<String, Object> post = postService.createPost(title, content, category, userId, images);
        return ResponseEntity.ok(post);
    }

    @PostMapping("/{id}/like")
    public ResponseEntity<Map<String, Object>> toggleLike(
            @PathVariable Long id,
            @RequestHeader("X-User-Id") Long userId) {
        Map<String, Object> result = postService.toggleLike(id, userId);
        if (result == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/{id}/comments")
    public ResponseEntity<List<Map<String, Object>>> getComments(@PathVariable Long id) {
        List<Map<String, Object>> comments = postService.getCommentsByPostId(id);
        return ResponseEntity.ok(comments);
    }

    @PostMapping("/{id}/comments")
    public ResponseEntity<Map<String, Object>> addComment(
            @PathVariable Long id,
            @RequestBody Map<String, String> request,
            @RequestHeader("X-User-Id") Long userId) {
        String content = request.get("content");
        Map<String, Object> comment = postService.addComment(id, userId, content);
        if (comment == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(comment);
    }


    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updatePost(
            @PathVariable Long id,
            @RequestBody Map<String, Object> request) {
        Map<String, Object> updatedPost = postService.updatePost(id, request);
        if (updatedPost == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(updatedPost);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePost(@PathVariable Long id) {
        postService.deletePost(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Map<String, Object>>> getPostsByUserId(@PathVariable Long userId) {
        List<Map<String, Object>> posts = postService.getPostsByUserId(userId);
        return ResponseEntity.ok(posts);
    }
}
