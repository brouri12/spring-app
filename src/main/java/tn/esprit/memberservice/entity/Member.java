package tn.esprit.memberservice.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;

import java.util.Date;

@Entity
@Table(name = "members")
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_member")
    private Long idMember;

    @NotNull(message = "idUser est obligatoire")
    @Column(name = "id_user", nullable = false)
    private Long idUser;

    // Ces champs seront remplis automatiquement (pas saisis)
    private String nom;
    private String prenom;
    private String email;
    private String telephone;

    @NotNull(message = "niveauAnglais est obligatoire")
    @Enumerated(EnumType.STRING)
    @Column(name = "niveau_anglais", nullable = false)
    private NiveauAnglais niveauAnglais;

    @Temporal(TemporalType.DATE)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    @Column(name = "date_join")
    private Date dateJoin;

    @PrePersist
    public void prePersist() {
        if (dateJoin == null) dateJoin = new Date();
    }

    // Getters & Setters
    public Long getIdMember() { return idMember; }
    public void setIdMember(Long idMember) { this.idMember = idMember; }

    public Long getIdUser() { return idUser; }
    public void setIdUser(Long idUser) { this.idUser = idUser; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public NiveauAnglais getNiveauAnglais() { return niveauAnglais; }
    public void setNiveauAnglais(NiveauAnglais niveauAnglais) { this.niveauAnglais = niveauAnglais; }

    public Date getDateJoin() { return dateJoin; }
    public void setDateJoin(Date dateJoin) { this.dateJoin = dateJoin; }
}
