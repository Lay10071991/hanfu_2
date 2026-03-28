package com.example.demo.controller;

import com.example.demo.entity.Etiquette;
import com.example.demo.repository.EtiquetteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/etiquette")
public class EtiquetteController {

    @Autowired
    private EtiquetteRepository repository;

    @GetMapping
    public List<Etiquette> getAll() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Etiquette> getById(@PathVariable Long id) {
        return repository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Etiquette create(@RequestBody Etiquette etiquette) {
        return repository.save(etiquette);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Etiquette> update(@PathVariable Long id, @RequestBody Etiquette etiquette) {
        return repository.findById(id)
                .map(existing -> {
                    existing.setName(etiquette.getName());
                    existing.setPeriod(etiquette.getPeriod());
                    existing.setCategory(etiquette.getCategory());
                    existing.setImage(etiquette.getImage());
                    existing.setDescription(etiquette.getDescription());
                    existing.setFeatures(etiquette.getFeatures());
                    existing.setSteps(etiquette.getSteps());
                    existing.setNote(etiquette.getNote());
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
