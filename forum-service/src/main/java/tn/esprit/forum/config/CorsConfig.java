package tn.esprit.forum.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.Arrays;

@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();
        
        // Autoriser toutes les origines (pour le développement)
        config.setAllowCredentials(true);
        config.addAllowedOriginPattern("*");
        
        // Autoriser tous les headers
        config.addAllowedHeader("*");
        
        // Autoriser toutes les méthodes HTTP
        config.addAllowedMethod("*");
        
        // Exposer tous les headers
        config.addExposedHeader("*");
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        
        return new CorsFilter(source);
    }
}
