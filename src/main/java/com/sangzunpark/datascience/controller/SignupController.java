package com.sangzunpark.datascience.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import javax.servlet.http.HttpServletRequest;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Controller
public class SignupController {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/signup")
    public String signup(HttpServletRequest request){
        return "signup";
    }

    @PostMapping("signupProc")
    public String signupProc(HttpServletRequest request){
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        //공백체크
        if(!StringUtils.hasText(username) || !StringUtils.hasText(email) || !StringUtils.hasText(password)){
            return "redirect:/signup?error=empty";
        }

        List<Integer> duplicateUserCount =  jdbcTemplate.query(
                "select count(1) as USER_COUNT " +
                "from Users where user_name = ?", new RowMapper<Integer>() {
            @Override
            public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {
                return rs.getInt("USER_COUNT");
            }
        },username);

        //이미 있는 아이디인지 체크
        if(duplicateUserCount.size()>0 && duplicateUserCount.get(0)>0){
            return "redirect:/signup?error=duplicated";
        }

        int updateCount = jdbcTemplate.update(
                "insert into Users(User_Name, User_Password, User_Role, User_Email)" +
                "values (?,?,?,?)",username, new BCryptPasswordEncoder().encode(password), "USER", email);

        //입력된 데이터수가 하나(성공)이면 로그인 페이지 이동
        if(updateCount==1){
            return "redirect:/login";
        }else{
            return "redirect:/signup?error=unknown";
        }

    }
}
