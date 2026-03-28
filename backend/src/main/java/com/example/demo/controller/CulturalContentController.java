package com.example.demo.controller;

import com.example.demo.entity.CulturalContent;
import com.example.demo.repository.CulturalContentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cultural-content")
public class CulturalContentController {

    @Autowired
    private CulturalContentRepository repository;

    @GetMapping
    public List<CulturalContent> getAll() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<CulturalContent> getById(@PathVariable Long id) {
        return repository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public CulturalContent create(@RequestBody CulturalContent content) {
        return repository.save(content);
    }

    @PutMapping("/{id}")
    public ResponseEntity<CulturalContent> update(@PathVariable Long id, @RequestBody CulturalContent content) {
        return repository.findById(id)
                .map(existing -> {
                    existing.setTitle(content.getTitle());
                    existing.setContent(content.getContent());
                    existing.setType(content.getType());
                    existing.setName(content.getName());
                    existing.setYears(content.getYears());
                    return ResponseEntity.ok(repository.save(existing));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        repository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
