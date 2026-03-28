package com.example.demo.service;

import com.example.demo.entity.Festival;
import com.example.demo.repository.FestivalRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Service
public class FestivalService {

    @Autowired
    private FestivalRepository festivalRepository;

    @Autowired
    private ImageService imageService;

    private static final String IMAGE_CATEGORY = "festivals";

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
     * 创建节日（不带图片）
     */
    @Transactional
    public Festival create(Festival festival) {
        return festivalRepository.save(festival);
    }

    /**
     * 创建节日并上传图片
     */
    @Transactional
    public Festival createWithImage(Festival festival, MultipartFile imageFile) throws IOException {
        if (imageFile != null && !imageFile.isEmpty()) {
            String imagePath = imageService.uploadImage(imageFile, IMAGE_CATEGORY);
            festival.setImage(imagePath);
        }
        return festivalRepository.save(festival);
    }

    /**
     * 更新节日（不带图片）
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
                    // 不更新图片字段
                    return festivalRepository.save(existing);
                });
    }

    /**
     * 更新节日并更新图片（删除旧图片）
     */
    @Transactional
    public Optional<Festival> updateWithImage(Long id, Festival festival, MultipartFile imageFile) throws IOException {
        return festivalRepository.findById(id)
                .map(existing -> {
                    // 更新基本信息
                    existing.setName(festival.getName());
                    existing.setDate(festival.getDate());
                    existing.setSeason(festival.getSeason());
                    existing.setDescription(festival.getDescription());
                    existing.setCustoms(festival.getCustoms());

                    // 处理图片更新
                    if (imageFile != null && !imageFile.isEmpty()) {
                        try {
                            // 删除旧图片
                            String oldImagePath = existing.getImage();
                            if (oldImagePath != null && !oldImagePath.isEmpty()) {
                                imageService.deleteImage(oldImagePath);
                            }

                            // 上传新图片
                            String newImagePath = imageService.uploadImage(imageFile, IMAGE_CATEGORY);
                            existing.setImage(newImagePath);
                        } catch (IOException e) {
                            throw new RuntimeException("图片更新失败: " + e.getMessage(), e);
                        }
                    }

                    return festivalRepository.save(existing);
                });
    }

    /**
     * 仅更新节日图片
     */
    @Transactional
    public Optional<Festival> updateImageOnly(Long id, MultipartFile imageFile) throws IOException {
        return festivalRepository.findById(id)
                .map(existing -> {
                    try {
                        // 删除旧图片
                        String oldImagePath = existing.getImage();
                        if (oldImagePath != null && !oldImagePath.isEmpty()) {
                            imageService.deleteImage(oldImagePath);
                        }

                        // 上传新图片
                        String newImagePath = imageService.uploadImage(imageFile, IMAGE_CATEGORY);
                        existing.setImage(newImagePath);

                        return festivalRepository.save(existing);
                    } catch (IOException e) {
                        throw new RuntimeException("图片更新失败: " + e.getMessage(), e);
                    }
                });
    }

    /**
     * 删除节日（同时删除关联图片）
     */
    @Transactional
    public boolean delete(Long id) {
        Optional<Festival> festivalOpt = festivalRepository.findById(id);
        if (festivalOpt.isPresent()) {
            Festival festival = festivalOpt.get();

            // 删除关联图片
            String imagePath = festival.getImage();
            if (imagePath != null && !imagePath.isEmpty()) {
                imageService.deleteImage(imagePath);
            }

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
