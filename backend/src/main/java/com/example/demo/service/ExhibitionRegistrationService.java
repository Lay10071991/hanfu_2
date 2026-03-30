package com.example.demo.service;

import com.example.demo.entity.ExhibitionRegistration;
import com.example.demo.repository.ExhibitionRegistrationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ExhibitionRegistrationService {

    @Autowired
    private ExhibitionRegistrationRepository repository;

    @Transactional
    public boolean register(Long userId, Long exhibitionId) {
        // 检查是否已经预约
        if (repository.findByUserIdAndExhibitionId(userId, exhibitionId).isPresent()) {
            return false;
        }

        // 创建新的预约记录
        ExhibitionRegistration registration = new ExhibitionRegistration();
        registration.setUserId(userId);
        registration.setExhibitionId(exhibitionId);
        repository.save(registration);
        return true;
    }

    @Transactional
    public boolean cancelRegistration(Long userId, Long exhibitionId) {
        // 检查是否存在预约记录
        if (repository.findByUserIdAndExhibitionId(userId, exhibitionId).isEmpty()) {
            return false;
        }

        // 删除预约记录
        repository.deleteByUserIdAndExhibitionId(userId, exhibitionId);
        return true;
    }

    public boolean isRegistered(Long userId, Long exhibitionId) {
        return repository.findByUserIdAndExhibitionId(userId, exhibitionId).isPresent();
    }

    public long getRegistrationCount(Long exhibitionId) {
        return repository.countByExhibitionId(exhibitionId);
    }
}