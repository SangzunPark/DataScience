package com.sangzunpark.datascience.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@EnableWebSecurity
public class SpringSecurityConfig extends WebSecurityConfigurerAdapter {
    @Autowired
    @Qualifier("loginService")
    private UserDetailsService userDetailsService;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.csrf().disable()
                    .authorizeRequests()
                    .antMatchers("/login","/signup","/signupProc","/logout","/connect").permitAll() // 로그인 페이지는 인증 없이 접근 가능
                    .anyRequest().authenticated() // 로그인 이후 모든 요청은 인증이 필요
                .and()
                    .formLogin()
                    .loginPage("/login") // 로그인 페이지 경로 설정
                    .loginProcessingUrl("/loginProc") //loginProcessingUrl를 정의하면
                        //.usernameParameter("username") //login.jsp에 명시된 유져아이디 파라미터
                        //.passwordParameter("password") //login.jsp에 명시된 패스워드 파라미터
                    .defaultSuccessUrl("/drug/list")  // 로그인 성공 후 이동할 경로 설정
                    //.permitAll()
                .and()
                    .logout()
                    .logoutUrl("/logout") // 로그아웃 경로 설정
                    .logoutSuccessUrl("/login") // 로그아웃 성공 후 이동할 경로 설정
                //.permitAll();
        ;
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(passwordEncoder());
    }

    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }
}