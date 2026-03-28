package com.example.demo.service;

import com.example.demo.entity.Image;
import com.example.demo.repository.ImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Service
public class ImageService {

    @Autowired
    private ImageRepository imageRepository;

    @Value("${image.upload.base-path:E:/hanfu-cultural-platform-3/hanfu-cultural-platform/hanfu-cultural-platform/frontend/public}")
    private String basePath;

    @Value("${image.access.base-url:}")
    private String baseUrl;

    // 支持的图片格式
    private static final Set<String> ALLOWED_EXTENSIONS = new HashSet<>(Arrays.asList(
        "jpg", "jpeg", "png", "gif", "webp"
    ));

    // 支持的Content-Type
    private static final Set<String> ALLOWED_CONTENT_TYPES = new HashSet<>(Arrays.asList(
        "image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"
    ));

    // 最大文件大小 10MB
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;

    /**
     * 上传图片到指定类别文件夹
     *
     * @param file     图片文件
     * @param category 图片类别 (如: festivals, exhibitions, shop-hanfu等)
     * @return 图片的相对路径 (如: /festivals/yuanxiao.jpg)
     * @throws IOException 当文件操作失败时
     */
    @Transactional
    public String uploadImage(MultipartFile file, String category) throws IOException {
        validateFile(file);

        // 构建目标目录路径
        Path targetDir = Paths.get(basePath, category);
        if (!Files.exists(targetDir)) {
            Files.createDirectories(targetDir);
        }

        // 生成唯一文件名
        String originalFilename = file.getOriginalFilename();
        String extension = getFileExtension(originalFilename);
        String filename = UUID.randomUUID().toString() + "." + extension;

        // 保存文件
        Path filePath = targetDir.resolve(filename);
        Files.write(filePath, file.getBytes());

        // 保存图片信息到数据库
        Image imageEntity = new Image();
        imageEntity.setPath("/" + category + "/" + filename);
        imageEntity.setCategory(category);
        imageEntity.setFileName(filename);
        imageEntity.setMimeType(file.getContentType());
        imageEntity.setFileSize(file.getSize());
        imageEntity.setStatus("active");
        imageRepository.save(imageEntity);

        // 返回相对路径
        return "/" + category + "/" + filename;
    }

    /**
     * 上传图片并指定自定义文件名
     *
     * @param file     图片文件
     * @param category 图片类别
     * @param customName 自定义文件名 (不含扩展名)
     * @return 图片的相对路径
     * @throws IOException 当文件操作失败时
     */
    @Transactional
    public String uploadImageWithName(MultipartFile file, String category, String customName) throws IOException {
        validateFile(file);

        // 构建目标目录路径
        Path targetDir = Paths.get(basePath, category);
        if (!Files.exists(targetDir)) {
            Files.createDirectories(targetDir);
        }

        // 使用自定义文件名
        String extension = getFileExtension(file.getOriginalFilename());
        String filename = customName + "." + extension;

        // 保存文件
        Path filePath = targetDir.resolve(filename);
        Files.write(filePath, file.getBytes());

        // 保存图片信息到数据库
        Image imageEntity = new Image();
        imageEntity.setPath("/" + category + "/" + filename);
        imageEntity.setCategory(category);
        imageEntity.setFileName(filename);
        imageEntity.setMimeType(file.getContentType());
        imageEntity.setFileSize(file.getSize());
        imageEntity.setStatus("active");
        imageRepository.save(imageEntity);

        // 返回相对路径
        return "/" + category + "/" + filename;
    }

    /**
     * 上传图片并关联到实体
     *
     * @param file       图片文件
     * @param category   图片类别
     * @param entityType 实体类型 (如: festival, shop, activity等)
     * @param entityId   实体ID
     * @return 图片的相对路径
     * @throws IOException 当文件操作失败时
     */
    @Transactional
    public String uploadImageWithEntity(MultipartFile file, String category, String entityType, Long entityId) throws IOException {
        String imagePath = uploadImage(file, category);

        // 更新图片记录，关联到实体
        Image imageEntity = imageRepository.findByPath(imagePath).orElse(null);
        if (imageEntity != null) {
            imageEntity.setEntityType(entityType);
            imageEntity.setEntityId(entityId);
            imageRepository.save(imageEntity);
        }

        return imagePath;
    }

    /**
     * 更新图片（删除旧图片，保存新图片）
     *
     * @param file       新图片文件
     * @param category   图片类别
     * @param oldImagePath 旧图片的相对路径 (如: /festivals/yuanxiao-old.jpg)
     * @return 新图片的相对路径
     * @throws IOException 当文件操作失败时
     */
    @Transactional
    public String updateImage(MultipartFile file, String category, String oldImagePath) throws IOException {
        // 先删除旧图片
        if (oldImagePath != null && !oldImagePath.isEmpty()) {
            deleteImage(oldImagePath);
        }

        // 上传新图片
        return uploadImage(file, category);
    }

    /**
     * 更新图片并保持实体关联
     *
     * @param file         新图片文件
     * @param category     图片类别
     * @param oldImagePath 旧图片的相对路径
     * @param entityType   实体类型
     * @param entityId     实体ID
     * @return 新图片的相对路径
     * @throws IOException 当文件操作失败时
     */
    @Transactional
    public String updateImageWithEntity(MultipartFile file, String category, String oldImagePath, String entityType, Long entityId) throws IOException {
        // 获取旧图片的实体关联信息
        String oldEntityType = null;
        Long oldEntityId = null;

        if (oldImagePath != null && !oldImagePath.isEmpty()) {
            Image oldImage = imageRepository.findByPath(oldImagePath).orElse(null);
            if (oldImage != null) {
                oldEntityType = oldImage.getEntityType();
                oldEntityId = oldImage.getEntityId();
            }
        }

        // 如果没有提供新的实体信息，使用旧的
        if (entityType == null) {
            entityType = oldEntityType;
        }
        if (entityId == null) {
            entityId = oldEntityId;
        }

        // 删除旧图片
        if (oldImagePath != null && !oldImagePath.isEmpty()) {
            deleteImage(oldImagePath);
        }

        // 上传新图片并关联到实体
        if (entityType != null && entityId != null) {
            return uploadImageWithEntity(file, category, entityType, entityId);
        } else {
            return uploadImage(file, category);
        }
    }

    /**
     * 删除图片
     *
     * @param imagePath 图片的相对路径 (如: /festivals/yuanxiao.jpg)
     * @return 是否删除成功
     */
    @Transactional
    public boolean deleteImage(String imagePath) {
        if (imagePath == null || imagePath.isEmpty()) {
            return false;
        }

        try {
            // 移除开头的斜杠
            String relativePath = imagePath.startsWith("/") ? imagePath.substring(1) : imagePath;
            Path filePath = Paths.get(basePath, relativePath);

            File file = filePath.toFile();
            if (file.exists() && file.isFile()) {
                // 删除物理文件
                boolean fileDeleted = file.delete();

                // 删除数据库记录
                Image imageEntity = imageRepository.findByPath(imagePath).orElse(null);
                if (imageEntity != null) {
                    imageRepository.delete(imageEntity);
                }

                return fileDeleted;
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 删除实体的所有图片
     *
     * @param entityType 实体类型
     * @param entityId   实体ID
     * @return 删除的图片数量
     */
    @Transactional
    public int deleteEntityImages(String entityType, Long entityId) {
        List<Image> images = imageRepository.findByEntityTypeAndEntityId(entityType, entityId);
        int count = 0;

        for (Image image : images) {
            if (deleteImage(image.getPath())) {
                count++;
            }
        }

        return count;
    }

    /**
     * 验证文件是否合法
     *
     * @param file 待验证的文件
     * @throws IllegalArgumentException 当文件不合法时
     */
    public void validateFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("文件不能为空");
        }

        // 检查文件大小
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("文件大小不能超过10MB");
        }

        // 检查Content-Type
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase())) {
            throw new IllegalArgumentException("不支持的图片格式，仅支持: jpg, jpeg, png, gif, webp");
        }

        // 检查文件扩展名
        String extension = getFileExtension(file.getOriginalFilename());
        if (!ALLOWED_EXTENSIONS.contains(extension.toLowerCase())) {
            throw new IllegalArgumentException("不支持的文件扩展名，仅支持: jpg, jpeg, png, gif, webp");
        }
    }

    /**
     * 获取文件扩展名
     *
     * @param filename 文件名
     * @return 扩展名 (不含点)
     */
    public String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "jpg";
        }
        return filename.substring(filename.lastIndexOf(".") + 1).toLowerCase();
    }

    /**
     * 获取完整的图片访问URL
     *
     * @param imagePath 图片相对路径
     * @return 完整的URL
     */
    public String getFullImageUrl(String imagePath) {
        if (imagePath == null || imagePath.isEmpty()) {
            return "";
        }
        return baseUrl + imagePath;
    }

    /**
     * 检查图片是否存在
     *
     * @param imagePath 图片相对路径
     * @return 是否存在
     */
    public boolean imageExists(String imagePath) {
        if (imagePath == null || imagePath.isEmpty()) {
            return false;
        }

        try {
            String relativePath = imagePath.startsWith("/") ? imagePath.substring(1) : imagePath;
            Path filePath = Paths.get(basePath, relativePath);
            return Files.exists(filePath) && Files.isRegularFile(filePath);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 根据实体获取图片列表
     *
     * @param entityType 实体类型
     * @param entityId   实体ID
     * @return 图片列表
     */
    public List<Image> getImagesByEntity(String entityType, Long entityId) {
        return imageRepository.findByEntityTypeAndEntityId(entityType, entityId);
    }

    /**
     * 根据类别获取图片列表
     *
     * @param category 图片类别
     * @return 图片列表
     */
    public List<Image> getImagesByCategory(String category) {
        return imageRepository.findByCategory(category);
    }

    /**
     * 获取图片信息
     *
     * @param imagePath 图片相对路径
     * @return 图片信息
     */
    public Image getImageInfo(String imagePath) {
        return imageRepository.findByPath(imagePath).orElse(null);
    }
}
