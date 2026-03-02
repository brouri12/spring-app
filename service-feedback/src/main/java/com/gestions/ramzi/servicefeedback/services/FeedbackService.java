package com.gestions.ramzi.servicefeedback.services;

import com.gestions.ramzi.servicefeedback.dto.FeedbackStats;
import com.gestions.ramzi.servicefeedback.entities.Feedback;
import com.gestions.ramzi.servicefeedback.repositories.FeedbackRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class FeedbackService {

    private final FeedbackRepository repository;

    public FeedbackService(FeedbackRepository repository) {
        this.repository = repository;
    }

    public List<Feedback> getAll() {
        return repository.findAll();
    }

    public Feedback getById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public Feedback create(Feedback feedback) {
        feedback.setDate(LocalDateTime.now());
        return repository.save(feedback);
    }

    public Feedback update(Long id, Feedback updated) {
        Feedback existing = getById(id);
        if (existing != null) {
            existing.setNote(updated.getNote());
            existing.setCommentaire(updated.getCommentaire());
            return repository.save(existing);
        }
        return null;
    }

    public void delete(Long id) {
        repository.deleteById(id);
    }

    public List<Feedback> getByUserId(Long userId) {
        return repository.findByUserId(userId);
    }

    public List<Feedback> getByModuleId(Long moduleId) {
        return repository.findByModuleId(moduleId);
    }

    /**
     * Get feedback statistics
     * @param moduleId optional module filter
     * @return FeedbackStats object with all statistics
     */
    public FeedbackStats getStats(Long moduleId) {
        List<Feedback> feedbacks;
        
        if (moduleId != null) {
            feedbacks = repository.findByModuleId(moduleId);
        } else {
            feedbacks = repository.findAll();
        }

        if (feedbacks.isEmpty()) {
            return FeedbackStats.builder()
                    .moyenneNote(0.0)
                    .totalFeedbacks(0)
                    .repartitionNotes(new HashMap<>())
                    .feedbacksParMois(new HashMap<>())
                    .nouveauxAujourdhui(0L)
                    .moduleId(moduleId)
                    .build();
        }

        // Calculate average note
        double moyenne = feedbacks.stream()
                .mapToInt(Feedback::getNote)
                .average()
                .orElse(0.0);

        // Calculate note distribution (count per note 1-5)
        Map<Integer, Long> repartitionNotes = feedbacks.stream()
                .collect(Collectors.groupingBy(Feedback::getNote, Collectors.counting()));

        // Ensure all notes 1-5 are present
        for (int i = 1; i <= 5; i++) {
            repartitionNotes.putIfAbsent(i, 0L);
        }

        // Calculate feedbacks per month (last 6 months)
        Map<String, Long> feedbacksParMois = feedbacks.stream()
                .filter(f -> f.getDate() != null)
                .filter(f -> f.getDate().isAfter(LocalDateTime.now().minusMonths(6)))
                .collect(Collectors.groupingBy(
                        f -> f.getDate().format(DateTimeFormatter.ofPattern("yyyy-MM")),
                        Collectors.counting()
                ));

        // Count new feedbacks today
        LocalDateTime todayStart = LocalDate.now().atStartOfDay();
        long nouveauxAujourdhui = feedbacks.stream()
                .filter(f -> f.getDate() != null)
                .filter(f -> f.getDate().isAfter(todayStart))
                .count();

        return FeedbackStats.builder()
                .moyenneNote(Math.round(moyenne * 100.0) / 100.0)
                .totalFeedbacks(feedbacks.size())
                .repartitionNotes(repartitionNotes)
                .feedbacksParMois(feedbacksParMois)
                .nouveauxAujourdhui(nouveauxAujourdhui)
                .moduleId(moduleId)
                .build();
    }
}
