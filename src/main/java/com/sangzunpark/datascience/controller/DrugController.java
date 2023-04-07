package com.sangzunpark.datascience.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
public class DrugController {
    @GetMapping("/drug/list")
    public String list(HttpServletRequest request){
        return "drug/list";
    }
}
