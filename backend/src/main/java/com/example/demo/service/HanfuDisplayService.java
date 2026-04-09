package com.example.demo.service;

import com.example.demo.entity.HanfuDisplay;
import com.example.demo.entity.HanfuImage;
import com.example.demo.repository.HanfuDisplayRepository;
import com.example.demo.repository.HanfuImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HanfuDisplayService {

    @Autowired
    private HanfuDisplayRepository hanfuDisplayRepository;

    @Autowired
    private HanfuImageRepository hanfuImageRepository;

    public List<HanfuDisplay> getAllHanfuDisplays() {
        return hanfuDisplayRepository.findAll();
    }

    public HanfuDisplay getHanfuDisplayById(Long id) {
        return hanfuDisplayRepository.findById(id).orElse(null);
    }

    public List<HanfuImage> getImagesByHanfuId(Long hanfuId) {
        return hanfuImageRepository.findByHanfuId(hanfuId);
    }

    public HanfuDisplay createHanfuDisplay(HanfuDisplay hanfuDisplay) {
        HanfuDisplay saved = hanfuDisplayRepository.save(hanfuDisplay);
        return saved;
    }

    public HanfuDisplay updateHanfuDisplay(Long id, HanfuDisplay hanfuDisplay) {
        HanfuDisplay existing = hanfuDisplayRepository.findById(id).orElse(null);
        if (existing != null) {
            existing.setName(hanfuDisplay.getName());
            existing.setDescription(hanfuDisplay.getDescription());
            existing.setContent(hanfuDisplay.getContent());
            existing.setSortOrder(hanfuDisplay.getSortOrder());
            return hanfuDisplayRepository.save(existing);
        }
        return null;
    }

    public void saveHanfuImages(Long hanfuId, List<String> imagePaths) {
        // 先删除旧的图片
        hanfuImageRepository.deleteByHanfuId(hanfuId);
        
        // 保存新的图片
        for (int i = 0; i < imagePaths.size(); i++) {
            HanfuImage image = new HanfuImage();
            image.setHanfuId(hanfuId);
            image.setImagePath(imagePaths.get(i));
            image.setSortOrder(i);
            hanfuImageRepository.save(image);
        }
    }

    public void deleteHanfuDisplay(Long id) {
        hanfuDisplayRepository.deleteById(id);
    }
}
