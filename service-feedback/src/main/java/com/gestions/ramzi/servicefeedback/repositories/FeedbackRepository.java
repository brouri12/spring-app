package com.gestions.ramzi.servicefeedback.repositories;

import com.gestions.ramzi.servicefeedback.entities.Feedback;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FeedbackRepository extends JpaRepository<Feedback, Long> {
    // Exemples de méthodes personnalisées :
    // List<Feedback> findByUserId(Long userId);
    // List<Feedback> findByModuleId(Long moduleId);
}
