package tn.esprit.recrutement.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tn.esprit.recrutement.entity.CandidatureEnseignant;
import tn.esprit.recrutement.entity.OffreRecrutement;
import tn.esprit.recrutement.service.CandidatureService;
import tn.esprit.recrutement.service.OffreService;

import java.util.List;

@RestController
@RequestMapping("/api/recrutement")
@RequiredArgsConstructor
public class RecrutementRestAPI {
    
    private final OffreService offreService;
    private final CandidatureService candidatureService;
    
    // ========== CRUD OFFRES ==========
    
    @GetMapping("/offres")
    public ResponseEntity<List<OffreRecrutement>> getAllOffres() {
        return ResponseEntity.ok(offreService.getAllOffres());
    }
    
    @GetMapping("/offres/{id}")
    public ResponseEntity<OffreRecrutement> getOffreById(@PathVariable Long id) {
        return offreService.getOffreById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping("/offres")
    public ResponseEntity<OffreRecrutement> addOffre(@Valid @RequestBody OffreRecrutement offre) {
        OffreRecrutement savedOffre = offreService.addOffre(offre);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedOffre);
    }
    
    @PutMapping("/offres/{id}")
    public ResponseEntity<OffreRecrutement> updateOffre(
            @PathVariable Long id, 
            @Valid @RequestBody OffreRecrutement offre) {
        return offreService.updateOffre(id, offre)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @DeleteMapping("/offres/{id}")
    public ResponseEntity<Void> deleteOffre(@PathVariable Long id) {
        if (offreService.deleteOffre(id)) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
    
    @PatchMapping("/offres/{id}/fermer")
    public ResponseEntity<OffreRecrutement> fermerOffre(@PathVariable Long id) {
        return offreService.fermerOffre(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/offres/statut/{statut}")
    public ResponseEntity<List<OffreRecrutement>> getOffresByStatut(@PathVariable String statut) {
        return ResponseEntity.ok(offreService.getOffresByStatut(statut));
    }
    
    @GetMapping("/offres/specialite/{specialite}")
    public ResponseEntity<List<OffreRecrutement>> getOffresBySpecialite(@PathVariable String specialite) {
        return ResponseEntity.ok(offreService.getOffresBySpecialite(specialite));
    }
    
    // ========== GESTION CANDIDATURES ==========
    
    @GetMapping("/candidatures")
    public ResponseEntity<List<CandidatureEnseignant>> getAllCandidatures() {
        return ResponseEntity.ok(candidatureService.getAllCandidatures());
    }

    @PostMapping("/candidatures/offre/{offreId}")
    public ResponseEntity<Object> postuler(
            @PathVariable Long offreId,
            @Valid @RequestBody CandidatureEnseignant candidature) {

        try {
            return candidatureService.postuler(offreId, candidature)
                    .<ResponseEntity<Object>>map(saved ->
                            ResponseEntity.status(HttpStatus.CREATED).body(saved))
                    .orElseGet(() ->
                            ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                    .body("Offre introuvable"));

        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(e.getMessage());
        }
    }


    @PatchMapping("/candidatures/{id}/statut")
    public ResponseEntity<CandidatureEnseignant> changerStatut(
            @PathVariable Long id,
            @RequestParam String statut) {
        return candidatureService.changerStatut(id, statut)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/candidatures/offre/{offreId}")
    public ResponseEntity<List<CandidatureEnseignant>> getCandidaturesByOffre(@PathVariable Long offreId) {
        return ResponseEntity.ok(candidatureService.getCandidaturesByOffre(offreId));
    }
    
    @GetMapping("/candidatures/statut/{statut}")
    public ResponseEntity<List<CandidatureEnseignant>> getCandidaturesByStatut(@PathVariable String statut) {
        return ResponseEntity.ok(candidatureService.getCandidaturesByStatut(statut));
    }
    
    @GetMapping("/candidatures/specialite/{specialite}")
    public ResponseEntity<List<CandidatureEnseignant>> filtrerParSpecialite(@PathVariable String specialite) {
        return ResponseEntity.ok(candidatureService.filtrerParSpecialite(specialite));
    }
    
    @PostMapping("/candidatures/{id}/convertir")
    public ResponseEntity<String> convertirEnEnseignant(@PathVariable Long id) {
        String result = candidatureService.convertirEnEnseignantSiAcceptee(id);
        return ResponseEntity.ok(result);
    }
}
