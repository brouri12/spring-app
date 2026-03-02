package com.gestions.ramzi.servicefeedback.services;

import com.gestions.ramzi.servicefeedback.dto.ReclamationAnalytics;
import com.gestions.ramzi.servicefeedback.entities.Reclamation;
import com.gestions.ramzi.servicefeedback.entities.ResolutionAction;
import com.gestions.ramzi.servicefeedback.repositories.ReclamationRepository;
import com.gestions.ramzi.servicefeedback.repositories.ResolutionActionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ReclamationService {

    private final ReclamationRepository repository;
    private final ResolutionActionRepository resolutionActionRepository;

    public ReclamationService(ReclamationRepository repository,
                              ResolutionActionRepository resolutionActionRepository) {
        this.repository = repository;
        this.resolutionActionRepository = resolutionActionRepository;
    }

    public List<Reclamation> getAll() {
        return repository.findAll();
    }

    public Reclamation getById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public Reclamation create(Reclamation reclamation) {
        reclamation.setDate(LocalDateTime.now());
        reclamation.setStatus("en attente");
        return repository.save(reclamation);
    }

    public Reclamation update(Long id, Reclamation reclamation) {
        Reclamation existing = getById(id);
        if (existing != null) {
            existing.setObjet(reclamation.getObjet());
            existing.setDescription(reclamation.getDescription());
            if (reclamation.getStatus() != null) {
                existing.setStatus(reclamation.getStatus());
            }
            return repository.save(existing);
        }
        return null;
    }

    public Reclamation updateStatus(Long id, String newStatus) {
        Reclamation existing = getById(id);
        if (existing != null) {
            existing.setStatus(newStatus);
            return repository.save(existing);
        }
        return null;
    }

    @Transactional
    public void delete(Long id) {
        resolutionActionRepository.findByReclamation_Id(id).forEach(resolutionActionRepository::delete);
        repository.deleteById(id);
    }

    public List<Reclamation> getByUserId(Long userId) {
        return repository.findByUserId(userId);
    }

    public List<Reclamation> getByStatus(String status) {
        return repository.findByStatus(status);
    }

    /**
     * Get reclamation analytics
     * @param dateDebut optional start date filter
     * @param dateFin optional end date filter
     * @return ReclamationAnalytics object with all statistics
     */
    public ReclamationAnalytics getAnalytics(String dateDebut, String dateFin) {
        List<Reclamation> reclamations = repository.findAll();

        if (reclamations.isEmpty()) {
            return ReclamationAnalytics.builder()
                    .totalReclamations(0)
                    .parStatus(new HashMap<>())
                    .tempsResolutionMoyen(0.0)
                    .parMois(new HashMap<>())
                    .nonResolues(new ArrayList<>())
                    .reclamationEnAttente(0)
                    .reclamationResolue(0)
                    .build();
        }

        // Calculate status distribution
        Map<String, Long> parStatus = reclamations.stream()
                .collect(Collectors.groupingBy(Reclamation::getStatus, Collectors.counting()));

        // Count by status
        long enAttente = reclamations.stream()
                .filter(r -> "en attente".equalsIgnoreCase(r.getStatus()))
                .count();
        long resolue = reclamations.stream()
                .filter(r -> "résolue".equalsIgnoreCase(r.getStatus()) || "resolue".equalsIgnoreCase(r.getStatus()) || "resolved".equalsIgnoreCase(r.getStatus()))
                .count();

        // Calculate average resolution time (in hours)
        List<ResolutionAction> resolutions = resolutionActionRepository.findAll();
        double tempsResolutionMoyen = 0.0;
        if (!resolutions.isEmpty()) {
            tempsResolutionMoyen = resolutions.stream()
                    .filter(r -> r.getDateAction() != null && r.getReclamation() != null && r.getReclamation().getDate() != null)
                    .mapToLong(r -> {
                        long hours = java.time.Duration.between(r.getReclamation().getDate(), r.getDateAction()).toHours();
                        return hours;
                    })
                    .average()
                    .orElse(0.0);
        }

        // Calculate reclamations per month (last 6 months)
        Map<String, Long> parMois = reclamations.stream()
                .filter(r -> r.getDate() != null)
                .filter(r -> r.getDate().isAfter(LocalDateTime.now().minusMonths(6)))
                .collect(Collectors.groupingBy(
                        r -> r.getDate().format(DateTimeFormatter.ofPattern("yyyy-MM")),
                        Collectors.counting()
                ));

        // Get unresolved reclamations (more than 7 days old)
        LocalDateTime sevenDaysAgo = LocalDateTime.now().minusDays(7);
        List<Reclamation> nonResolues = reclamations.stream()
                .filter(r -> r.getDate() != null)
                .filter(r -> r.getDate().isBefore(sevenDaysAgo))
                .filter(r -> !"résolue".equalsIgnoreCase(r.getStatus()) && !"resolue".equalsIgnoreCase(r.getStatus()) && !"resolved".equalsIgnoreCase(r.getStatus()))
                .collect(Collectors.toList());

        return ReclamationAnalytics.builder()
                .totalReclamations(reclamations.size())
                .parStatus(parStatus)
                .tempsResolutionMoyen(Math.round(tempsResolutionMoyen * 100.0) / 100.0)
                .parMois(parMois)
                .nonResolues(nonResolues)
                .reclamationEnAttente(enAttente)
                .reclamationResolue(resolue)
                .build();
    }
}
