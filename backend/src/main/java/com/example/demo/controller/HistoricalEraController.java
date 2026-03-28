package com.example.demo.controller;

import com.example.demo.entity.HistoricalEra;
import com.example.demo.repository.HistoricalEraRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/historical-era")
public class HistoricalEraController {

    @Autowired
    private HistoricalEraRepository repository;

    @GetMapping
    public List<HistoricalEra> getAll() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<HistoricalEra> getById(@PathVariable Long id) {
        return repository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public HistoricalEra create(@RequestBody HistoricalEra historicalEra) {
        return repository.save(historicalEra);
    }

    @PutMapping("/{id}")
    public ResponseEntity<HistoricalEra> update(@PathVariable Long id, @RequestBody HistoricalEra historicalEra) {
        return repository.findById(id)
                .map(existing -> {
                    existing.setName(historicalEra.getName());
                    existing.setYears(historicalEra.getYears());
                    existing.setTitle(historicalEra.getTitle());
                    existing.setDescription(historicalEra.getDescription());
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
