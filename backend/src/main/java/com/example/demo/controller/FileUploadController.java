package com.example.demo.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/upload")
public class FileUploadController {

    // 上传目录路径
    private static final String UPLOAD_DIR = "E:/hanfu-cultural-platform/backend/uploads";

    @PostMapping("/image")
    public ResponseEntity<Map<String, Object>> uploadImage(
            @RequestParam("file") MultipartFile file, 
            @RequestParam(value = "type", defaultValue = "general") String type,
            @RequestParam(value = "id", required = false) Long id,
            @RequestParam(value = "index", required = false, defaultValue = "0") int index) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 检查文件是否为空
            if (file.isEmpty()) {
                response.put("success", false);
                response.put("message", "文件不能为空");
                return ResponseEntity.badRequest().body(response);
            }

            // 检查文件类型
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                response.put("success", false);
                response.put("message", "只能上传图片文件");
                return ResponseEntity.badRequest().body(response);
            }

            // 确定子目录
            String subDir = "general";
            switch (type) {
                case "basic_style":
                    subDir = "basic_style";
                    break;
                case "clothing_show":
                    subDir = "clothing_show";
                    break;
                case "pattern_symbol":
                    subDir = "pattern_symbol";
                    break;
                case "etiquette_posture":
                    subDir = "etiquette_posture";
                    break;
                case "festival_custom":
                    subDir = "festival_custom";
                    break;
                case "festival_gathering":
                    subDir = "festival_gathering";
                    break;
                case "exhibition":
                    subDir = "exhibition";
                    break;
                case "talk":
                    subDir = "talk";
                    break;
                case "shop":
                    subDir = "shop";
                    break;
                case "shopshow":
                    subDir = "shopshow";
                    break;
                case "community_post":
                    subDir = "community_post";
                    break;
            }

            // 创建上传目录
            File uploadDir = new File(UPLOAD_DIR, subDir);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 生成文件名
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            
            String filename;
            if (id != null) {
                // 如果提供了ID，使用ID作为文件名，支持多张图片
                if (index > 0) {
                    filename = id.toString() + "-" + index + extension;
                } else {
                    filename = id.toString() + extension;
                }
            } else {
                // 否则使用UUID
                filename = UUID.randomUUID().toString() + extension;
            }

            // 保存文件
            Path filePath = Paths.get(UPLOAD_DIR, subDir, filename);
            // 确保目录存在
            Files.createDirectories(filePath.getParent());
            // 覆盖已存在的文件
            Files.write(filePath, file.getBytes(), java.nio.file.StandardOpenOption.CREATE, java.nio.file.StandardOpenOption.TRUNCATE_EXISTING);

            // 返回文件访问路径
            String fileUrl;
            if ("community_post".equals(subDir)) {
                // 社区帖子图片使用特殊路径
                fileUrl = "/community_post/" + filename;
            } else {
                fileUrl = "/uploads/" + subDir + "/" + filename;
            }
            
            response.put("success", true);
            response.put("url", fileUrl);
            response.put("filename", filename);
            
            return ResponseEntity.ok(response);
            
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "文件上传失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    @DeleteMapping("/image")
    public ResponseEntity<Map<String, Object>> deleteImage(@RequestParam("url") String url) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 从URL中提取文件路径
            String filePath;
            if (url.startsWith("/community_post/")) {
                // 处理社区帖子图片路径
                filePath = "community_post/" + url.replace("/community_post/", "");
            } else {
                // 处理其他图片路径
                filePath = url.replace("/uploads/", "");
            }
            Path fullPath = Paths.get(UPLOAD_DIR, filePath);
            
            // 检查文件是否存在
            if (Files.exists(fullPath)) {
                // 删除文件
                Files.delete(fullPath);
                response.put("success", true);
                response.put("message", "图片删除成功");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "图片不存在");
                return ResponseEntity.badRequest().body(response);
            }
            
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "删除图片失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
}
