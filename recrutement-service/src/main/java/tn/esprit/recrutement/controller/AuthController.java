package tn.esprit.recrutement.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tn.esprit.recrutement.security.JwtUtil;

import java.util.Map;

/**
 * Endpoint d'authentification pour obtenir un token JWT.
 * En production, ceci serait remplacé par Keycloak ou un service d'auth dédié.
 */
@RestController
@RequestMapping("/api/recrutement/auth")
@RequiredArgsConstructor
public class AuthController {

    private final JwtUtil jwtUtil;

    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> login(@RequestBody Map<String, String> credentials) {
        String username = credentials.get("username");
        String password = credentials.get("password");

        // Simulation : admin/admin123 → ADMIN, user/user123 → USER
        if ("admin".equals(username) && "admin123".equals(password)) {
            String token = jwtUtil.generateToken(username, "ADMIN");
            return ResponseEntity.ok(Map.of(
                "token", token,
                "role", "ADMIN",
                "message", "Connexion réussie"
            ));
        } else if ("user".equals(username) && "user123".equals(password)) {
            String token = jwtUtil.generateToken(username, "USER");
            return ResponseEntity.ok(Map.of(
                "token", token,
                "role", "USER",
                "message", "Connexion réussie"
            ));
        }

        return ResponseEntity.status(401).body(Map.of("message", "Identifiants invalides"));
    }
}
