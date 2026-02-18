package com.gestions.ramzi.servicefeedback.services;

import com.gestions.ramzi.servicefeedback.entities.Reclamation;
import com.gestions.ramzi.servicefeedback.repositories.ReclamationRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ReclamationService {

    private final ReclamationRepository repository;

    public ReclamationService(ReclamationRepository repository) {
        this.repository = repository;
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

    public Reclamation updateStatus(Long id, String newStatus) {
        Reclamation existing = getById(id);
        if (existing != null) {
            existing.setStatus(newStatus);
            return repository.save(existing);
        }
        return null;
    }

    public void delete(Long id) {
        repository.deleteById(id);
    }
}
