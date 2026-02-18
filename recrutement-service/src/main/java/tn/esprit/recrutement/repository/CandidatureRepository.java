package tn.esprit.recrutement.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import tn.esprit.recrutement.entity.CandidatureEnseignant;

import java.util.List;
import java.util.Optional;

@Repository
public interface CandidatureRepository extends JpaRepository<CandidatureEnseignant, Long> {
    
    Optional<CandidatureEnseignant> findByEmail(String email);
    
    List<CandidatureEnseignant> findByStatut(String statut);
    
    boolean existsByEmailAndOffreId(String email, Long offreId);
    
    List<CandidatureEnseignant> findByOffreId(Long offreId);
}
