package com.example.demo.config;

import com.example.demo.entity.ClothingComponent;
import com.example.demo.entity.CultureInfluence;
import com.example.demo.entity.PatternSymbol;
import com.example.demo.entity.Etiquette;
import com.example.demo.entity.Festival;
import com.example.demo.entity.ShapeType;
import com.example.demo.repository.ClothingComponentRepository;
import com.example.demo.repository.CultureInfluenceRepository;
import com.example.demo.repository.PatternSymbolRepository;
import com.example.demo.repository.EtiquetteRepository;
import com.example.demo.repository.FestivalRepository;
import com.example.demo.repository.ShapeTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private ShapeTypeRepository shapeTypeRepository;

    @Autowired
    private PatternSymbolRepository patternSymbolRepository;

    @Autowired
    private EtiquetteRepository etiquetteRepository;

    @Autowired
    private FestivalRepository festivalRepository;

    @Autowired
    private ClothingComponentRepository clothingComponentRepository;

    @Autowired
    private CultureInfluenceRepository cultureInfluenceRepository;

    @Override
    public void run(String... args) throws Exception {
        // 清理并初始化形制分类数据（只保留四个基本形制）
        if (shapeTypeRepository.count() < 4) {
            cleanupAndInitializeShapeTypes();
        }
        
        // 检查并初始化服饰部件数据
        if (clothingComponentRepository.count() == 0) {
            initializeClothingComponents();
        }
        
        // 检查并初始化文化影响数据
        if (cultureInfluenceRepository.count() == 0) {
            initializeCultureInfluences();
        }
    }

    private void cleanupAndInitializeShapeTypes() {
        // 定义四个基本形制
        String[] basicShapeTypes = {"深衣制", "衣裳制", "襦裙制", "袍服制"};
        
        // 清理非基本形制数据
        shapeTypeRepository.findAll().forEach(shapeType -> {
            boolean isBasicType = false;
            for (String basicType : basicShapeTypes) {
                if (basicType.equals(shapeType.getName())) {
                    isBasicType = true;
                    break;
                }
            }
            if (!isBasicType) {
                shapeTypeRepository.delete(shapeType);
                System.out.println("删除非基本形制: " + shapeType.getName());
            }
        });
        
        // 检查并初始化基本形制数据
        for (int i = 0; i < basicShapeTypes.length; i++) {
            String shapeName = basicShapeTypes[i];
            if (!shapeTypeRepository.findByName(shapeName).isPresent()) {
                initializeShapeType(shapeName, i + 1);
            } else {
                // 更新 sortOrder 确保顺序正确
                ShapeType existingShape = shapeTypeRepository.findByName(shapeName).get();
                existingShape.setSortOrder(i + 1);
                shapeTypeRepository.save(existingShape);
            }
        }
        
        System.out.println("形制分类数据清理和初始化完成！当前共有 " + shapeTypeRepository.count() + " 个形制");
    }
    
    private void initializeShapeType(String shapeName, int sortOrder) {
        ShapeType shape = new ShapeType();
        shape.setName(shapeName);
        shape.setSortOrder(sortOrder);
        
        // 设置图片路径
        shape.setImage("/uploads/basic_style/" + sortOrder + ".jpg");
        
        switch (shapeName) {
            case "深衣制":
                shape.setPeriod("战国至明代");
                shape.setDescription("上下连属的服饰，将上衣下裳连为一体，体现深意。");
                shape.setCharacteristics("上下连属、端庄大方、适用广泛");
                shape.setContent("深衣是中国古代最具代表性的服饰之一，其特点是将上衣和下裳连在一起，用不同颜色的布料象征天地。深衣在战国时期开始流行，一直沿用到明代。");
                break;
            case "衣裳制":
                shape.setPeriod("先秦至明清");
                shape.setDescription("上衣下裳的基本形制，最古老的汉服形式，象征天地秩序。");
                shape.setCharacteristics("上下分裁、庄严正统、礼仪性强");
                shape.setContent("衣裳制是汉服最基本的形制，上衣代表天，下裳代表地，体现了中国古代天人合一的哲学思想。这种形制在先秦时期就已经成熟。");
                break;
            case "襦裙制":
                shape.setPeriod("历代流行");
                shape.setDescription("上衣下裙的女装组合，历代款式变化丰富多样。");
                shape.setCharacteristics("上衣下裙、款式多样、女性特色");
                shape.setContent("襦裙是汉服女装的主要形制，由短上衣（襦）和裙子组成。历代襦裙款式变化丰富，有齐胸襦裙、齐腰襦裙、高腰襦裙等多种形式。");
                break;
            case "袍服制":
                shape.setPeriod("汉代以后");
                shape.setDescription("一体裁剪的长衣，便于活动，逐渐成为日常服饰。");
                shape.setCharacteristics("一体裁剪、便于活动、日常实用");
                shape.setContent("袍服是一体裁剪的长衣，有衬里的称袍，无衬里的称衫。袍服便于活动，逐渐成为日常服饰，在汉代以后广泛流行。");
                break;
        }
        
        shapeTypeRepository.save(shape);
        System.out.println("初始化形制: " + shapeName);
    }

    private void initializeClothingComponents() {
        // 衣
        ClothingComponent comp1 = new ClothingComponent();
        comp1.setName("衣");
        comp1.setType("上身服饰");
        comp1.setDescription("汉服的上身部分，包括各种款式的上衣。");
        comp1.setContent("衣是汉服的上身部分，包括各种款式的上衣。根据形制、用途的不同，衣有多种分类。常见的上衣包括襦、衫、袄等。襦为短上衣，衫为单层上衣，袄为有衬里的上衣。衣的领型有交领、直领、圆领等多种形式，袖型有广袖、窄袖、琵琶袖等变化。不同朝代、不同场合的衣在款式、色彩、纹样上都有严格的规定，体现了汉服的礼仪性。衣的长度从短至腰到长及膝下不等，根据季节和场合选择合适的款式。衣的纹样装饰丰富多样，常见的有云纹、龙纹、凤纹等，体现了穿着者的身份和地位。");
        comp1.setSortOrder(1);
        clothingComponentRepository.save(comp1);

        // 裳
        ClothingComponent comp2 = new ClothingComponent();
        comp2.setName("裳");
        comp2.setType("下身服饰");
        comp2.setDescription("汉服的下身部分，主要指裙装。");
        comp2.setContent("裳是汉服的下身部分，主要指裙装。在古代，裳是男女皆可穿着的下装。裳的款式多样，包括单片裙、多片裙、马面裙等。不同形制的裳在裁剪和穿着方式上各有特点。裳的长度、幅数、褶数等都有特定的文化含义，体现了古人的审美观念和社会规范。随着时代发展，裳的款式不断丰富，成为汉服文化中的重要组成部分。裳的穿着方式讲究层次，通常内穿衬裙，外罩主裙，体现了汉服的层次感。裳的色彩搭配讲究和谐，常与上衣形成对比或呼应，展现整体美感。");
        comp2.setSortOrder(2);
        clothingComponentRepository.save(comp2);

        // 袍
        ClothingComponent comp3 = new ClothingComponent();
        comp3.setName("袍");
        comp3.setType("一体服饰");
        comp3.setDescription("上下连属的长衣，有衬里的称袍。");
        comp3.setContent("袍是上下连属的长衣，有衬里的称袍，是汉服中重要的服饰类型。袍的特点是保暖性好，适合秋冬季节穿着，也是正式场合的常见服饰。袍的款式包括直裾袍、曲裾袍等，不同款式适应不同的场合和身份。袍的长度一般到脚踝，袖子宽大，体现了汉服的庄重与大气。袍的颜色和纹样有严格的等级规定，不同品级的官员穿着不同颜色的袍服。袍的穿着方式讲究系带和配饰，体现了汉服的礼仪规范。");
        comp3.setSortOrder(3);
        clothingComponentRepository.save(comp3);

        // 衫
        ClothingComponent comp4 = new ClothingComponent();
        comp4.setName("衫");
        comp4.setType("一体服饰");
        comp4.setDescription("单层的长衣，无衬里的称衫。");
        comp4.setContent("衫是单层的长衣，无衬里的称衫，适合春夏季节穿着。衫的特点是轻薄透气，穿着舒适，是日常休闲的常见选择。衫的款式包括直领衫、交领衫等，面料多为丝绸、棉麻等轻薄材质。衫的长度变化多样，有长及脚踝的长衫，也有短至腰部的短衫。衫的颜色以素雅为主，常见的有白色、浅蓝、淡粉等清新色调。衫的穿着场合广泛，既可作为内衣，也可作为外衣，体现了汉服的实用性。");
        comp4.setSortOrder(4);
        clothingComponentRepository.save(comp4);

        // 襦
        ClothingComponent comp5 = new ClothingComponent();
        comp5.setName("襦");
        comp5.setType("上衣");
        comp5.setDescription("短上衣，通常与裙搭配穿着。");
        comp5.setContent("襦是短上衣，长度一般到腰部，通常与裙搭配穿着。襦的特点是短小精悍，便于活动，是女性日常穿着的主要上衣类型。襦的领型多为交领，也有对襟款式，袖子有窄袖和广袖之分。襦与裙的搭配形成了襦裙这一经典女装形制，历代款式变化丰富。襦的装饰精美，常在领口、袖口、下摆处绣有花纹，体现女性审美。襦的颜色选择丰富，可根据季节和场合搭配不同颜色的裙子。");
        comp5.setSortOrder(5);
        clothingComponentRepository.save(comp5);

        // 裙
        ClothingComponent comp6 = new ClothingComponent();
        comp6.setName("裙");
        comp6.setType("下裳");
        comp6.setDescription("下身穿着的裙装，款式多样。");
        comp6.setContent("裙是下身穿着的裙装，是女性汉服的重要组成部分。裙的款式多样，包括百褶裙、马面裙、月华裙等，每种都有独特的审美特点。裙的穿着位置有齐胸、齐腰、高腰之分，不同位置展现不同的身材比例。裙的面料多为丝绸、锦缎等，质地轻盈，行走时飘逸动人。裙的纹样装饰丰富，常见的有花卉、云纹、几何图案等。裙的色彩搭配讲究，常与上衣形成和谐或对比的视觉效果。");
        comp6.setSortOrder(6);
        clothingComponentRepository.save(comp6);

        // 裤
        ClothingComponent comp7 = new ClothingComponent();
        comp7.setName("裤");
        comp7.setType("下裳");
        comp7.setDescription("下身穿着的裤装，便于活动。");
        comp7.setContent("裤是下身穿着的裤装，便于活动，是实用的下装选择。古代的裤与现代有所不同，早期为无裆的胫衣，后发展为合裆裤。裤的款式包括长裤、短裤、灯笼裤等，适应不同的活动和场合。裤常穿在裙内作为衬裤，也可单独外穿，体现了汉服的层次感。裤的面料多为棉麻、丝绸等，注重舒适性和实用性。裤的系带设计便于调节松紧，适应不同身材和活动需求。");
        comp7.setSortOrder(7);
        clothingComponentRepository.save(comp7);

        // 冠
        ClothingComponent comp8 = new ClothingComponent();
        comp8.setName("冠");
        comp8.setType("首服");
        comp8.setDescription("头上戴的冠帽，体现身份等级。");
        comp8.setContent("冠是头上戴的冠帽，是汉服首服的重要组成部分，体现身份等级。冠的种类繁多，包括冕冠、通天冠、进贤冠等，不同冠代表不同身份。冠的佩戴有严格的礼仪规范，不同场合佩戴不同的冠。冠的制作工艺精湛，常用金玉、珠宝等装饰，体现尊贵地位。冠与服饰的搭配讲究和谐，形成完整的礼仪装束。除冠外，首服还包括巾、帽等，适应不同场合和身份需求。");
        comp8.setSortOrder(8);
        clothingComponentRepository.save(comp8);

        System.out.println("服饰部件数据初始化完成！");
    }

    private void initializeCultureInfluences() {
        // 礼仪制度
        CultureInfluence etiquette = new CultureInfluence();
        etiquette.setTitle("礼仪制度");
        etiquette.setDescription("汉服与华夏礼仪制度密不可分，自古以来就有衣冠之治的说法。不同场合、身份、性别都有相应的服饰规范，体现了礼的文化内涵和等级秩序。\n" +
                "从周代开始，服饰就有严格的等级区分。帝王将相、士农工商各有不同的服饰规定，包括颜色、纹样、材质等方面都有明确规范。祭祀、朝会、婚丧、宴饮等不同场合都有特定的服饰要求。\n" +
                "如祭服庄重、朝服威严、婚服喜庆、丧服素雅，体现了礼制的严谨性。虽然现代社会不再有严格的服饰等级制度，但汉服所蕴含的礼仪精神仍然具有重要的文化价值，体现了中华民族重礼守仪的传统美德。");
        cultureInfluenceRepository.save(etiquette);

        // 审美观念
        CultureInfluence aesthetics = new CultureInfluence();
        aesthetics.setTitle("审美观念");
        aesthetics.setDescription("汉服体现了天人合一的哲学思想，服饰讲究与自然和谐统一。宽大的袖口象征天地，交领右衽体现阴阳，整体造型追求自然流畅。\n" +
                "汉服不强调身体曲线，而是通过宽松的剪裁和流畅的线条来展现人体的美感，体现了中华民族含蓄内敛、优雅大方的审美追求。\n" +
                "汉服的色彩和纹样都有深厚的文化内涵。如黄色象征皇权，红色代表吉祥，龙凤纹样体现尊贵，云纹象征祥瑞等。在现代社会，汉服的审美价值重新得到认可，其独特的东方美学为现代服装设计提供了丰富的灵感源泉。");
        cultureInfluenceRepository.save(aesthetics);

        // 现代复兴
        CultureInfluence revival = new CultureInfluence();
        revival.setTitle("现代复兴");
        revival.setDescription("21世纪初，汉服复兴运动开始兴起。最初由少数文化爱好者发起，逐渐发展成为一场涉及全国的文化运动，吸引了大量年轻人参与。\n" +
                "越来越多的年轻人通过穿着汉服来表达对传统文化的认同和热爱。汉服成为连接现代青年与传统文化的重要纽带。各地汉服社团、文化节、雅集活动层出不穷，线上社群也十分活跃，形成了良好的文化交流氛围。\n" +
                "随着需求的增长，汉服产业迅速发展。从设计、制作到销售，形成了完整的产业链，推动了传统文化的现代化转型。汉服复兴不仅是服饰的回归，更是文化自信的体现。未来，汉服文化将在创新中传承，在传承中发展，为中华文化的复兴贡献力量。");
        cultureInfluenceRepository.save(revival);

        System.out.println("文化影响数据初始化完成！");
    }
}
