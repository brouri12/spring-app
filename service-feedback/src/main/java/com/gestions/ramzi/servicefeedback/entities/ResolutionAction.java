package com.gestions.ramzi.servicefeedback.entities;

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
public class ResolutionAction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String action;

    private String responsable;

    private LocalDateTime dateAction;

    @Column(name = "reclamation_id", insertable = false, updatable = false)
    private Long reclamationId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reclamation_id", referencedColumnName = "id", insertable = false, updatable = false)
    private Reclamation reclamation;
}
