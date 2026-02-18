package com.gestions.ramzi.servicefeedback.repositories;

import com.gestions.ramzi.servicefeedback.entities.Reclamation;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReclamationRepository extends JpaRepository<Reclamation, Long> {
    // List<Reclamation> findByUserId(Long userId);
    // List<Reclamation> findByStatus(String status);
}
