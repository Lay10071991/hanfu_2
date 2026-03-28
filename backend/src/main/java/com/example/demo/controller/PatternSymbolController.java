package com.example.demo.controller;

import com.example.demo.entity.PatternSymbol;
import com.example.demo.repository.PatternSymbolRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/pattern-symbol")
public class PatternSymbolController {

    @Autowired
    private PatternSymbolRepository repository;

    @GetMapping
    public List<PatternSymbol> getAll() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<PatternSymbol> getById(@PathVariable Long id) {
        return repository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public PatternSymbol create(@RequestBody PatternSymbol patternSymbol) {
        return repository.save(patternSymbol);
    }

    @PutMapping("/{id}")
    public ResponseEntity<PatternSymbol> update(@PathVariable Long id, @RequestBody PatternSymbol patternSymbol) {
        return repository.findById(id)
                .map(existing -> {
                    existing.setName(patternSymbol.getName());
                    existing.setMeaning(patternSymbol.getMeaning());
                    existing.setImage(patternSymbol.getImage());
                    existing.setDescription(patternSymbol.getDescription());
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
