package com.example.demo.service;

import com.example.demo.entity.ShapeType;
import com.example.demo.repository.ShapeTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ShapeTypeService {

    @Autowired
    private ShapeTypeRepository shapeTypeRepository;

    /**
     * 获取所有形制分类
     *
     * @return 形制分类列表
     */
    public List<ShapeType> findAll() {
        return shapeTypeRepository.findAllByOrderBySortOrderAsc();
    }

    /**
     * 获取前4个形制分类（用于首页展示）
     *
     * @return 形制分类列表
     */
    public List<ShapeType> findTop4() {
        return shapeTypeRepository.findTop4ByOrderBySortOrderAsc();
    }

    /**
     * 根据ID查找形制分类
     *
     * @param id ID
     * @return 形制分类
     */
    public Optional<ShapeType> findById(Long id) {
        return shapeTypeRepository.findById(id);
    }

    /**
     * 根据名称查找形制分类
     *
     * @param name 名称
     * @return 形制分类
     */
    public Optional<ShapeType> findByName(String name) {
        return shapeTypeRepository.findByName(name);
    }

    /**
     * 保存形制分类
     *
     * @param shapeType 形制分类
     * @return 保存后的形制分类
     */
    public ShapeType save(ShapeType shapeType) {
        return shapeTypeRepository.save(shapeType);
    }

    /**
     * 删除形制分类
     *
     * @param id ID
     */
    public void deleteById(Long id) {
        shapeTypeRepository.deleteById(id);
    }

    /**
     * 初始化默认的4种形制分类数据
     */
    public void initDefaultShapeTypes() {
        String[][] defaultData = {
            {"深衣制", "战国至明代", "上下连属的服饰，将上衣下裳连为一体，体现深意。",
             "上下连属、端庄大方、适用广泛", "深衣是中国古代最具代表性的服饰之一，其特点是将上衣和下裳连在一起，用不同颜色的布料象征天地。深衣在战国时期开始流行，一直沿用到明代。", "1"},
            {"衣裳制", "先秦至明清", "上衣下裳的基本形制，最古老的汉服形式，象征天地秩序。",
             "上下分裁、庄严正统、礼仪性强", "衣裳制是汉服最基本的形制，上衣代表天，下裳代表地，体现了中国古代天人合一的哲学思想。这种形制在先秦时期就已经成熟。", "2"},
            {"襦裙制", "历代流行", "上衣下裙的女装组合，历代款式变化丰富多样。",
             "上衣下裙、款式多样、女性特色", "襦裙是汉服女装的主要形制，由短上衣（襦）和裙子组成。历代襦裙款式变化丰富，有齐胸襦裙、齐腰襦裙、高腰襦裙等多种形式。", "3"},
            {"袍服制", "汉代以后", "一体裁剪的长衣，便于活动，逐渐成为日常服饰。",
             "一体裁剪、便于活动、日常实用", "袍服是一体裁剪的长衣，有衬里的称袍，无衬里的称衫。袍服便于活动，逐渐成为日常服饰，在汉代以后广泛流行。", "4"}
        };

        for (String[] data : defaultData) {
            String name = data[0];
            if (shapeTypeRepository.findByName(name).isEmpty()) {
                ShapeType shapeType = new ShapeType();
                shapeType.setName(name);
                shapeType.setPeriod(data[1]);
                shapeType.setDescription(data[2]);
                shapeType.setCharacteristics(data[3]);
                shapeType.setContent(data[4]);
                shapeType.setSortOrder(Integer.parseInt(data[5]));
                shapeTypeRepository.save(shapeType);
            }
        }
    }
}
