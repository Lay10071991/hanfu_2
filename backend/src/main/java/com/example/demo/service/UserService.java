package com.example.demo.service;

import com.example.demo.entity.User;
import com.example.demo.entity.UserRole;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.UserRoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private UserRoleRepository userRoleRepository;

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    public User createUser(User user) {
        // 确保角色存在
        ensureDefaultRolesExist();
        
        // 自定义ID生成：获取当前最大ID值加1
        User maxIdUser = userRepository.findTopByOrderByIdDesc();
        if (maxIdUser != null) {
            user.setId(maxIdUser.getId() + 1);
        } else {
            // 如果没有用户，从1开始
            user.setId(1L);
        }
        
        // 处理用户角色
        if (user.getUserRole() != null && user.getUserRole().getRoleName() != null) {
            // 根据角色名称查找角色
            UserRole userRole = userRoleRepository.findByRoleName(user.getUserRole().getRoleName());
            if (userRole != null) {
                user.setUserRole(userRole);
            } else {
                // 如果角色不存在，使用默认角色
                userRole = userRoleRepository.findByRoleName("普通用户");
                user.setUserRole(userRole);
            }
        } else {
            // 如果没有提供角色，默认使用普通用户角色
            UserRole userRole = userRoleRepository.findByRoleName("普通用户");
            user.setUserRole(userRole);
        }
        
        return userRepository.save(user);
    }
    
    // 确保默认角色存在
    private void ensureDefaultRolesExist() {
        // 检查并创建普通用户角色
        if (userRoleRepository.findByRoleName("普通用户") == null) {
            UserRole userRole = new UserRole();
            userRole.setId(1L);
            userRole.setRoleName("普通用户");
            userRoleRepository.save(userRole);
        }
        
        // 检查并创建商家角色
        if (userRoleRepository.findByRoleName("商家") == null) {
            UserRole merchantRole = new UserRole();
            merchantRole.setId(2L);
            merchantRole.setRoleName("商家");
            userRoleRepository.save(merchantRole);
        }
        
        // 检查并创建平台负责人角色
        if (userRoleRepository.findByRoleName("平台负责人") == null) {
            UserRole adminRole = new UserRole();
            adminRole.setId(3L);
            adminRole.setRoleName("平台负责人");
            userRoleRepository.save(adminRole);
        }
    }

    public User saveUser(User user) {
        return userRepository.save(user);
    }

    public User updateUser(Long id, User userDetails) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id " + id));
        
        user.setUsername(userDetails.getUsername());
        user.setPassword(userDetails.getPassword());
        user.setGender(userDetails.getGender());
        user.setBio(userDetails.getBio());
        user.setUserRole(userDetails.getUserRole());
        
        return userRepository.save(user);
    }

    public void deleteUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id " + id));
        userRepository.delete(user);
    }
    
    // 登录功能
    public User login(String username, String password) {
        System.out.println("登录请求：用户名=" + username + ", 密码=" + password);
        User user = userRepository.findByUsername(username);
        if (user != null) {
            System.out.println("找到用户：用户名=" + user.getUsername() + ", 密码=" + user.getPassword());
            if (user.getPassword().equals(password)) {
                System.out.println("密码匹配，登录成功");
                return user;
            } else {
                System.out.println("密码不匹配");
            }
        } else {
            System.out.println("未找到用户：" + username);
        }
        return null;
    }

    // 修改密码功能
    public void changePassword(Long id, String oldPassword, String newPassword) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id " + id));
        
        if (!user.getPassword().equals(oldPassword)) {
            throw new RuntimeException("原密码错误");
        }
        
        user.setPassword(newPassword);
        userRepository.save(user);
    }
}
