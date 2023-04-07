package com.sangzunpark.datascience.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @RequestMapping(value = "/Hello")
    public String hello(){
        return "Hello World";
    }

    @RequestMapping(value = "/connect")
    public String connect(){
        int count = 0;
        try {
            count = jdbcTemplate.queryForObject("select 1", Integer.class);
        }catch(Exception e){
            e.printStackTrace();
        }
        return "Success result = "+count;
    }
}
