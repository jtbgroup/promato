package com.promato.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.promato.user.AppUser;

import java.util.Optional;

public interface AppUserRepository extends JpaRepository<AppUser, Long> {
    Optional<AppUser> findByUsername(String username);
}
