package com.sangzunpark.datascience.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {
    @RequestMapping(value = "/Hello")
    public String hello(){
        return "Hello World";
    }
}
