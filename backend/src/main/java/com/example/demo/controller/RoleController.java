package com.example.demo.controller;

import com.example.demo.entity.UserRole;
import com.example.demo.repository.UserRoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/roles")
public class RoleController {

    @Autowired
    private UserRoleRepository userRoleRepository;

    @GetMapping
    public List<UserRole> getAllRoles() {
        return userRoleRepository.findAll();
    }
}
