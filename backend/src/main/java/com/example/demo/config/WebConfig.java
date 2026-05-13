package com.example.demo.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    // 上传文件基础路径
    private static final String UPLOAD_BASE_PATH = "file:E:/hanfu-cultural-platform/backend/uploads/";

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:5173")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置上传文件的访问路径
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(UPLOAD_BASE_PATH);

        // 配置前端静态资源访问路径
        registry.addResourceHandler("/login-bg.jpg")
                .addResourceLocations("file:E:/hanfu-cultural-platform/frontend/public/login-bg.jpg");

        // 配置基本形制图片
        registry.addResourceHandler("/uploads/basic_style/**")
                .addResourceLocations(UPLOAD_BASE_PATH + "basic_style/");

        // 配置千载衣冠图片
        registry.addResourceHandler("/uploads/clothing_show/**")
                .addResourceLocations(UPLOAD_BASE_PATH + "clothing_show/");

        // 配置图案象征图片
        registry.addResourceHandler("/pattern-symbols/**")
                .addResourceLocations(UPLOAD_BASE_PATH + "pattern_symbol/");

        // 配置礼仪姿势图片
        registry.addResourceHandler("/etiquette-posture/**")
                .addResourceLocations(UPLOAD_BASE_PATH + "etiquette_posture/");

        // 配置店铺图片
        registry.addResourceHandler("/shop/**")
                .addResourceLocations(UPLOAD_BASE_PATH + "shop/");

        // 配置店铺汉服展示图片
        registry.addResourceHandler("/shopshow/**")
                .addResourceLocations(UPLOAD_BASE_PATH + "shopshow/");

        // 配置帖子图片
        registry.addResourceHandler("/community_post/**")
                .addResourceLocations(UPLOAD_BASE_PATH + "community_post/");

        // 配置节日习俗图片
        registry.addResourceHandler("/uploads/festival_custom/**")
                .addResourceLocations(UPLOAD_BASE_PATH + "festival_custom/");

        // 配置节庆雅集活动图片
        registry.addResourceHandler("/uploads/festival_gathering/**")
                .addResourceLocations(UPLOAD_BASE_PATH + "festival_gathering/");

        // 配置展览图片
        registry.addResourceHandler("/uploads/exhibition/**")
                .addResourceLocations(UPLOAD_BASE_PATH + "exhibition/");

        // 配置讲座图片
        registry.addResourceHandler("/uploads/talk/**")
                .addResourceLocations(UPLOAD_BASE_PATH + "talk/");
    }
}
