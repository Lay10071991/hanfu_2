package com.example.demo.service;

import com.example.demo.entity.Comment;
import com.example.demo.entity.Like;
import com.example.demo.entity.Post;
import com.example.demo.entity.PostImage;
import com.example.demo.repository.CommentRepository;
import com.example.demo.repository.LikeRepository;
import com.example.demo.repository.PostImageRepository;
import com.example.demo.repository.PostRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import jakarta.annotation.PostConstruct;

@Service
public class PostService {

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private PostImageRepository postImageRepository;

    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private LikeRepository likeRepository;

    @Autowired
    private UserRepository userRepository;

    public List<Map<String, Object>> getAllPosts(String sortBy, Long currentUserId) {
        List<Post> posts;
        if ("hot".equals(sortBy)) {
            posts = postRepository.findAllOrderByLikesDesc();
        } else {
            posts = postRepository.findAllOrderByPublishDateDesc();
        }
        return posts.stream().map(post -> {
            Map<String, Object> map = convertToMap(post);
            if (currentUserId != null) {
                boolean liked = likeRepository.existsByUserIdAndPostId(currentUserId, post.getId());
                map.put("liked", liked);
            } else {
                map.put("liked", false);
            }
            return map;
        }).collect(Collectors.toList());
    }

    public Map<String, Object> getPostById(Long id, Long currentUserId) {
        Optional<Post> postOpt = postRepository.findById(id);
        if (postOpt.isEmpty()) {
            return null;
        }
        Post post = postOpt.get();
        
        Map<String, Object> result = convertToMap(post);
        
        if (currentUserId != null) {
            boolean liked = likeRepository.existsByUserIdAndPostId(currentUserId, id);
            result.put("liked", liked);
        } else {
            result.put("liked", false);
        }
        
        return result;
    }

    @Transactional
    public Map<String, Object> createPost(String title, String content, String category, 
            Long authorId, List<String> imageUrls) {
        Post post = new Post();
        post.setTitle(title);
        post.setContent(content);
        post.setCategory(category);
        post.setAuthorId(authorId);
        post.setPublishDate(LocalDate.now());
        post.setLikes(0);
        post.setComments(0);
        
        if (content != null && content.length() > 100) {
            post.setDescription(content.substring(0, 100) + "...");
        } else {
            post.setDescription(content);
        }
        
        if (imageUrls != null && !imageUrls.isEmpty()) {
            post.setImageUrl(imageUrls.get(0));
        }
        
        Post savedPost = postRepository.save(post);
        
        if (imageUrls != null && !imageUrls.isEmpty()) {
            for (String imageUrl : imageUrls) {
                PostImage postImage = new PostImage();
                postImage.setPost(savedPost);
                postImage.setImageUrl(imageUrl);
                postImageRepository.save(postImage);
            }
        }
        
        return convertToMap(savedPost);
    }

    @Transactional
    public Map<String, Object> toggleLike(Long postId, Long userId) {
        Optional<Post> postOpt = postRepository.findById(postId);
        if (postOpt.isEmpty()) {
            return null;
        }
        
        Post post = postOpt.get();
        Optional<Like> likeOpt = likeRepository.findByUserIdAndPostId(userId, postId);
        
        boolean liked;
        
        if (likeOpt.isPresent()) {
            likeRepository.delete(likeOpt.get());
            liked = false;
        } else {
            Like like = new Like();
            like.setUserId(userId);
            like.setPostId(postId);
            likeRepository.save(like);
            liked = true;
        }
        
        // 从数据库中获取实际的点赞数（基于post_like表的记录数）
        long actualLikes = likeRepository.countByPostId(postId);
        
        // 更新post表中的likes字段为实际点赞数
        post.setLikes((int) actualLikes);
        postRepository.save(post);
        
        Map<String, Object> result = new HashMap<>();
        result.put("liked", liked);
        result.put("likes", actualLikes);
        return result;
    }

    public List<Map<String, Object>> getCommentsByPostId(Long postId) {
        List<Comment> comments = commentRepository.findByPostIdOrderByCreateTimeDesc(postId);
        return comments.stream().map(comment -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", comment.getId());
            map.put("content", comment.getContent());
            map.put("time", formatTime(comment.getCreateTime()));
            map.put("author", getAuthorName(comment.getUserId()));
            return map;
        }).collect(Collectors.toList());
    }

    @Transactional
    public Map<String, Object> addComment(Long postId, Long userId, String content) {
        Optional<Post> postOpt = postRepository.findById(postId);
        if (postOpt.isEmpty()) {
            return null;
        }
        
        Post post = postOpt.get();
        Comment comment = new Comment();
        comment.setPost(post);
        comment.setUserId(userId);
        comment.setContent(content);
        
        Comment savedComment = commentRepository.save(comment);
        
        post.setComments(post.getComments() + 1);
        postRepository.save(post);
        
        Map<String, Object> result = new HashMap<>();
        result.put("id", savedComment.getId());
        result.put("content", savedComment.getContent());
        result.put("time", "刚刚");
        result.put("author", getAuthorName(userId));
        result.put("postComments", post.getComments());
        return result;
    }

    private Map<String, Object> convertToMap(Post post) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", post.getId());
        map.put("title", post.getTitle());
        map.put("content", post.getContent());
        map.put("description", post.getDescription());
        map.put("image", post.getImageUrl());
        map.put("imageUrl", post.getImageUrl()); // 添加imageUrl字段以保持一致性
        map.put("author", getAuthorName(post.getAuthorId()));
        map.put("authorId", post.getAuthorId());
        map.put("likes", likeRepository.countByPostId(post.getId()));
        map.put("comments", post.getComments());

        map.put("time", formatDate(post.getPublishDate()));
        map.put("publishDate", post.getPublishDate() != null ? post.getPublishDate().toString() : null);
        map.put("category", post.getCategory());
        map.put("categoryType", getCategoryType(post.getCategory()));
        map.put("liked", false);
        
        List<PostImage> images = postImageRepository.findByPostId(post.getId());
        if (!images.isEmpty()) {
            map.put("images", images.stream()
                .map(img -> {
                    Map<String, Object> imgMap = new HashMap<>();
                    imgMap.put("url", img.getImageUrl());
                    return imgMap;
                })
                .collect(Collectors.toList()));
        } else if (post.getImageUrl() != null) {
            Map<String, Object> imgMap = new HashMap<>();
            imgMap.put("url", post.getImageUrl());
            map.put("images", List.of(imgMap));
        }
        
        return map;
    }

    private String getAuthorName(Long authorId) {
        if (authorId == null) return "匿名用户";
        return userRepository.findById(authorId)
                .map(user -> user.getUsername())
                .orElse("匿名用户");
    }

    private String formatDate(LocalDate date) {
        if (date == null) return "";
        return String.format("%d年%02d月%02d日", date.getYear(), date.getMonthValue(), date.getDayOfMonth());
    }

    private String formatTime(java.time.LocalDateTime dateTime) {
        if (dateTime == null) return "";
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        long hours = java.time.Duration.between(dateTime, now).toHours();
        if (hours < 1) {
            return "刚刚";
        } else if (hours < 24) {
            return hours + "小时前";
        } else {
            long days = hours / 24;
            return days + "天前";
        }
    }

    private String getCategoryType(String category) {
        if (category == null) return "";
        switch (category) {
            case "穿搭分享": return "success";
            case "发型教程": return "warning";
            case "摄影作品": return "info";
            case "汉服制作": return "";
            case "文化活动": return "danger";
            default: return "";
        }
    }


    @Transactional
    public Map<String, Object> updatePost(Long id, Map<String, Object> request) {
        Optional<Post> postOpt = postRepository.findById(id);
        if (postOpt.isEmpty()) {
            return null;
        }
        
        Post post = postOpt.get();
        
        if (request.containsKey("title")) {
            post.setTitle((String) request.get("title"));
        }
        if (request.containsKey("content")) {
            String content = (String) request.get("content");
            post.setContent(content);
            if (content != null && content.length() > 100) {
                post.setDescription(content.substring(0, 100) + "...");
            } else {
                post.setDescription(content);
            }
        }
        if (request.containsKey("category")) {
            post.setCategory((String) request.get("category"));
        }
        if (request.containsKey("imageUrl")) {
            post.setImageUrl((String) request.get("imageUrl"));
        }
        
        Post updatedPost = postRepository.save(post);
        return convertToMap(updatedPost);
    }

    @Transactional
    public void deletePost(Long id) {
        postRepository.deleteById(id);
    }

    public List<Map<String, Object>> getPostsByUserId(Long userId) {
        List<Post> posts = postRepository.findByAuthorId(userId);
        return posts.stream().map(this::convertToMap).collect(Collectors.toList());
    }

    public List<Map<String, Object>> getUserLikedPosts(Long userId) {
        List<Like> likes = likeRepository.findByUserIdOrderByCreateTimeDesc(userId);
        return likes.stream().map(like -> {
            Post post = postRepository.findById(like.getPostId()).orElse(null);
            if (post == null) {
                return null;
            }
            Map<String, Object> map = convertToMap(post);
            map.put("liked", true);
            map.put("likeTime", like.getCreateTime());
            return map;
        }).filter(map -> map != null).collect(Collectors.toList());
    }

    @PostConstruct
    public void init() {
        // 更新所有帖子的日期为2025年
        List<Post> posts = postRepository.findAll();
        for (Post post : posts) {
            LocalDate publishDate = post.getPublishDate();
            if (publishDate != null) {
                // 将年份设置为2025年
                LocalDate newDate = LocalDate.of(2025, publishDate.getMonth(), publishDate.getDayOfMonth());
                post.setPublishDate(newDate);
                postRepository.save(post);
            }
        }
    }

}