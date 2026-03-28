package com.example.demo.controller;

import com.example.demo.entity.ClothingComponent;
import com.example.demo.service.ClothingComponentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/component")
public class ClothingComponentController {

    @Autowired
    private ClothingComponentService clothingComponentService;

    /**
     * 获取所有服饰部件
     */
    @GetMapping
    public ResponseEntity<List<ClothingComponent>> getAllComponents() {
        return ResponseEntity.ok(clothingComponentService.findAll());
    }

    /**
     * 根据ID获取服饰部件
     */
    @GetMapping("/{id}")
    public ResponseEntity<ClothingComponent> getComponentById(@PathVariable Long id) {
        return clothingComponentService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 根据名称获取服饰部件
     */
    @GetMapping("/name/{name}")
    public ResponseEntity<ClothingComponent> getComponentByName(@PathVariable String name) {
        return clothingComponentService.findByName(name)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 根据类型获取服饰部件
     */
    @GetMapping("/type/{type}")
    public ResponseEntity<List<ClothingComponent>> getComponentsByType(@PathVariable String type) {
        return ResponseEntity.ok(clothingComponentService.findByType(type));
    }

    /**
     * 创建服饰部件
     */
    @PostMapping
    public ResponseEntity<ClothingComponent> createComponent(@RequestBody ClothingComponent component) {
        return ResponseEntity.ok(clothingComponentService.save(component));
    }

    /**
     * 更新服饰部件
     */
    @PutMapping("/{id}")
    public ResponseEntity<ClothingComponent> updateComponent(@PathVariable Long id, @RequestBody ClothingComponent component) {
        return clothingComponentService.findById(id)
                .map(existing -> {
                    component.setId(id);
                    return ResponseEntity.ok(clothingComponentService.save(component));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 删除服饰部件
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteComponent(@PathVariable Long id) {
        return clothingComponentService.findById(id)
                .map(component -> {
                    clothingComponentService.deleteById(id);
                    return ResponseEntity.ok().<Void>build();
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
