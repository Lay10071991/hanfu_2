package com.example.demo.controller;

import com.example.demo.entity.Lecture;
import com.example.demo.repository.LectureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/lectures")
public class LectureController {

    @Autowired
    private LectureRepository repository;

    @GetMapping
    public List<Lecture> getAll() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Lecture> getById(@PathVariable Long id) {
        return repository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Lecture create(@RequestBody Lecture lecture) {
        return repository.save(lecture);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Lecture> update(@PathVariable Long id, @RequestBody Lecture lecture) {
        return repository.findById(id)
                .map(existing -> {
                    existing.setTitle(lecture.getTitle());
                    existing.setSpeaker(lecture.getSpeaker());
                    existing.setDescription(lecture.getDescription());
                    existing.setLocation(lecture.getLocation());
                    existing.setStartTime(lecture.getStartTime());
                    existing.setEndTime(lecture.getEndTime());
                    existing.setCapacity(lecture.getCapacity());
                    existing.setRegisteredCount(lecture.getRegisteredCount());
                    existing.setImage(lecture.getImage());
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