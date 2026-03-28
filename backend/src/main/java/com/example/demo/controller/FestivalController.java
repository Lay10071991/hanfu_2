package com.example.demo.controller;

import com.example.demo.entity.Festival;
import com.example.demo.repository.FestivalRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/festival")
public class FestivalController {

    @Autowired
    private FestivalRepository repository;

    @GetMapping
    public List<Festival> getAll() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Festival> getById(@PathVariable Long id) {
        return repository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Festival create(@RequestBody Festival festival) {
        return repository.save(festival);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Festival> update(@PathVariable Long id, @RequestBody Festival festival) {
        return repository.findById(id)
                .map(existing -> {
                    existing.setName(festival.getName());
                    existing.setDate(festival.getDate());
                    existing.setSeason(festival.getSeason());
                    existing.setImage(festival.getImage());
                    existing.setDescription(festival.getDescription());
                    existing.setCustoms(festival.getCustoms());
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
