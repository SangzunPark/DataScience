package com.sangzunpark.datascience.service;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service("loginService")
public class LoginService implements UserDetailsService {
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        if ("test".equals(username)) {
            String password = new BCryptPasswordEncoder().encode("test");
            List<GrantedAuthority> authorities = Arrays.asList(new SimpleGrantedAuthority("USER"));
            return new org.springframework.security.core.userdetails.User(username, password, authorities);
        } else {
            throw new UsernameNotFoundException("User not found");
        }
    }
}
