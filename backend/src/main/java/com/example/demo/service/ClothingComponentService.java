package com.example.demo.service;

import com.example.demo.entity.ClothingComponent;
import com.example.demo.repository.ClothingComponentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ClothingComponentService {

    @Autowired
    private ClothingComponentRepository clothingComponentRepository;

    /**
     * 获取所有服饰部件
     */
    public List<ClothingComponent> findAll() {
        return clothingComponentRepository.findAllByOrderBySortOrderAsc();
    }

    /**
     * 根据ID查找服饰部件
     */
    public Optional<ClothingComponent> findById(Long id) {
        return clothingComponentRepository.findById(id);
    }

    /**
     * 根据名称查找服饰部件
     */
    public Optional<ClothingComponent> findByName(String name) {
        return clothingComponentRepository.findByName(name);
    }

    /**
     * 根据类型查找服饰部件
     */
    public List<ClothingComponent> findByType(String type) {
        return clothingComponentRepository.findByTypeOrderBySortOrderAsc(type);
    }

    /**
     * 保存服饰部件
     */
    public ClothingComponent save(ClothingComponent component) {
        return clothingComponentRepository.save(component);
    }

    /**
     * 删除服饰部件
     */
    public void deleteById(Long id) {
        clothingComponentRepository.deleteById(id);
    }

    /**
     * 初始化默认的服饰部件数据
     */
    public void initDefaultComponents() {
        String[][] defaultData = {
            {"衣", "上身服饰", "汉服的上身部分，包括各种款式的上衣。", 
             "衣是汉服的上身部分，包括各种款式的上衣。根据形制、用途的不同，衣有多种分类。常见的上衣包括襦、衫、袄等。襦为短上衣，衫为单层上衣，袄为有衬里的上衣。衣的领型有交领、直领、圆领等多种形式，袖型有广袖、窄袖、琵琶袖等变化。不同朝代、不同场合的衣在款式、色彩、纹样上都有严格的规定，体现了汉服的礼仪性。衣的长度从短至腰到长及膝下不等，根据季节和场合选择合适的款式。衣的纹样装饰丰富多样，常见的有云纹、龙纹、凤纹等，体现了穿着者的身份和地位。", "1"},
            {"裳", "下身服饰", "汉服的下身部分，主要指裙装。",
             "裳是汉服的下身部分，主要指裙装。在古代，裳是男女皆可穿着的下装。裳的款式多样，包括单片裙、多片裙、马面裙等。不同形制的裳在裁剪和穿着方式上各有特点。裳的长度、幅数、褶数等都有特定的文化含义，体现了古人的审美观念和社会规范。随着时代发展，裳的款式不断丰富，成为汉服文化中的重要组成部分。裳的穿着方式讲究层次，通常内穿衬裙，外罩主裙，体现了汉服的层次感。裳的色彩搭配讲究和谐，常与上衣形成对比或呼应，展现整体美感。", "2"},
            {"袍", "一体服饰", "上下连属的长衣，有衬里的称袍。",
             "袍是上下连属的长衣，有衬里的称袍，是汉服中重要的服饰类型。袍的特点是保暖性好，适合秋冬季节穿着，也是正式场合的常见服饰。袍的款式包括直裾袍、曲裾袍等，不同款式适应不同的场合和身份。袍的长度一般到脚踝，袖子宽大，体现了汉服的庄重与大气。袍的颜色和纹样有严格的等级规定，不同品级的官员穿着不同颜色的袍服。袍的穿着方式讲究系带和配饰，体现了汉服的礼仪规范。", "3"},
            {"衫", "一体服饰", "单层的长衣，无衬里的称衫。",
             "衫是单层的长衣，无衬里的称衫，适合春夏季节穿着。衫的特点是轻薄透气，穿着舒适，是日常休闲的常见选择。衫的款式包括直领衫、交领衫等，面料多为丝绸、棉麻等轻薄材质。衫的长度变化多样，有长及脚踝的长衫，也有短至腰部的短衫。衫的颜色以素雅为主，常见的有白色、浅蓝、淡粉等清新色调。衫的穿着场合广泛，既可作为内衣，也可作为外衣，体现了汉服的实用性。", "4"},
            {"襦", "上衣", "短上衣，通常与裙搭配穿着。",
             "襦是短上衣，长度一般到腰部，通常与裙搭配穿着。襦的特点是短小精悍，便于活动，是女性日常穿着的主要上衣类型。襦的领型多为交领，也有对襟款式，袖子有窄袖和广袖之分。襦与裙的搭配形成了襦裙这一经典女装形制，历代款式变化丰富。襦的装饰精美，常在领口、袖口、下摆处绣有花纹，体现女性审美。襦的颜色选择丰富，可根据季节和场合搭配不同颜色的裙子。", "5"},
            {"裙", "下裳", "下身穿着的裙装，款式多样。",
             "裙是下身穿着的裙装，是女性汉服的重要组成部分。裙的款式多样，包括百褶裙、马面裙、月华裙等，每种都有独特的审美特点。裙的穿着位置有齐胸、齐腰、高腰之分，不同位置展现不同的身材比例。裙的面料多为丝绸、锦缎等，质地轻盈，行走时飘逸动人。裙的纹样装饰丰富，常见的有花卉、云纹、几何图案等。裙的色彩搭配讲究，常与上衣形成和谐或对比的视觉效果。", "6"},
            {"裤", "下裳", "下身穿着的裤装，便于活动。",
             "裤是下身穿着的裤装，便于活动，是实用的下装选择。古代的裤与现代有所不同，早期为无裆的胫衣，后发展为合裆裤。裤的款式包括长裤、短裤、灯笼裤等，适应不同的活动和场合。裤常穿在裙内作为衬裤，也可单独外穿，体现了汉服的层次感。裤的面料多为棉麻、丝绸等，注重舒适性和实用性。裤的系带设计便于调节松紧，适应不同身材和活动需求。", "7"},
            {"冠", "首服", "头上戴的冠帽，体现身份等级。",
             "冠是头上戴的冠帽，是汉服首服的重要组成部分，体现身份等级。冠的种类繁多，包括冕冠、通天冠、进贤冠等，不同冠代表不同身份。冠的佩戴有严格的礼仪规范，不同场合佩戴不同的冠。冠的制作工艺精湛，常用金玉、珠宝等装饰，体现尊贵地位。冠与服饰的搭配讲究和谐，形成完整的礼仪装束。除冠外，首服还包括巾、帽等，适应不同场合和身份需求。", "8"}
        };

        for (String[] data : defaultData) {
            Optional<ClothingComponent> existing = clothingComponentRepository.findByName(data[0]);
            if (existing.isEmpty()) {
                ClothingComponent component = new ClothingComponent();
                component.setName(data[0]);
                component.setType(data[1]);
                component.setDescription(data[2]);
                component.setContent(data[3]);
                component.setSortOrder(Integer.parseInt(data[4]));
                clothingComponentRepository.save(component);
            }
        }
    }
}
