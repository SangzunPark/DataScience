package com.sangzunpark.datascience.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

@Service("loginService")
public class LoginService implements UserDetailsService {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        //db에서 유저정보를 가져온다.
        List<Map<String,String>> findUserResult =  jdbcTemplate.query(
                "select * from Users where user_name = ?", new RowMapper<Map<String,String>>() {
                    @Override
                    public Map<String,String> mapRow(ResultSet rs, int rowNum) throws SQLException {
                        String password = rs.getString("User_Password");
                        String userRole = rs.getString("User_Role");
                        Map<String,String> result = new HashMap<>();
                        result.put("User_Password",password);
                        result.put("User_Role",userRole);
                        return result;
                    }
                },username);

        if(findUserResult.size()==0){
            throw new UsernameNotFoundException("User not found");
        }else{
            Map<String,String> userInfo = findUserResult.get(0);;
            String password = userInfo.get("User_Password");
            String userRole = userInfo.get("User_Role");
            List<GrantedAuthority> authorities = new ArrayList<>();

            String userRoleList[] = userRole.split(",");
            for(int i=0; i<userRoleList.length; i++){
                authorities.add(new SimpleGrantedAuthority(userRoleList[i]));
            }
            return new org.springframework.security.core.userdetails.User(username, password, authorities);
        }
    }
}
