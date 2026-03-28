package com.example.demo.controller;

import com.example.demo.entity.ShapeType;
import com.example.demo.service.ShapeTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/shape-type")
public class ShapeTypeController {

    @Autowired
    private ShapeTypeService shapeTypeService;

    /**
     * 获取所有形制分类
     *
     * @return 形制分类列表
     */
    @GetMapping
    public ResponseEntity<List<ShapeType>> findAll() {
        return ResponseEntity.ok(shapeTypeService.findAll());
    }

    /**
     * 获取前4个形制分类（用于首页展示）
     *
     * @return 形制分类列表
     */
    @GetMapping("/top4")
    public ResponseEntity<List<ShapeType>> findTop4() {
        return ResponseEntity.ok(shapeTypeService.findTop4());
    }

    /**
     * 根据ID获取形制分类
     *
     * @param id ID
     * @return 形制分类
     */
    @GetMapping("/{id}")
    public ResponseEntity<ShapeType> findById(@PathVariable Long id) {
        return shapeTypeService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 创建形制分类
     *
     * @param shapeType 形制分类
     * @return 创建后的形制分类
     */
    @PostMapping
    public ResponseEntity<ShapeType> create(@RequestBody ShapeType shapeType) {
        return ResponseEntity.ok(shapeTypeService.save(shapeType));
    }

    /**
     * 更新形制分类
     *
     * @param id        ID
     * @param shapeType 形制分类
     * @return 更新后的形制分类
     */
    @PutMapping("/{id}")
    public ResponseEntity<ShapeType> update(@PathVariable Long id, @RequestBody ShapeType shapeType) {
        shapeType.setId(id);
        return ResponseEntity.ok(shapeTypeService.save(shapeType));
    }

    /**
     * 删除形制分类
     *
     * @param id ID
     * @return 删除结果
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> delete(@PathVariable Long id) {
        shapeTypeService.deleteById(id);
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "删除成功");
        return ResponseEntity.ok(response);
    }

    /**
     * 初始化默认形制分类数据
     *
     * @return 初始化结果
     */
    @PostMapping("/init")
    public ResponseEntity<Map<String, Object>> initDefault() {
        shapeTypeService.initDefaultShapeTypes();
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "初始化成功");
        return ResponseEntity.ok(response);
    }
}
