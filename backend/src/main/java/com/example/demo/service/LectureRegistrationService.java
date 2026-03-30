package com.example.demo.service;

import com.example.demo.entity.Lecture;
import com.example.demo.entity.LectureRegistration;
import com.example.demo.repository.LectureRegistrationRepository;
import com.example.demo.repository.LectureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LectureRegistrationService {

    @Autowired
    private LectureRegistrationRepository registrationRepository;

    @Autowired
    private LectureRepository lectureRepository;

    @Transactional
    public boolean register(Long userId, Long lectureId) {
        // 检查是否已经报名
        if (registrationRepository.findByUserIdAndLectureId(userId, lectureId).isPresent()) {
            return false;
        }

        // 检查讲座是否存在
        Lecture lecture = lectureRepository.findById(lectureId).orElse(null);
        if (lecture == null) {
            return false;
        }

        // 检查是否达到最大容量
        if (lecture.getRegisteredCount() >= lecture.getCapacity()) {
            return false;
        }

        // 创建新的报名记录
        LectureRegistration registration = new LectureRegistration();
        registration.setUserId(userId);
        registration.setLectureId(lectureId);
        registrationRepository.save(registration);

        // 更新讲座的报名人数
        lecture.setRegisteredCount(lecture.getRegisteredCount() + 1);
        lectureRepository.save(lecture);

        return true;
    }

    @Transactional
    public boolean cancelRegistration(Long userId, Long lectureId) {
        // 检查是否存在报名记录
        if (registrationRepository.findByUserIdAndLectureId(userId, lectureId).isEmpty()) {
            return false;
        }

        // 检查讲座是否存在
        Lecture lecture = lectureRepository.findById(lectureId).orElse(null);
        if (lecture == null) {
            return false;
        }

        // 删除报名记录
        registrationRepository.deleteByUserIdAndLectureId(userId, lectureId);

        // 更新讲座的报名人数
        if (lecture.getRegisteredCount() > 0) {
            lecture.setRegisteredCount(lecture.getRegisteredCount() - 1);
            lectureRepository.save(lecture);
        }

        return true;
    }

    public boolean isRegistered(Long userId, Long lectureId) {
        return registrationRepository.findByUserIdAndLectureId(userId, lectureId).isPresent();
    }

    public long getRegistrationCount(Long lectureId) {
        return registrationRepository.countByLectureId(lectureId);
    }
}