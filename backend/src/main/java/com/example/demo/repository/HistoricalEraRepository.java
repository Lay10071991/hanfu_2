package com.example.demo.repository;

import com.example.demo.entity.HistoricalEra;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface HistoricalEraRepository extends JpaRepository<HistoricalEra, Long> {
}
