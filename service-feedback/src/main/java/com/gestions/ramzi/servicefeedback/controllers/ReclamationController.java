package com.gestions.ramzi.servicefeedback.controllers;

import com.gestions.ramzi.servicefeedback.entities.Reclamation;
import com.gestions.ramzi.servicefeedback.services.ReclamationService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reclamations")
public class ReclamationController {

    private final ReclamationService service;

    public ReclamationController(ReclamationService service) {
        this.service = service;
    }

    @GetMapping
    public List<Reclamation> getAll(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) String status) {
        if (userId != null) return service.getByUserId(userId);
        if (status != null) return service.getByStatus(status);
        return service.getAll();
    }

    @GetMapping("/{id}")
    public Reclamation getById(@PathVariable Long id) {
        return service.getById(id);
    }

    @PostMapping
    public Reclamation create(@RequestBody Reclamation reclamation) {
        return service.create(reclamation);
    }

    @PutMapping("/{id}/status")
    public Reclamation updateStatus(@PathVariable Long id, @RequestParam String status) {
        return service.updateStatus(id, status);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}
