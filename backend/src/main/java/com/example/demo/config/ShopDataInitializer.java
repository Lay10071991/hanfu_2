package com.example.demo.config;

import com.example.demo.entity.Shop;
import com.example.demo.entity.ShopImage;
import com.example.demo.entity.ShopService;
import com.example.demo.repository.ShopRepository;
import com.example.demo.service.ShopImageService;
import com.example.demo.service.ShopServiceItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class ShopDataInitializer implements CommandLineRunner {

    @Autowired
    private ShopRepository shopRepository;
    
    @Autowired
    private ShopImageService shopImageService;
    
    @Autowired
    private ShopServiceItemService shopServiceItemService;

    @Override
    public void run(String... args) throws Exception {
        // 检查是否需要初始化店铺数据
        if (shopRepository.count() == 0) {
            initializeShopData();
        }
    }

    private void initializeShopData() {
        // 创建第一个店铺
        Shop shop1 = new Shop();
        shop1.setName("锦绣汉服");
        shop1.setDescription("锦绣汉服是一家专注于传统汉服制作与销售的专业店铺，致力于传承和弘扬中华传统服饰文化。我们的汉服均采用优质面料，结合传统工艺与现代审美，为顾客提供既美观又舒适的汉服产品。店铺拥有专业的设计团队，能够根据客户需求进行个性化定制，满足不同场合的穿着需求。无论是日常穿着、婚礼庆典还是文化表演，我们都能为您提供最合适的汉服选择。");
        shop1.setImage("https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=elegant%20Chinese%20hanfu%20shop%20interior%20with%20traditional%20clothing%20display%2C%20warm%20lighting%2C%20cultural%20atmosphere&image_size=1024x1024");
        shop1.setAddress("北京市朝阳区三里屯太古里");
        shop1.setContact("010-12345678");
        shop1.setPriceRange("中高档");
        Shop savedShop1 = shopRepository.save(shop1);

        // 为第一个店铺添加图片
        addShopImages(savedShop1.getId());
        
        // 为第一个店铺添加服务
        addShopServices(savedShop1.getId());

        // 创建第二个店铺
        Shop shop2 = new Shop();
        shop2.setName("云裳阁");
        shop2.setDescription("云裳阁成立于2015年，是一家集汉服设计、制作、销售于一体的综合性汉服品牌。我们坚持传承不守旧，创新不忘本的理念，在保持汉服传统韵味的同时，融入现代时尚元素，打造出既符合传统审美又适应现代生活的汉服产品。店铺拥有自己的生产基地，确保每一件汉服都经过严格的质量把控。我们的产品涵盖男女老少各个年龄段，从日常休闲到正式场合，应有尽有。");
        shop2.setImage("https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Chinese%20hanfu%20boutique%20store%20with%20elegant%20displays%2C%20traditional%20decorations%2C%20warm%20atmosphere&image_size=1024x1024");
        shop2.setAddress("上海市黄浦区南京东路");
        shop2.setContact("021-87654321");
        shop2.setPriceRange("高档");
        Shop savedShop2 = shopRepository.save(shop2);

        // 为第二个店铺添加图片
        addShopImages(savedShop2.getId());
        
        // 为第二个店铺添加服务
        addShopServices(savedShop2.getId());

        // 创建第三个店铺
        Shop shop3 = new Shop();
        shop3.setName("汉韵坊");
        shop3.setDescription("汉韵坊是一家专注于汉服文化传播与推广的店铺，除了销售汉服产品外，我们还提供汉服文化讲座、传统礼仪培训等服务。我们的目标是通过汉服这一载体，让更多人了解和喜爱中国传统文化。店铺的产品线丰富，包括各种形制的汉服、配饰、鞋帽等，价格亲民，适合各类人群。我们定期举办汉服体验活动，让顾客在试穿中感受汉服的魅力。");
        shop3.setImage("https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=traditional%20Chinese%20hanfu%20workshop%20with%20cultural%20activities%2C%20warm%20and%20welcoming%20atmosphere&image_size=1024x1024");
        shop3.setAddress("广州市天河区珠江新城");
        shop3.setContact("020-98765432");
        shop3.setPriceRange("中档");
        Shop savedShop3 = shopRepository.save(shop3);

        // 为第三个店铺添加图片
        addShopImages(savedShop3.getId());
        
        // 为第三个店铺添加服务
        addShopServices(savedShop3.getId());

        System.out.println("店铺数据初始化完成！");
    }

    private void addShopImages(Long shopId) {
        String[][] imageDescriptions = {
            {"/shop-hanfu/q (1).png", "传统礼服系列"},
            {"/shop-hanfu/q (2).png", "日常汉服系列"},
            {"/shop-hanfu/q (3).png", "婚庆汉服系列"},
            {"/shop-hanfu/q (4).png", "儿童汉服系列"},
            {"/shop-hanfu/q (5).png", "配饰系列"}
        };
        
        for (int i = 0; i < imageDescriptions.length; i++) {
            ShopImage shopImage = new ShopImage();
            shopImage.setShopId(shopId);
            shopImage.setImageUrl(imageDescriptions[i][0]);
            shopImage.setDescription(imageDescriptions[i][1]);
            shopImage.setSortOrder(i + 1);
            shopImageService.saveImage(shopImage);
        }
    }
    
    private void addShopServices(Long shopId) {
        String[][] services = {
            {"汉服租赁"},
            {"汉服售卖"},
            {"汉服妆造"},
            {"汉服婚礼"}
        };
        
        for (String[] service : services) {
            ShopService shopService = new ShopService();
            shopService.setShopId(shopId);
            shopService.setServiceName(service[0]);
            shopServiceItemService.saveService(shopService);
        }
    }
}
