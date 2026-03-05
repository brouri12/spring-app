package tn.esprit.recrutement.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import tn.esprit.recrutement.entity.CandidatureEnseignant;
import tn.esprit.recrutement.entity.OffreRecrutement;
import tn.esprit.recrutement.service.CandidatureService;
import tn.esprit.recrutement.service.OffreService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @PatchMapping("/offres/{id}/rouvrir")
    public ResponseEntity<OffreRecrutement> rouvrirOffre(@PathVariable Long id) {
        return offreService.rouvrirOffre(id)
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
            @Valid @RequestBody CandidatureEnseignant candidature,
            BindingResult bindingResult) {

        System.out.println("📥 Requête POST reçue pour offre ID: " + offreId);
        System.out.println("📦 Candidature reçue: " + candidature.getNom_candidat() + " " + candidature.getPrenom_candidat());
        System.out.println("📧 Email: " + candidature.getEmail());
        System.out.println("📄 CV filename: " + candidature.getCv_filename());
        System.out.println("📝 Lettre motivation length: " + (candidature.getLettre_motivation() != null ? candidature.getLettre_motivation().length() : 0));
        
        if (bindingResult.hasErrors()) {
            System.out.println("❌ Erreurs de validation:");
            bindingResult.getAllErrors().forEach(error -> {
                System.out.println("  - " + error.getDefaultMessage());
            });
            Map<String, String> errors = new HashMap<>();
            bindingResult.getFieldErrors().forEach(error -> {
                errors.put(error.getField(), error.getDefaultMessage());
            });
            return ResponseEntity.badRequest().body(errors);
        }

        try {
            System.out.println("✅ Validation OK, appel du service...");
            return candidatureService.postuler(offreId, candidature)
                    .<ResponseEntity<Object>>map(saved -> {
                        System.out.println("✅ Candidature créée avec succès: " + saved.getId());
                        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
                    })
                    .orElseGet(() -> {
                        System.out.println("❌ Offre introuvable");
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .body("Offre introuvable");
                    });

        } catch (RuntimeException e) {
            System.out.println("❌ Exception: " + e.getMessage());
            e.printStackTrace();
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
