package com.example.demo.repository;

import com.example.demo.entity.ExhibitionRegistration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ExhibitionRegistrationRepository extends JpaRepository<ExhibitionRegistration, Long> {
    Optional<ExhibitionRegistration> findByUserIdAndExhibitionId(Long userId, Long exhibitionId);
    List<ExhibitionRegistration> findByExhibitionId(Long exhibitionId);
    long countByExhibitionId(Long exhibitionId);
    
    @Modifying
    @Query("DELETE FROM ExhibitionRegistration er WHERE er.userId = :userId AND er.exhibitionId = :exhibitionId")
    void deleteByUserIdAndExhibitionId(@Param("userId") Long userId, @Param("exhibitionId") Long exhibitionId);
}