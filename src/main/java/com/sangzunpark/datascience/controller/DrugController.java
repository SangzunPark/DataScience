package com.sangzunpark.datascience.controller;

import com.sangzunpark.datascience.dto.*;
import com.sangzunpark.datascience.dto.UpdateResult;
import com.sangzunpark.datascience.service.DrugService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Controller
public class DrugController {
    @Autowired
    DrugService drugService;

    @GetMapping("/drug/list")
    public ModelAndView list(HttpServletRequest request){
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("drug/list");
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        //List<GrantedAuthority> authorities = (List<GrantedAuthority>) authentication.getAuthorities();
        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ADMIN"));
        modelAndView.addObject("IsAdmin",isAdmin);
        return modelAndView;
    }

    @RequestMapping(value="/drug/commonCodeList", method={RequestMethod.POST, RequestMethod.GET})
    public ResponseEntity<ResponseResult> codeList(@RequestBody CodeValueParam param){
        List<CodeValue> list = new ArrayList<>();
        if(param.getFlag().equals("Brand")){
            list = drugService.getBrandCodeList();
        }else if(param.getFlag().equals("Generic")){
            list = drugService.getGenericCodeList();
        }else if(param.getFlag().equals("Year")){
            list = drugService.getYearDimCodeList();
        }
        ResponseResult responseResult = new ResponseResult();
        responseResult.setResult(list);
        return new ResponseEntity<>(responseResult, HttpStatus.OK);
    }

    @RequestMapping(value="/drug/drugList", method={RequestMethod.POST, RequestMethod.GET})
    public ResponseEntity<ResponseResult> drugList(@RequestBody DrugParam param){
        DrugResponse response= drugService.getDrugList(param);
        ResponseResult responseResult = new ResponseResult();
        responseResult.setResult(response);
        return new ResponseEntity<>(responseResult, HttpStatus.OK);
    }

    @RequestMapping(value="/drug/admin/modifyDrug", method={RequestMethod.POST, RequestMethod.GET})
    public ResponseEntity<UpdateResult> modifyDrug(@RequestBody Drug param){
        return new ResponseEntity<>(drugService.modifyDrug(param), HttpStatus.OK);
    }

    @RequestMapping(value="/drug/admin/saveDrug", method={RequestMethod.POST, RequestMethod.GET})
    public ResponseEntity<UpdateResult> saveDrug(@RequestBody Drug param){
        return new ResponseEntity<>(drugService.saveDrug(param), HttpStatus.OK);
    }

    @RequestMapping(value="/drug/admin/deleteDrug", method={RequestMethod.POST, RequestMethod.GET})
    public ResponseEntity<UpdateResult> deleteDrug(@RequestBody Drug param){
        return new ResponseEntity<>(drugService.deleteDrug(param), HttpStatus.OK);
    }
}
