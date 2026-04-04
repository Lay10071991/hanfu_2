package com.example.demo.controller;

import com.example.demo.entity.Lecture;
import com.example.demo.repository.LectureRepository;
import com.example.demo.service.LectureRegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/lectures")
public class LectureController {

    @Autowired
    private LectureRepository repository;

    @Autowired
    private LectureRegistrationService registrationService;

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

    // 报名相关API
    @PostMapping("/{id}/registration")
    public ResponseEntity<Map<String, Object>> register(@PathVariable Long id, @RequestBody Map<String, Long> request) {
        Long userId = request.get("userId");
        if (userId == null) {
            return ResponseEntity.badRequest().build();
        }

        boolean success = registrationService.register(userId, id);
        return ResponseEntity.ok(Map.of("success", success));
    }

    @DeleteMapping("/{id}/registration")
    public ResponseEntity<Map<String, Object>> cancelRegistration(@PathVariable Long id, @RequestParam Long userId) {
        boolean success = registrationService.cancelRegistration(userId, id);
        return ResponseEntity.ok(Map.of("success", success));
    }

    @GetMapping("/{id}/registration/check")
    public ResponseEntity<Map<String, Object>> checkRegistration(@PathVariable Long id, @RequestParam Long userId) {
        boolean isRegistered = registrationService.isRegistered(userId, id);
        return ResponseEntity.ok(Map.of("isRegistered", isRegistered));
    }

    @GetMapping("/{id}/registration/count")
    public ResponseEntity<Map<String, Long>> getRegistrationCount(@PathVariable Long id) {
        long count = registrationService.getRegistrationCount(id);
        return ResponseEntity.ok(Map.of("count", count));
    }
}