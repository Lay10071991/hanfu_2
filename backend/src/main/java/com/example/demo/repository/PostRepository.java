package com.example.demo.repository;

import com.example.demo.entity.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PostRepository extends JpaRepository<Post, Long> {
    
    List<Post> findByCategory(String category);
    
    Page<Post> findAll(Pageable pageable);
    
    @Query("SELECT p FROM Post p ORDER BY p.likes DESC")
    List<Post> findAllOrderByLikesDesc();
    
    @Query("SELECT p FROM Post p ORDER BY p.publishDate DESC")
    List<Post> findAllOrderByPublishDateDesc();
    
    @Query("SELECT p FROM Post p WHERE p.authorId = :authorId ORDER BY p.publishDate DESC")
    List<Post> findByAuthorId(@Param("authorId") Long authorId);
}
