package com.example.demo.service;

import com.example.demo.entity.Festival;
import com.example.demo.repository.FestivalRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class FestivalService {

    @Autowired
    private FestivalRepository festivalRepository;

    /**
     * 获取所有节日
     */
    public List<Festival> findAll() {
        return festivalRepository.findAll();
    }

    /**
     * 根据ID查找节日
     */
    public Optional<Festival> findById(Long id) {
        return festivalRepository.findById(id);
    }

    /**
     * 创建节日
     */
    @Transactional
    public Festival create(Festival festival) {
        return festivalRepository.save(festival);
    }

    /**
     * 更新节日
     */
    @Transactional
    public Optional<Festival> update(Long id, Festival festival) {
        return festivalRepository.findById(id)
                .map(existing -> {
                    existing.setName(festival.getName());
                    existing.setDate(festival.getDate());
                    existing.setSeason(festival.getSeason());
                    existing.setDescription(festival.getDescription());
                    existing.setCustoms(festival.getCustoms());
                    existing.setImage(festival.getImage());
                    return festivalRepository.save(existing);
                });
    }

    /**
     * 删除节日
     */
    @Transactional
    public boolean delete(Long id) {
        Optional<Festival> festivalOpt = festivalRepository.findById(id);
        if (festivalOpt.isPresent()) {
            // 删除数据库记录
            festivalRepository.deleteById(id);
            return true;
        }
        return false;
    }

    /**
     * 批量删除节日
     */
    @Transactional
    public void deleteBatch(List<Long> ids) {
        for (Long id : ids) {
            delete(id);
        }
    }
}
