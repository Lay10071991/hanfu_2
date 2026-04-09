package com.example.demo.controller;

import com.example.demo.entity.HanfuDisplay;
import com.example.demo.entity.HanfuImage;
import com.example.demo.service.HanfuDisplayService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/hanfu-display")
public class HanfuDisplayController {

    @Autowired
    private HanfuDisplayService hanfuDisplayService;

    @GetMapping
    public List<HanfuDisplay> getAllHanfuDisplays() {
        return hanfuDisplayService.getAllHanfuDisplays();
    }

    @GetMapping("/{id}")
    public HanfuDisplay getHanfuDisplayById(@PathVariable Long id) {
        return hanfuDisplayService.getHanfuDisplayById(id);
    }

    @GetMapping("/{id}/images")
    public List<HanfuImage> getImagesByHanfuId(@PathVariable Long id) {
        return hanfuDisplayService.getImagesByHanfuId(id);
    }

    @PostMapping
    public HanfuDisplay createHanfuDisplay(@RequestBody HanfuDisplay hanfuDisplay) {
        return hanfuDisplayService.createHanfuDisplay(hanfuDisplay);
    }

    @PutMapping("/{id}")
    public HanfuDisplay updateHanfuDisplay(@PathVariable Long id, @RequestBody HanfuDisplay hanfuDisplay) {
        return hanfuDisplayService.updateHanfuDisplay(id, hanfuDisplay);
    }

    @DeleteMapping("/{id}")
    public void deleteHanfuDisplay(@PathVariable Long id) {
        hanfuDisplayService.deleteHanfuDisplay(id);
    }

    @PostMapping("/{id}/images")
    public void saveHanfuImages(@PathVariable Long id, @RequestBody List<String> imagePaths) {
        hanfuDisplayService.saveHanfuImages(id, imagePaths);
    }
}
