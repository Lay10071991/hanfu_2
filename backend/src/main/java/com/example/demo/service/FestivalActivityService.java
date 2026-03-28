package com.example.demo.service;

import com.example.demo.entity.FestivalActivity;
import com.example.demo.repository.FestivalActivityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class FestivalActivityService {

    @Autowired
    private FestivalActivityRepository repository;

    /**
     * 获取所有节庆活动
     */
    public List<FestivalActivity> findAll() {
        return repository.findAll();
    }

    /**
     * 根据ID查找节庆活动
     */
    public Optional<FestivalActivity> findById(Long id) {
        return repository.findById(id);
    }

    /**
     * 创建节庆活动
     */
    @Transactional
    public FestivalActivity create(FestivalActivity activity) {
        return repository.save(activity);
    }

    /**
     * 批量创建节庆活动
     */
    @Transactional
    public List<FestivalActivity> createBatch(List<FestivalActivity> activities) {
        return repository.saveAll(activities);
    }

    /**
     * 更新节庆活动
     */
    @Transactional
    public Optional<FestivalActivity> update(Long id, FestivalActivity activity) {
        return repository.findById(id)
                .map(existing -> {
                    existing.setTitle(activity.getTitle());
                    existing.setSeason(activity.getSeason());
                    existing.setDate(activity.getDate());
                    existing.setLocation(activity.getLocation());
                    existing.setImage(activity.getImage());
                    existing.setDescription(activity.getDescription());
                    return repository.save(existing);
                });
    }

    /**
     * 删除节庆活动
     */
    @Transactional
    public boolean delete(Long id) {
        if (repository.existsById(id)) {
            repository.deleteById(id);
            return true;
        }
        return false;
    }

    /**
     * 批量删除节庆活动
     */
    @Transactional
    public void deleteBatch(List<Long> ids) {
        repository.deleteAllById(ids);
    }

    /**
     * 清空所有节庆活动
     */
    @Transactional
    public void deleteAll() {
        repository.deleteAll();
    }
}
