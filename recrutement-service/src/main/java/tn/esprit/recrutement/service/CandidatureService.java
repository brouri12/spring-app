package tn.esprit.recrutement.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import tn.esprit.recrutement.entity.CandidatureEnseignant;
import tn.esprit.recrutement.entity.OffreRecrutement;
import tn.esprit.recrutement.repository.CandidatureRepository;
import tn.esprit.recrutement.repository.OffreRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CandidatureService {
    
    private final CandidatureRepository candidatureRepository;
    private final OffreRepository offreRepository;
    
    public Optional<CandidatureEnseignant> postuler(Long offreId, CandidatureEnseignant candidature) {
        // Vérifier si l'offre existe
        Optional<OffreRecrutement> offre = offreRepository.findById(offreId);
        if (offre.isEmpty()) {
            return Optional.empty();
        }
        
        // Vérifier si le candidat n'a pas déjà postulé
        if (candidatureRepository.existsByEmailAndOffreId(candidature.getEmail(), offreId)) {
            throw new RuntimeException("Vous avez déjà postulé à cette offre");
        }
        
        // Forcer l'ID à null pour permettre la génération automatique
        candidature.setId(null);
        candidature.setOffre(offre.get());
        candidature.setDate_candidature(LocalDate.now());
        if (candidature.getStatut() == null) {
            candidature.setStatut("EN_ATTENTE");
        }
        
        return Optional.of(candidatureRepository.save(candidature));
    }
    
    public Optional<CandidatureEnseignant> changerStatut(Long candidatureId, String nouveauStatut) {
        return candidatureRepository.findById(candidatureId).map(candidature -> {
            candidature.setStatut(nouveauStatut);
            
            // Si acceptée, marquer l'offre comme pourvue
            if ("ACCEPTEE".equals(nouveauStatut)) {
                OffreRecrutement offre = candidature.getOffre();
                offre.setStatut("POURVUE");
                offreRepository.save(offre);
            }
            
            return candidatureRepository.save(candidature);
        });
    }
    
    public List<CandidatureEnseignant> getCandidaturesByOffre(Long offreId) {
        return candidatureRepository.findByOffreId(offreId);
    }
    
    public List<CandidatureEnseignant> filtrerParSpecialite(String specialite) {
        return candidatureRepository.findAll().stream()
                .filter(c -> c.getOffre().getSpecialite().equalsIgnoreCase(specialite))
                .toList();
    }
    
    public String convertirEnEnseignantSiAcceptee(Long candidatureId) {
        Optional<CandidatureEnseignant> candidature = candidatureRepository.findById(candidatureId);
        
        if (candidature.isEmpty()) {
            return "Candidature introuvable";
        }
        
        if (!"ACCEPTEE".equals(candidature.get().getStatut())) {
            return "La candidature doit être acceptée pour être convertie";
        }
        
        // Logique de conversion en enseignant (à implémenter avec un autre microservice)
        return "Candidat converti en enseignant avec succès : " + 
               candidature.get().getNom_candidat() + " " + 
               candidature.get().getPrenom_candidat();
    }
    
    public List<CandidatureEnseignant> getAllCandidatures() {
        return candidatureRepository.findAll();
    }
    
    public List<CandidatureEnseignant> getCandidaturesByStatut(String statut) {
        return candidatureRepository.findByStatut(statut);
    }
}
