package com.sangzunpark.datascience.dto;

public class Drug {
    private Integer yearCode;
    private Integer brandCode;
    private Integer genericCode;
    private String yearName;
    private String brandName;
    private String genericName;
    private Long claimCount;
    private Double totalSpending;
    private Long beneficiaryCount;
    private Double totalAnnualSpendingPerUser;
    private Long unitCount;
    private Double averageCostPerUnit;
    private Long beneficiaryCountNoLIS;
    private Long beneficiaryCountLIS;

    public Integer getYearCode() {
        return yearCode;
    }

    public void setYearCode(Integer yearCode) {
        this.yearCode = yearCode;
    }

    public Integer getBrandCode() {
        return brandCode;
    }

    public String getYearName() {
        return yearName;
    }

    public void setYearName(String yearName) {
        this.yearName = yearName;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getGenericName() {
        return genericName;
    }

    public void setGenericName(String genericName) {
        this.genericName = genericName;
    }

    public void setBrandCode(Integer brandCode) {
        this.brandCode = brandCode;
    }

    public Integer getGenericCode() {
        return genericCode;
    }

    public void setGenericCode(Integer genericCode) {
        this.genericCode = genericCode;
    }

    public Long getClaimCount() {
        return claimCount;
    }

    public void setClaimCount(Long claimCount) {
        this.claimCount = claimCount;
    }

    public Double getTotalSpending() {
        return totalSpending;
    }

    public void setTotalSpending(Double totalSpending) {
        this.totalSpending = totalSpending;
    }

    public Long getBeneficiaryCount() {
        return beneficiaryCount;
    }

    public void setBeneficiaryCount(Long beneficiaryCount) {
        this.beneficiaryCount = beneficiaryCount;
    }

    public Double getTotalAnnualSpendingPerUser() {
        return totalAnnualSpendingPerUser;
    }

    public void setTotalAnnualSpendingPerUser(Double totalAnnualSpendingPerUser) {
        this.totalAnnualSpendingPerUser = totalAnnualSpendingPerUser;
    }

    public Long getUnitCount() {
        return unitCount;
    }

    public void setUnitCount(Long unitCount) {
        this.unitCount = unitCount;
    }

    public Double getAverageCostPerUnit() {
        return averageCostPerUnit;
    }

    public void setAverageCostPerUnit(Double averageCostPerUnit) {
        this.averageCostPerUnit = averageCostPerUnit;
    }

    public Long getBeneficiaryCountNoLIS() {
        return beneficiaryCountNoLIS;
    }

    public void setBeneficiaryCountNoLIS(Long beneficiaryCountNoLIS) {
        this.beneficiaryCountNoLIS = beneficiaryCountNoLIS;
    }

    public Long getBeneficiaryCountLIS() {
        return beneficiaryCountLIS;
    }

    public void setBeneficiaryCountLIS(Long beneficiaryCountLIS) {
        this.beneficiaryCountLIS = beneficiaryCountLIS;
    }
}
