package com.example.demo.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置上传文件的访问路径
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/");
        
        // 配置前端静态资源访问路径
        registry.addResourceHandler("/exhibitions/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform-3/hanfu-cultural-platform/hanfu-cultural-platform/frontend/public/exhibitions/");
        
        registry.addResourceHandler("/shop-hanfu/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform-3/hanfu-cultural-platform/hanfu-cultural-platform/frontend/public/shop-hanfu/");
        
        registry.addResourceHandler("/login-bg.jpg")
                .addResourceLocations("file:E:/hanfu-cultural-platform-3/hanfu-cultural-platform/hanfu-cultural-platform/frontend/public/login-bg.jpg");
        
        // 配置各朝代形制特点弹窗图片
        registry.addResourceHandler("/dynasty-shapes/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform-3/hanfu-cultural-platform/hanfu-cultural-platform/frontend/public/dynasty-shapes/");
        
        // 配置基本形制分类弹窗图片
        registry.addResourceHandler("/shape-types/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform-3/hanfu-cultural-platform/hanfu-cultural-platform/frontend/public/shape-types/");
        
        // 配置服饰部件详解图片
        registry.addResourceHandler("/clothing-components/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform-3/hanfu-cultural-platform/hanfu-cultural-platform/frontend/public/clothing-components/");
        
        // 配置图案象征图片
        registry.addResourceHandler("/pattern-symbols/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/pattern_symbol/");
        
        // 配置古代仪容仪态图片
        registry.addResourceHandler("/etiquette/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform-3/hanfu-cultural-platform/hanfu-cultural-platform/frontend/public/etiquette/");
        
        // 配置礼仪姿势图片
        registry.addResourceHandler("/etiquette-posture/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/etiquette_posture/");
        
        // 配置古代节俗礼仪图片
        registry.addResourceHandler("/festivals/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform-3/hanfu-cultural-platform/hanfu-cultural-platform/frontend/public/festivals/");
        
        // 配置节庆雅集活动图片
        registry.addResourceHandler("/festival-activities/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform-3/hanfu-cultural-platform/hanfu-cultural-platform/frontend/public/festival-activities/");
        
        // 配置讲座图片
        registry.addResourceHandler("/lectures/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform-3/hanfu-cultural-platform/hanfu-cultural-platform/frontend/public/lectures/");
        
        // 配置店铺详细页的汉服展示图片
        registry.addResourceHandler("/shop-details/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform-3/hanfu-cultural-platform/hanfu-cultural-platform/frontend/public/shop-details/");
        
        // 配置社区互动帖子图片
        registry.addResourceHandler("/community-posts/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform-3/hanfu-cultural-platform/hanfu-cultural-platform/frontend/public/community-posts/");
        
        // 配置节日习俗图片
        registry.addResourceHandler("/uploads/festival_custom/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/festival_custom/");
        
        // 配置节庆雅集活动图片
        registry.addResourceHandler("/uploads/festival_gathering/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/festival_gathering/");
        
        // 配置展览图片
        registry.addResourceHandler("/uploads/exhibition/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/exhibition/");
    }
}
