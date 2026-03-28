package com.example.demo.repository;

import com.example.demo.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    // 可以添加自定义查询方法
    User findByUsername(String username);
    
    // 查询ID最大的用户
    User findTopByOrderByIdDesc();
}
