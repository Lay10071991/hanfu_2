package com.example.demo.repository;

import com.example.demo.entity.LectureRegistration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface LectureRegistrationRepository extends JpaRepository<LectureRegistration, Long> {
    Optional<LectureRegistration> findByUserIdAndLectureId(Long userId, Long lectureId);
    List<LectureRegistration> findByLectureId(Long lectureId);
    long countByLectureId(Long lectureId);
    
    @Modifying
    @Query("DELETE FROM LectureRegistration lr WHERE lr.userId = :userId AND lr.lectureId = :lectureId")
    void deleteByUserIdAndLectureId(@Param("userId") Long userId, @Param("lectureId") Long lectureId);
}