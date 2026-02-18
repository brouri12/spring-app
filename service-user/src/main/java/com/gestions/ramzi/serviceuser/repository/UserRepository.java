package com.gestions.ramzi.serviceuser.repository;

import com.gestions.ramzi.serviceuser.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
