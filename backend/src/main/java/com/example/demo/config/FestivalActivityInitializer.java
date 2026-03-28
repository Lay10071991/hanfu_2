package com.example.demo.config;

import com.example.demo.entity.FestivalActivity;
import com.example.demo.repository.FestivalActivityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

// @Component
public class FestivalActivityInitializer implements CommandLineRunner {

    @Autowired
    private FestivalActivityRepository repository;

    @Override
    public void run(String... args) {
        // 检查是否已有数据
        if (repository.count() == 0) {
            // 初始化前端FestivalGathering.vue中的数据
            List<FestivalActivity> activities = new ArrayList<>();

            // 元宵灯会汉服游园
            FestivalActivity activity1 = new FestivalActivity();
            activity1.setTitle("元宵灯会汉服游园");
            activity1.setSeason("winter");
            activity1.setDate("2024-02-24");
            activity1.setLocation("南京夫子庙");
            activity1.setImage("https://placehold.co/400x250/FFCC99/000000?text=元宵灯会");
            activity1.setDescription("传统元宵佳节，穿上汉服赏花灯、猜灯谜，体验古代元宵节的欢乐氛围。活动包括汉服走秀、传统灯谜、古典舞蹈表演等。");
            activities.add(activity1);

            // 清明踏青汉服雅集
            FestivalActivity activity2 = new FestivalActivity();
            activity2.setTitle("清明踏青汉服雅集");
            activity2.setSeason("spring");
            activity2.setDate("2024-04-05");
            activity2.setLocation("杭州西湖");
            activity2.setImage("https://placehold.co/400x250/99CC99/000000?text=清明踏青");
            activity2.setDescription("清明时节，春光明媚，穿上汉服在西湖边踏青、品茶、赏花，感受传统清明节的文化内涵。");
            activities.add(activity2);

            // 端午龙舟汉服观赛
            FestivalActivity activity3 = new FestivalActivity();
            activity3.setTitle("端午龙舟汉服观赛");
            activity3.setSeason("summer");
            activity3.setDate("2024-06-10");
            activity3.setLocation("苏州护城河");
            activity3.setImage("https://placehold.co/400x250/FF9999/000000?text=端午龙舟");
            activity3.setDescription("端午节观看传统龙舟比赛，体验包粽子、挂艾草等习俗，感受浓厚的端午文化氛围。");
            activities.add(activity3);

            // 中秋赏月汉服夜宴
            FestivalActivity activity4 = new FestivalActivity();
            activity4.setTitle("中秋赏月汉服夜宴");
            activity4.setSeason("autumn");
            activity4.setDate("2024-09-17");
            activity4.setLocation("北京颐和园");
            activity4.setImage("https://placehold.co/400x250/CCCCFF/000000?text=中秋赏月");
            activity4.setDescription("中秋佳节，穿上汉服在颐和园赏月、品月饼、吟诗作对，体验古人的风雅情趣。");
            activities.add(activity4);

            // 重阳登高汉服会
            FestivalActivity activity5 = new FestivalActivity();
            activity5.setTitle("重阳登高汉服会");
            activity5.setSeason("autumn");
            activity5.setDate("2024-10-11");
            activity5.setLocation("黄山风景区");
            activity5.setImage("https://placehold.co/400x250/FFCCCC/000000?text=重阳登高");
            activity5.setDescription("重阳节登高望远，佩戴茱萸，饮菊花酒，感受传统重阳节的敬老爱老文化。");
            activities.add(activity5);

            // 七夕乞巧汉服节
            FestivalActivity activity6 = new FestivalActivity();
            activity6.setTitle("七夕乞巧汉服节");
            activity6.setSeason("summer");
            activity6.setDate("2024-08-10");
            activity6.setLocation("西安大唐不夜城");
            activity6.setImage("https://placehold.co/400x250/FFB6C1/000000?text=七夕乞巧");
            activity6.setDescription("传统七夕节，体验穿针乞巧、月下祈福等传统习俗，感受浪漫的传统情人节氛围。");
            activities.add(activity6);

            // 批量保存到数据库
            repository.saveAll(activities);
            System.out.println("节庆活动数据初始化完成，共插入" + activities.size() + "条记录");
        }
    }
}
