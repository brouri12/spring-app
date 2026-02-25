package com.gestions.ramzi.servicefeedback.services;

import com.gestions.ramzi.servicefeedback.entities.Reclamation;
import com.gestions.ramzi.servicefeedback.repositories.ReclamationRepository;
import com.gestions.ramzi.servicefeedback.repositories.ResolutionActionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

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
}
