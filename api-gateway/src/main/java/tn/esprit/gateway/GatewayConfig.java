package tn.esprit.gateway;

import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GatewayConfig {

    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                // Route pour Forum Service
                .route("forum-service", r -> r
                        .path("/forum/**")
                        .uri("lb://forum-service"))
                
                // Route pour Recrutement Service
                .route("recrutement-service", r -> r
                        .path("/recrutement/**")
                        .uri("lb://recrutement-service"))
                
                // Route directe vers Forum API (alternative)
                .route("forum-api", r -> r
                        .path("/api/forum/**")
                        .uri("lb://forum-service"))
                
                // Route directe vers Recrutement API (alternative)
                .route("recrutement-api", r -> r
                        .path("/api/recrutement/**")
                        .uri("lb://recrutement-service"))
                
                .build();
    }
}
