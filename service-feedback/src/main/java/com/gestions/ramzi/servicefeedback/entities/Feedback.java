package com.gestions.ramzi.servicefeedback.entities;

import com.gestions.ramzi.servicefeedback.dto.UserDTO;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Feedback {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Identifiants pour les relations inter-services
    @Column(name = "user_id")
    private Long userId;

    @Column(name = "module_id")
    private Long moduleId;

    private int note;

    private String commentaire;

    private LocalDateTime date;

    // Relations locales (optionnelles, non persistées)
    @Transient
    private UserDTO user; // récupéré via Feign Client

    @Transient
    private Module module; // récupéré via un autre service si nécessaire
}
