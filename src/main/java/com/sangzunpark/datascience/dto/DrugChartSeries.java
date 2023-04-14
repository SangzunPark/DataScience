package com.sangzunpark.datascience.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.ArrayList;
import java.util.List;

public class DrugChartSeries {
    private String name;
    private List<Double> data = new ArrayList<>();
    public DrugChartSeries(String name){
        this.name = name;
    }
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Double> getData() {
        return data;
    }

    public void setData(List<Double> data) {
        this.data = data;
    }

    @JsonIgnore
    public void addData(Double data){
        this.data.add(data);
    }
}
