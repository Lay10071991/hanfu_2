package com.example.demo.controller;

import com.example.demo.entity.Evaluation;
import com.example.demo.service.EvaluationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/evaluations")
public class EvaluationController {
    
    @Autowired
    private EvaluationService evaluationService;
    
    @GetMapping("/shop/{shopId}")
    public ResponseEntity<List<Evaluation>> getEvaluationsByShopId(@PathVariable Long shopId) {
        List<Evaluation> evaluations = evaluationService.getEvaluationsByShopId(shopId);
        return ResponseEntity.ok(evaluations);
    }
    
    @PostMapping
    public ResponseEntity<Evaluation> createEvaluation(@RequestBody Evaluation evaluation) {
        Evaluation created = evaluationService.createEvaluation(evaluation);
        return ResponseEntity.ok(created);
    }
}
