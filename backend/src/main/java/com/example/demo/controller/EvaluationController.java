package com.example.demo.controller;

import com.example.demo.entity.ShopReview;
import com.example.demo.service.EvaluationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/evaluations")
public class EvaluationController {
    
    @Autowired
    private EvaluationService evaluationService;
    
    @GetMapping("/shop/{shopId}")
    public List<ShopReview> getEvaluationsByShopId(@PathVariable Long shopId) {
        return evaluationService.getEvaluationsByShopId(shopId);
    }
    
    @PostMapping
    public ShopReview createEvaluation(@RequestBody ShopReview review) {
        return evaluationService.createEvaluation(review);
    }
}