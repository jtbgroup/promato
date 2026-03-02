package com.promato.user;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "app_user")
public class AppUser {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Column(nullable = false, unique = true, length = 100)
    private String email;

    @Column(nullable = false, length = 20)
    private String role;

    @Column(nullable = false)
    private boolean active = true;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Getters
    public Long getId()           { return id; }
    public String getUsername()   { return username; }
    public String getPasswordHash() { return passwordHash; }
    public String getEmail()      { return email; }
    public String getRole()       { return role; }
    public boolean isActive()     { return active; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }

    // Setters
    public void setId(Long id)               { this.id = id; }
    public void setUsername(String username)  { this.username = username; }
    public void setPasswordHash(String hash)  { this.passwordHash = hash; }
    public void setEmail(String email)        { this.email = email; }
    public void setRole(String role)          { this.role = role; }
    public void setActive(boolean active)     { this.active = active; }
}
