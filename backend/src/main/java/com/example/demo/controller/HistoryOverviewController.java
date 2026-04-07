package com.example.demo.controller;

import com.example.demo.entity.HistoryOverview;
import com.example.demo.repository.HistoryOverviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/history-overview")
@CrossOrigin(origins = "*")
public class HistoryOverviewController {
    @Autowired
    private HistoryOverviewRepository historyOverviewRepository;
    
    @GetMapping
    public List<HistoryOverview> getAllHistoryOverview() {
        return historyOverviewRepository.findAll();
    }
    
    @PutMapping("/{id}")
    public HistoryOverview updateHistoryOverview(@PathVariable Long id, @RequestBody HistoryOverview historyOverview) {
        historyOverview.setId(id);
        return historyOverviewRepository.save(historyOverview);
    }
}
