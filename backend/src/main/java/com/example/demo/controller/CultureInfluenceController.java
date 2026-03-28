package com.example.demo.controller;

import com.example.demo.entity.CultureInfluence;
import com.example.demo.service.CultureInfluenceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/culture-influence")
public class CultureInfluenceController {

    @Autowired
    private CultureInfluenceService cultureInfluenceService;

    /**
     * 获取所有文化影响
     *
     * @return 文化影响列表
     */
    @GetMapping
    public ResponseEntity<List<CultureInfluence>> findAll() {
        return ResponseEntity.ok(cultureInfluenceService.findAll());
    }

    /**
     * 根据ID获取文化影响
     *
     * @param id ID
     * @return 文化影响
     */
    @GetMapping("/{id}")
    public ResponseEntity<CultureInfluence> findById(@PathVariable Long id) {
        return cultureInfluenceService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 创建文化影响
     *
     * @param cultureInfluence 文化影响
     * @return 创建后的文化影响
     */
    @PostMapping
    public ResponseEntity<CultureInfluence> create(@RequestBody CultureInfluence cultureInfluence) {
        CultureInfluence saved = cultureInfluenceService.save(cultureInfluence);
        return ResponseEntity.ok(saved);
    }

    /**
     * 更新文化影响
     *
     * @param id ID
     * @param cultureInfluence 文化影响
     * @return 更新后的文化影响
     */
    @PutMapping("/{id}")
    public ResponseEntity<CultureInfluence> update(@PathVariable Long id, @RequestBody CultureInfluence cultureInfluence) {
        if (!cultureInfluenceService.findById(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        cultureInfluence.setId(id);
        CultureInfluence updated = cultureInfluenceService.save(cultureInfluence);
        return ResponseEntity.ok(updated);
    }

    /**
     * 删除文化影响
     *
     * @param id ID
     * @return 删除结果
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> delete(@PathVariable Long id) {
        Map<String, String> response = new HashMap<>();
        if (!cultureInfluenceService.findById(id).isPresent()) {
            response.put("message", "文化影响不存在");
            return ResponseEntity.notFound().build();
        }
        cultureInfluenceService.deleteById(id);
        response.put("message", "删除成功");
        return ResponseEntity.ok(response);
    }
}
