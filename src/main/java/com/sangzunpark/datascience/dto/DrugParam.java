package com.sangzunpark.datascience.dto;

public class DrugParam {
    private Integer year;
    private Integer brand;
    private Integer generic;
    private String searchText;
    private Integer pageNum;
    private Integer pageSize;
    private String orderByColumn;
    private String orderByType;

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public Integer getBrand() {
        return brand;
    }

    public void setBrand(Integer brand) {
        this.brand = brand;
    }

    public Integer getGeneric() {
        return generic;
    }

    public void setGeneric(Integer generic) {
        this.generic = generic;
    }

    public String getSearchText() {
        return searchText;
    }

    public void setSearchText(String searchText) {
        this.searchText = searchText;
    }

    public Integer getPageNum() {
        return pageNum;
    }

    public void setPageNum(Integer pageNum) {
        this.pageNum = pageNum;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public String getOrderByColumn() {
        return orderByColumn;
    }

    public void setOrderByColumn(String orderByColumn) {
        this.orderByColumn = orderByColumn;
    }

    public String getOrderByType() {
        return orderByType;
    }

    public void setOrderByType(String orderByType) {
        this.orderByType = orderByType;
    }
}
