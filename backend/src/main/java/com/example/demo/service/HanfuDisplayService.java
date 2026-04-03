package com.example.demo.service;

import com.example.demo.entity.HanfuDisplay;
import com.example.demo.entity.HanfuImage;
import com.example.demo.repository.HanfuDisplayRepository;
import com.example.demo.repository.HanfuImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HanfuDisplayService {

    @Autowired
    private HanfuDisplayRepository hanfuDisplayRepository;

    @Autowired
    private HanfuImageRepository hanfuImageRepository;

    public List<HanfuDisplay> getAllHanfuDisplays() {
        return hanfuDisplayRepository.findAll();
    }

    public HanfuDisplay getHanfuDisplayById(Long id) {
        return hanfuDisplayRepository.findById(id).orElse(null);
    }

    public List<HanfuImage> getImagesByHanfuId(Long hanfuId) {
        return hanfuImageRepository.findByHanfuId(hanfuId);
    }
}
