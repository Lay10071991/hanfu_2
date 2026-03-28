package com.example.demo.service;

import com.example.demo.entity.CultureInfluence;
import com.example.demo.repository.CultureInfluenceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CultureInfluenceService {

    @Autowired
    private CultureInfluenceRepository cultureInfluenceRepository;

    /**
     * 获取所有文化影响
     *
     * @return 文化影响列表
     */
    public List<CultureInfluence> findAll() {
        return cultureInfluenceRepository.findAllByOrderByIdAsc();
    }

    /**
     * 根据ID查找文化影响
     *
     * @param id ID
     * @return 文化影响
     */
    public Optional<CultureInfluence> findById(Long id) {
        return cultureInfluenceRepository.findById(id);
    }

    /**
     * 保存文化影响
     *
     * @param cultureInfluence 文化影响
     * @return 保存后的文化影响
     */
    public CultureInfluence save(CultureInfluence cultureInfluence) {
        return cultureInfluenceRepository.save(cultureInfluence);
    }

    /**
     * 根据ID删除文化影响
     *
     * @param id ID
     */
    public void deleteById(Long id) {
        cultureInfluenceRepository.deleteById(id);
    }
}
