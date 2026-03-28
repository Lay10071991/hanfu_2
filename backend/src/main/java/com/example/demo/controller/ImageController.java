package com.example.demo.controller;

import com.example.demo.service.ImageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/image")
public class ImageController {

    @Autowired
    private ImageService imageService;

    /**
     * 上传图片到指定类别
     *
     * @param file     图片文件
     * @param category 图片类别 (festivals, exhibitions, shop-hanfu, etiquette, pattern-symbols,
     *                 dynasty-shapes, shape-types, clothing-components, festival-activities,
     *                 lectures, shop-details, community-posts)
     * @return 上传结果
     */
    @PostMapping("/upload/{category}")
    public ResponseEntity<Map<String, Object>> uploadImage(
            @RequestParam("file") MultipartFile file,
            @PathVariable String category) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 验证类别
            if (!isValidCategory(category)) {
                response.put("success", false);
                response.put("message", "无效的图片类别: " + category);
                return ResponseEntity.badRequest().body(response);
            }

            // 上传图片
            String imagePath = imageService.uploadImage(file, category);

            response.put("success", true);
            response.put("message", "图片上传成功");
            response.put("path", imagePath);
            response.put("url", imageService.getFullImageUrl(imagePath));

            return ResponseEntity.ok(response);

        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "文件上传失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 上传图片并指定自定义文件名
     *
     * @param file       图片文件
     * @param category   图片类别
     * @param customName 自定义文件名 (不含扩展名)
     * @return 上传结果
     */
    @PostMapping("/upload/{category}/{customName}")
    public ResponseEntity<Map<String, Object>> uploadImageWithName(
            @RequestParam("file") MultipartFile file,
            @PathVariable String category,
            @PathVariable String customName) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 验证类别
            if (!isValidCategory(category)) {
                response.put("success", false);
                response.put("message", "无效的图片类别: " + category);
                return ResponseEntity.badRequest().body(response);
            }

            // 验证自定义文件名
            if (customName == null || customName.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "自定义文件名不能为空");
                return ResponseEntity.badRequest().body(response);
            }

            // 清理文件名，移除非法字符
            String cleanName = customName.trim()
                    .replaceAll("[^a-zA-Z0-9\\u4e00-\\u9fa5_-]", "_");

            // 上传图片
            String imagePath = imageService.uploadImageWithName(file, category, cleanName);

            response.put("success", true);
            response.put("message", "图片上传成功");
            response.put("path", imagePath);
            response.put("url", imageService.getFullImageUrl(imagePath));

            return ResponseEntity.ok(response);

        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "文件上传失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 删除图片
     *
     * @param imagePath 图片相对路径 (如: /festivals/yuanxiao.jpg)
     * @return 删除结果
     */
    @DeleteMapping("/delete")
    public ResponseEntity<Map<String, Object>> deleteImage(
            @RequestParam("path") String imagePath) {

        Map<String, Object> response = new HashMap<>();

        boolean deleted = imageService.deleteImage(imagePath);

        if (deleted) {
            response.put("success", true);
            response.put("message", "图片删除成功");
        } else {
            response.put("success", false);
            response.put("message", "图片删除失败，文件可能不存在");
        }

        return ResponseEntity.ok(response);
    }

    /**
     * 验证图片是否存在
     *
     * @param imagePath 图片相对路径
     * @return 验证结果
     */
    @GetMapping("/exists")
    public ResponseEntity<Map<String, Object>> checkImageExists(
            @RequestParam("path") String imagePath) {

        Map<String, Object> response = new HashMap<>();
        boolean exists = imageService.imageExists(imagePath);

        response.put("success", true);
        response.put("exists", exists);

        return ResponseEntity.ok(response);
    }

    /**
     * 获取完整的图片URL
     *
     * @param imagePath 图片相对路径
     * @return 完整URL
     */
    @GetMapping("/url")
    public ResponseEntity<Map<String, Object>> getFullUrl(
            @RequestParam("path") String imagePath) {

        Map<String, Object> response = new HashMap<>();
        String fullUrl = imageService.getFullImageUrl(imagePath);

        response.put("success", true);
        response.put("path", imagePath);
        response.put("url", fullUrl);

        return ResponseEntity.ok(response);
    }

    /**
     * 验证图片类别是否有效
     */
    private boolean isValidCategory(String category) {
        String[] validCategories = {
            "festivals", "exhibitions", "shop-hanfu", "etiquette",
            "pattern-symbols", "dynasty-shapes", "shape-types",
            "clothing-components", "festival-activities", "lectures",
            "shop-details", "community-posts"
        };

        for (String valid : validCategories) {
            if (valid.equals(category)) {
                return true;
            }
        }
        return false;
    }
}
