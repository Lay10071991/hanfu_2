package com.example.demo.service;

import com.example.demo.entity.Activity;
import com.example.demo.repository.ActivityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ActivityService {
    
    @Autowired
    private ActivityRepository activityRepository;
    
    public List<Activity> getAllActivities() {
        return activityRepository.findAll();
    }
    
    public Activity getActivityById(Long id) {
        return activityRepository.findById(id).orElse(null);
    }
    
    public Activity createActivity(Activity activity) {
        return activityRepository.save(activity);
    }
    
    public Activity updateActivity(Long id, Activity activityDetails) {
        Activity activity = activityRepository.findById(id).orElse(null);
        if (activity != null) {
            activity.setTitle(activityDetails.getTitle());
            activity.setDescription(activityDetails.getDescription());
            activity.setLocation(activityDetails.getLocation());
            activity.setStartTime(activityDetails.getStartTime());
            activity.setEndTime(activityDetails.getEndTime());
            activity.setStatus(activityDetails.getStatus());
            return activityRepository.save(activity);
        }
        return null;
    }
    
    public void deleteActivity(Long id) {
        activityRepository.deleteById(id);
    }
}
