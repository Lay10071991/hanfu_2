package com.example.demo.controller;

import com.example.demo.entity.Festival;
import com.example.demo.service.FestivalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/festival")
public class FestivalAdminController {

    @Autowired
    private FestivalService festivalService;

    /**
     * 获取所有节日（管理端）
     */
    @GetMapping
    public List<Festival> getAll() {
        return festivalService.findAll();
    }

    /**
     * 根据ID获取节日
     */
    @GetMapping("/{id}")
    public ResponseEntity<Festival> getById(@PathVariable Long id) {
        return festivalService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 创建节日（不带图片）
     */
    @PostMapping
    public ResponseEntity<Festival> create(@RequestBody Festival festival) {
        Festival saved = festivalService.create(festival);
        return ResponseEntity.ok(saved);
    }

    /**
     * 创建节日（带图片上传）
     * 使用multipart/form-data格式
     */
    @PostMapping("/with-image")
    public ResponseEntity<Map<String, Object>> createWithImage(
            @RequestParam("name") String name,
            @RequestParam("date") String date,
            @RequestParam("season") String season,
            @RequestParam("description") String description,
            @RequestParam(value = "customs", required = false) String customs,
            @RequestParam(value = "image", required = false) MultipartFile imageFile) {

        Map<String, Object> response = new HashMap<>();

        try {
            Festival festival = new Festival();
            festival.setName(name);
            festival.setDate(date);
            festival.setSeason(season);
            festival.setDescription(description);
            festival.setCustoms(customs);

            Festival saved = festivalService.createWithImage(festival, imageFile);

            response.put("success", true);
            response.put("message", "节日创建成功");
            response.put("data", saved);
            return ResponseEntity.ok(response);

        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "图片上传失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 更新节日（不带图片）
     */
    @PutMapping("/{id}")
    public ResponseEntity<Festival> update(@PathVariable Long id, @RequestBody Festival festival) {
        return festivalService.update(id, festival)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 更新节日（带图片更新）
     * 如果上传了新图片，会自动删除旧图片
     */
    @PutMapping("/{id}/with-image")
    public ResponseEntity<Map<String, Object>> updateWithImage(
            @PathVariable Long id,
            @RequestParam("name") String name,
            @RequestParam("date") String date,
            @RequestParam("season") String season,
            @RequestParam("description") String description,
            @RequestParam(value = "customs", required = false) String customs,
            @RequestParam(value = "image", required = false) MultipartFile imageFile) {

        Map<String, Object> response = new HashMap<>();

        try {
            Festival festival = new Festival();
            festival.setName(name);
            festival.setDate(date);
            festival.setSeason(season);
            festival.setDescription(description);
            festival.setCustoms(customs);

            return festivalService.updateWithImage(id, festival, imageFile)
                    .map(updated -> {
                        response.put("success", true);
                        response.put("message", "节日更新成功");
                        response.put("data", updated);
                        return ResponseEntity.ok(response);
                    })
                    .orElse(ResponseEntity.notFound().build());

        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "图片更新失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        } catch (RuntimeException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 仅更新节日图片
     */
    @PutMapping("/{id}/image")
    public ResponseEntity<Map<String, Object>> updateImageOnly(
            @PathVariable Long id,
            @RequestParam("image") MultipartFile imageFile) {

        Map<String, Object> response = new HashMap<>();

        if (imageFile == null || imageFile.isEmpty()) {
            response.put("success", false);
            response.put("message", "图片文件不能为空");
            return ResponseEntity.badRequest().body(response);
        }

        try {
            return festivalService.updateImageOnly(id, imageFile)
                    .map(updated -> {
                        response.put("success", true);
                        response.put("message", "图片更新成功");
                        response.put("imagePath", updated.getImage());
                        return ResponseEntity.ok(response);
                    })
                    .orElse(ResponseEntity.notFound().build());

        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "图片更新失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 删除节日（同时删除关联图片）
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> delete(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();

        boolean deleted = festivalService.delete(id);

        if (deleted) {
            response.put("success", true);
            response.put("message", "节日删除成功");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "节日不存在");
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * 批量删除节日
     */
    @DeleteMapping("/batch")
    public ResponseEntity<Map<String, Object>> deleteBatch(@RequestBody List<Long> ids) {
        Map<String, Object> response = new HashMap<>();

        festivalService.deleteBatch(ids);

        response.put("success", true);
        response.put("message", "批量删除成功");
        return ResponseEntity.ok(response);
    }
}
