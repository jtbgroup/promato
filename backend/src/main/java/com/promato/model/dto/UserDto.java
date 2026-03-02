package com.promato.model.dto;

import com.promato.user.AppUser;

public record UserDto(Long id, String username, String email, String role) {

    public static UserDto from(AppUser user) {
        return new UserDto(user.getId(), user.getUsername(), user.getEmail(), user.getRole());
    }
}
