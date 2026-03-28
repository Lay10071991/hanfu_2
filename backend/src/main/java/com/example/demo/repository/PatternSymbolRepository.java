package com.example.demo.repository;

import com.example.demo.entity.PatternSymbol;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PatternSymbolRepository extends JpaRepository<PatternSymbol, Long> {
}
