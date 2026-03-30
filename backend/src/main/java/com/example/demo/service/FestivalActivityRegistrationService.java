package com.example.demo.service;

import com.example.demo.entity.FestivalActivity;
import com.example.demo.entity.FestivalActivityRegistration;
import com.example.demo.repository.FestivalActivityRegistrationRepository;
import com.example.demo.repository.FestivalActivityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class FestivalActivityRegistrationService {

    @Autowired
    private FestivalActivityRegistrationRepository registrationRepository;

    @Autowired
    private FestivalActivityRepository activityRepository;

    public List<FestivalActivityRegistration> getRegistrationsByActivityId(Long activityId) {
        return registrationRepository.findByFestivalActivityId(activityId);
    }

    public Optional<FestivalActivityRegistration> getRegistration(Long activityId, Long userId) {
        return registrationRepository.findByFestivalActivityIdAndUserId(activityId, userId);
    }

    public long getRegistrationCount(Long activityId) {
        return registrationRepository.countByFestivalActivityId(activityId);
    }

    public boolean isRegistered(Long activityId, Long userId) {
        return registrationRepository.existsByFestivalActivityIdAndUserId(activityId, userId);
    }

    public FestivalActivityRegistration register(Long activityId, Long userId) {
        Optional<FestivalActivity> activityOptional = activityRepository.findById(activityId);
        if (!activityOptional.isPresent()) {
            throw new IllegalArgumentException("Activity not found with id: " + activityId);
        }

        if (isRegistered(activityId, userId)) {
            throw new IllegalStateException("User already registered for this activity");
        }

        FestivalActivity activity = activityOptional.get();
        FestivalActivityRegistration registration = new FestivalActivityRegistration(activity, userId);
        registration.setRegistrationTime(new Date());
        return registrationRepository.save(registration);
    }

    @Transactional
    public boolean cancelRegistration(Long activityId, Long userId) {
        if (isRegistered(activityId, userId)) {
            registrationRepository.deleteByFestivalActivityIdAndUserId(activityId, userId);
            return true;
        }
        return false;
    }
}
