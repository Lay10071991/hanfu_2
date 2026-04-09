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
        registry.addResourceHandler("/login-bg.jpg")
                .addResourceLocations("file:E:/hanfu-cultural-platform/frontend/public/login-bg.jpg");
        
        // 配置基本形制图片
        registry.addResourceHandler("/uploads/basic_style/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/basic_style/");
        
        // 配置千载衣冠图片
        registry.addResourceHandler("/uploads/clothing_show/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/clothing_show/");
        
        // 配置图案象征图片
        registry.addResourceHandler("/pattern-symbols/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/pattern_symbol/");
        
        // 配置礼仪姿势图片
        registry.addResourceHandler("/etiquette-posture/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/etiquette_posture/");
        
        // 配置店铺图片
        registry.addResourceHandler("/shop/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/shop/");
        
        // 配置店铺汉服展示图片
        registry.addResourceHandler("/shopshow/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/shopshow/");
        
        // 配置帖子图片
        registry.addResourceHandler("/community_post/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/community_post/");
        
        // 配置节日习俗图片
        registry.addResourceHandler("/uploads/festival_custom/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/festival_custom/");
        
        // 配置节庆雅集活动图片
        registry.addResourceHandler("/uploads/festival_gathering/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/festival_gathering/");
        
        // 配置展览图片
        registry.addResourceHandler("/uploads/exhibition/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/exhibition/");
        
        // 配置讲座图片
        registry.addResourceHandler("/uploads/talk/**")
                .addResourceLocations("file:E:/hanfu-cultural-platform/backend/uploads/talk/");
    }
}
