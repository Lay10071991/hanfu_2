package com.example.demo.controller;

import com.example.demo.entity.Festival;
import com.example.demo.service.FestivalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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
     * 创建节日
     */
    @PostMapping
    public ResponseEntity<Festival> create(@RequestBody Festival festival) {
        Festival saved = festivalService.create(festival);
        return ResponseEntity.ok(saved);
    }

    /**
     * 更新节日
     */
    @PutMapping("/{id}")
    public ResponseEntity<Festival> update(@PathVariable Long id, @RequestBody Festival festival) {
        return festivalService.update(id, festival)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 删除节日
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
