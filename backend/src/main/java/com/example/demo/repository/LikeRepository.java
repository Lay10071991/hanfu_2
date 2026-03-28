package com.example.demo.repository;

import com.example.demo.entity.Like;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface LikeRepository extends JpaRepository<Like, Long> {
    
    Optional<Like> findByUserIdAndTargetIdAndTargetType(Long userId, Long targetId, String targetType);
    
    boolean existsByUserIdAndTargetIdAndTargetType(Long userId, Long targetId, String targetType);
    
    void deleteByUserIdAndTargetIdAndTargetType(Long userId, Long targetId, String targetType);
    
    long countByTargetIdAndTargetType(Long targetId, String targetType);
}
