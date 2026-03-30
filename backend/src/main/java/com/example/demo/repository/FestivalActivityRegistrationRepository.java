package com.example.demo.repository;

import com.example.demo.entity.FestivalActivityRegistration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FestivalActivityRegistrationRepository extends JpaRepository<FestivalActivityRegistration, Long> {

    List<FestivalActivityRegistration> findByFestivalActivityId(Long activityId);

    Optional<FestivalActivityRegistration> findByFestivalActivityIdAndUserId(Long activityId, Long userId);

    long countByFestivalActivityId(Long activityId);

    boolean existsByFestivalActivityIdAndUserId(Long activityId, Long userId);

    @Modifying
    @Query("DELETE FROM FestivalActivityRegistration r WHERE r.festivalActivity.id = :activityId AND r.userId = :userId")
    void deleteByFestivalActivityIdAndUserId(@Param("activityId") Long activityId, @Param("userId") Long userId);
}
