package com.example.demo.controller;

import com.example.demo.entity.Exhibition;
import com.example.demo.repository.ExhibitionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/exhibitions")
public class ExhibitionController {

    @Autowired
    private ExhibitionRepository repository;

    @GetMapping
    public List<Exhibition> getAll() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Exhibition> getById(@PathVariable Long id) {
        return repository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Exhibition create(@RequestBody Exhibition exhibition) {
        return repository.save(exhibition);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Exhibition> update(@PathVariable Long id, @RequestBody Exhibition exhibition) {
        return repository.findById(id)
                .map(existing -> {
                    existing.setTitle(exhibition.getTitle());
                    existing.setOrganizer(exhibition.getOrganizer());
                    existing.setDescription(exhibition.getDescription());
                    existing.setLocation(exhibition.getLocation());
                    existing.setStartDate(exhibition.getStartDate());
                    existing.setEndDate(exhibition.getEndDate());
                    existing.setOpeningHours(exhibition.getOpeningHours());
                    existing.setTicketPrice(exhibition.getTicketPrice());
                    existing.setImage(exhibition.getImage());
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