package com.promato.security;

import com.promato.security.AppUserDetailsService;
import com.promato.user.AppUser;
import com.promato.user.AppUserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AppUserDetailsServiceTest {

    @Mock
    private AppUserRepository userRepository;

    @InjectMocks
    private AppUserDetailsService service;

    private AppUser activeUser;

    @BeforeEach
    void setUp() {
        activeUser = new AppUser();
        activeUser.setId(1L);
        activeUser.setUsername("admin");
        activeUser.setPasswordHash("$2a$12$hash");
        activeUser.setEmail("admin@promato.local");
        activeUser.setRole("ADMIN");
        activeUser.setActive(true);
    }

    @Test
    void loadUserByUsername_userFoundAndActive_returnsUserDetails() {
        when(userRepository.findByUsername("admin")).thenReturn(Optional.of(activeUser));

        var userDetails = service.loadUserByUsername("admin");

        assertThat(userDetails.getUsername()).isEqualTo("admin");
        assertThat(userDetails.getAuthorities()).anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
    }

    @Test
    void loadUserByUsername_userNotFound_throwsUsernameNotFoundException() {
        when(userRepository.findByUsername("unknown")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.loadUserByUsername("unknown"))
            .isInstanceOf(UsernameNotFoundException.class);
    }

    @Test
    void loadUserByUsername_userInactive_throwsDisabledException() {
        activeUser.setActive(false);
        when(userRepository.findByUsername("admin")).thenReturn(Optional.of(activeUser));

        assertThatThrownBy(() -> service.loadUserByUsername("admin"))
            .isInstanceOf(DisabledException.class);
    }
}
