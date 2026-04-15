package tn.esprit.recrutement.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthFilter jwtAuthFilter;

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOriginPatterns(List.of("*"));
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
        config.setAllowedHeaders(List.of("*"));
        config.setAllowCredentials(false);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return source;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .csrf(csrf -> csrf.disable())
            .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                // Preflight OPTIONS — toujours autorisé
                .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                // Swagger & Actuator
                .requestMatchers("/swagger-ui/**", "/v3/api-docs/**", "/actuator/**").permitAll()
                // Auth
                .requestMatchers("/api/recrutement/auth/**").permitAll()
                // Lecture offres — public
                .requestMatchers(HttpMethod.GET, "/api/recrutement/offres/**").permitAll()
                // Postuler — public
                .requestMatchers(HttpMethod.POST, "/api/recrutement/candidatures/offre/**").permitAll()
                // Télécharger CV — public
                .requestMatchers(HttpMethod.GET, "/api/recrutement/candidatures/*/cv").permitAll()
                // Vérifier doublon — public
                .requestMatchers(HttpMethod.GET, "/api/recrutement/candidatures/doublon").permitAll()
                // Analyse lettre — public
                .requestMatchers(HttpMethod.POST, "/api/recrutement/analyse-lettre").permitAll()
                // Tout le reste — permit all pour le moment (à sécuriser en prod)
                .anyRequest().permitAll()
            )
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
