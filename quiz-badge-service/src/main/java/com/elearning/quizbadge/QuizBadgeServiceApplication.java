package com.elearning.quizbadge;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

/**
 * Main application class for Quiz Badge Service.
 * Provides quiz and badge functionality for the e-learning platform.
 */
@SpringBootApplication
@EnableDiscoveryClient
public class QuizBadgeServiceApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(QuizBadgeServiceApplication.class, args);
    }
}
