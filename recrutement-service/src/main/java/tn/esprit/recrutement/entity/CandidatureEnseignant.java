package tn.esprit.recrutement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import tn.esprit.recrutement.validation.*;
import java.time.LocalDate;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = "offre")
public class CandidatureEnseignant {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonProperty("id_candidature")
    private Long id;
    
    @NotBlank(message = "Le nom du candidat est obligatoire")
    @ValidName(message = "Le nom doit contenir uniquement des lettres, commencer par une majuscule, et avoir entre 2 et 50 caractères")
    private String nom_candidat;
    
    @NotBlank(message = "Le prénom du candidat est obligatoire")
    @ValidName(message = "Le prénom doit contenir uniquement des lettres, commencer par une majuscule, et avoir entre 2 et 50 caractères")
    private String prenom_candidat;
    
    @NotBlank(message = "L'email est obligatoire")
    @ValidEmail(message = "Email invalide. Format attendu : exemple@domaine.com (5-100 caractères, domaine valide)")
    @Column(unique = true)
    private String email;
    
    @Lob
    @Column(name = "cv_pdf", columnDefinition = "LONGBLOB")
    private byte[] cv_pdf;
    
    @Column(name = "cv_filename")
    private String cv_filename;
    
    @Column(name = "cv_content_type")
    private String cv_content_type;
    
    @Column(name = "cv_url")
    private String cv_url = "";
    
    @NotBlank(message = "La lettre de motivation est obligatoire")
    @ValidLettreMotivation(message = "Lettre de motivation invalide. Doit contenir 100-2000 caractères, au moins 20 mots, et des phrases complètes")
    @Column(length = 2000)
    private String lettre_motivation;
    
    private LocalDate date_candidature;
    
    @NotBlank(message = "Le statut est obligatoire")
    @Pattern(regexp = "EN_ATTENTE|ACCEPTEE|REFUSEE", message = "Le statut doit être EN_ATTENTE, ACCEPTEE ou REFUSEE")
    private String statut; // EN_ATTENTE, ACCEPTEE, REFUSEE
    
    @ManyToOne
    @JoinColumn(name = "offre_id")
    @JsonIgnore
    private OffreRecrutement offre;
}
