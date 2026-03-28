package com.example.demo.config;

import com.example.demo.entity.Activity;
import com.example.demo.repository.ActivityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Component
public class ActivityInitializer implements CommandLineRunner {

    @Autowired
    private ActivityRepository activityRepository;

    @Override
    public void run(String... args) throws Exception {
        // 检查是否已有活动数据
        if (activityRepository.count() == 0) {
            initializeActivities();
        }
    }

    private void initializeActivities() {
        List<Activity> activities = new ArrayList<>();

        // 展览活动
        Activity exhibition1 = new Activity();
        exhibition1.setTitle("华夏衣冠——中国传统服饰文化展览");
        exhibition1.setDescription("本次展览将展示从先秦到明清各个历史时期的汉服精品，包括深衣、襦裙、袍服等多种形制，让观众全面了解中国传统服饰文化的演变历程。展览还将展示汉服配饰、发饰、鞋履等，呈现完整的汉服文化体系。");
        exhibition1.setLocation("国家博物馆");
        exhibition1.setStartTime(LocalDateTime.of(2024, 3, 15, 9, 0));
        exhibition1.setEndTime(LocalDateTime.of(2024, 6, 15, 17, 0));
        exhibition1.setOrganizerId(1L);
        exhibition1.setStatus("upcoming");
        exhibition1.setParticipantsCount(0);
        exhibition1.setMaxParticipants(500);
        exhibition1.setImage("http://localhost:8082/uploads/exhibition-1.png");
        activities.add(exhibition1);

        Activity exhibition2 = new Activity();
        exhibition2.setTitle("锦绣华章——明代服饰珍品展");
        exhibition2.setDescription("聚焦明代服饰文化，展出明代宫廷服饰、民间服饰、礼仪服饰等珍贵文物。通过实物展示、图文解说、多媒体互动等形式，深入解读明代服饰的制度、工艺与审美，展现大明风华。");
        exhibition2.setLocation("故宫博物院");
        exhibition2.setStartTime(LocalDateTime.of(2024, 4, 1, 9, 0));
        exhibition2.setEndTime(LocalDateTime.of(2024, 7, 31, 17, 0));
        exhibition2.setOrganizerId(1L);
        exhibition2.setStatus("upcoming");
        exhibition2.setParticipantsCount(0);
        exhibition2.setMaxParticipants(300);
        exhibition2.setImage("http://localhost:8082/uploads/exhibition-2.png");
        activities.add(exhibition2);

        Activity exhibition3 = new Activity();
        exhibition3.setTitle("丝路霓裳——汉唐服饰文化交流展");
        exhibition3.setDescription("通过丝绸之路的视角，展示汉唐时期中外服饰文化的交流与融合。展览将展出汉唐服饰、西域服饰、丝绸织物等，讲述丝绸之路上的服饰故事，展现中华服饰文化的开放与包容。");
        exhibition3.setLocation("陕西历史博物馆");
        exhibition3.setStartTime(LocalDateTime.of(2024, 5, 1, 9, 0));
        exhibition3.setEndTime(LocalDateTime.of(2024, 8, 31, 17, 0));
        exhibition3.setOrganizerId(1L);
        exhibition3.setStatus("upcoming");
        exhibition3.setParticipantsCount(0);
        exhibition3.setMaxParticipants(400);
        exhibition3.setImage("http://localhost:8082/uploads/exhibition-3.png");
        activities.add(exhibition3);

        // 讲座活动
        Activity lecture1 = new Activity();
        lecture1.setTitle("讲座：汉服形制与礼仪规范");
        lecture1.setDescription("本讲座将系统介绍汉服的基本形制，包括深衣制、衣裳制、襦裙制、袍服制等，以及不同场合的着装礼仪。主讲人将结合历史文献和实物图片，深入浅出地讲解汉服文化的精髓，帮助听众建立正确的汉服认知。");
        lecture1.setLocation("北京大学人文学院报告厅");
        lecture1.setStartTime(LocalDateTime.of(2024, 3, 20, 14, 0));
        lecture1.setEndTime(LocalDateTime.of(2024, 3, 20, 16, 0));
        lecture1.setOrganizerId(1L);
        lecture1.setStatus("upcoming");
        lecture1.setParticipantsCount(0);
        lecture1.setMaxParticipants(200);
        lecture1.setImage("http://localhost:8082/uploads/lecture-1.png");
        activities.add(lecture1);

        Activity lecture2 = new Activity();
        lecture2.setTitle("讲座：从《诗经》看先秦服饰文化");
        lecture2.setDescription("以《诗经》中的服饰描写为切入点，解读先秦时期的服饰制度、审美观念和社会文化。通过\"青青子衿\"、\"缟衣綦巾\"等经典诗句，还原三千年前的服饰风貌，感受中华服饰文化的源远流长。");
        lecture2.setLocation("清华大学图书馆报告厅");
        lecture2.setStartTime(LocalDateTime.of(2024, 4, 10, 14, 0));
        lecture2.setEndTime(LocalDateTime.of(2024, 4, 10, 16, 0));
        lecture2.setOrganizerId(1L);
        lecture2.setStatus("upcoming");
        lecture2.setParticipantsCount(0);
        lecture2.setMaxParticipants(150);
        lecture2.setImage("http://localhost:8082/uploads/lecture-2.png");
        activities.add(lecture2);

        Activity lecture3 = new Activity();
        lecture3.setTitle("讲座：宋代服饰的雅致之美");
        lecture3.setDescription("宋代服饰以素雅、简洁、含蓄著称，体现了宋人的审美追求。本讲座将从宋代服饰的色彩、纹样、款式等方面，解读宋代服饰文化的独特魅力，以及其对后世服饰的影响。");
        lecture3.setLocation("复旦大学光华楼报告厅");
        lecture3.setStartTime(LocalDateTime.of(2024, 5, 15, 14, 0));
        lecture3.setEndTime(LocalDateTime.of(2024, 5, 15, 16, 0));
        lecture3.setOrganizerId(1L);
        lecture3.setStatus("upcoming");
        lecture3.setParticipantsCount(0);
        lecture3.setMaxParticipants(180);
        lecture3.setImage("http://localhost:8082/uploads/lecture-3.png");
        activities.add(lecture3);

        // 保存到数据库
        activityRepository.saveAll(activities);
        System.out.println("活动数据初始化完成，共插入 " + activities.size() + " 条记录（展览：3条，讲座：3条）");
    }
}
