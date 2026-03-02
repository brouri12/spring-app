package com.gestions.ramzi.servicefeedback.controllers;

import com.gestions.ramzi.servicefeedback.dto.ReclamationAnalytics;
import com.gestions.ramzi.servicefeedback.entities.Reclamation;
import com.gestions.ramzi.servicefeedback.services.ReclamationService;
import com.gestions.ramzi.servicefeedback.services.NotificationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reclamations")
public class ReclamationController {

    private static final Logger logger = LoggerFactory.getLogger(ReclamationController.class);
    
    private final ReclamationService service;
    private final NotificationService notificationService;

    public ReclamationController(ReclamationService service, NotificationService notificationService) {
        this.service = service;
        this.notificationService = notificationService;
        logger.info("ReclamationController initialized");
    }

    @GetMapping
    public List<Reclamation> getAll(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) String status) {
        logger.info("GET /api/reclamations - userId: {}, status: {}", userId, status);
        if (userId != null) return service.getByUserId(userId);
        if (status != null) return service.getByStatus(status);
        return service.getAll();
    }

    @GetMapping("/analytics")
    public ReclamationAnalytics getAnalytics(
            @RequestParam(required = false) String dateDebut,
            @RequestParam(required = false) String dateFin) {
        logger.info("GET /api/reclamations/analytics - dateDebut: {}, dateFin: {}", dateDebut, dateFin);
        try {
            ReclamationAnalytics analytics = service.getAnalytics(dateDebut, dateFin);
            logger.info("Analytics retrieved: totalReclamations={}", analytics.getTotalReclamations());
            return analytics;
        } catch (Exception e) {
            logger.error("Error getting analytics: {}", e.getMessage(), e);
            throw e;
        }
    }

    @GetMapping("/{id}")
    public Reclamation getById(@PathVariable Long id) {
        logger.info("GET /api/reclamations/{}", id);
        return service.getById(id);
    }

    @PostMapping
    public Reclamation create(@RequestBody Reclamation reclamation) {
        logger.info("POST /api/reclamations - objet: {}", reclamation.getObjet());
        Reclamation saved = service.create(reclamation);
        // Envoyer notification nouvelle réclamation
        notificationService.notifierNouvelleReclamation(saved);
        return saved;
    }

    @PutMapping("/{id}")
    public Reclamation update(@PathVariable Long id, @RequestBody Reclamation reclamation) {
        logger.info("PUT /api/reclamations/{}", id);
        return service.update(id, reclamation);
    }

    @PutMapping("/{id}/status")
    public Reclamation updateStatus(@PathVariable Long id, @RequestParam String status) {
        logger.info("PUT /api/reclamations/{}/status - status: {}", id, status);
        Reclamation reclamation = service.updateStatus(id, status);
        // Envoyer notification si réclamation résolue
        if ("RESOLUE".equals(status)) {
            notificationService.notifierReclamationResolue(reclamation);
        }
        return reclamation;
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        logger.info("DELETE /api/reclamations/{}", id);
        service.delete(id);
    }
}
