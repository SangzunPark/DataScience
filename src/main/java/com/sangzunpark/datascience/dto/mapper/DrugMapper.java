package com.sangzunpark.datascience.dto.mapper;

import com.sangzunpark.datascience.dto.Drug;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class DrugMapper implements RowMapper<Drug> {
    @Override
    public Drug mapRow(ResultSet rs, int rowNum) throws SQLException {
        Drug drug = new Drug();
        drug.setYearCode(rs.getInt("Year_Code"));
        drug.setYearName(rs.getString("Year_Name"));
        drug.setBrandCode(rs.getInt("Brand_Code"));
        drug.setBrandName(rs.getString("Brand_Name"));
        drug.setGenericCode(rs.getInt("Generic_Code"));
        drug.setGenericName(rs.getString("Generic_Name"));
        drug.setClaimCount(rs.getLong("Claim_Count"));
        drug.setTotalSpending(rs.getDouble("Total_Spending"));
        drug.setBeneficiaryCount(rs.getLong("Beneficiary_Count"));
        drug.setTotalAnnualSpendingPerUser(rs.getDouble("Total_Annual_Spending_per_User"));
        drug.setUnitCount(rs.getLong("Unit_Count"));
        drug.setAverageCostPerUnit(rs.getDouble("Average_Cost_Per_Unit"));
        drug.setBeneficiaryCountNoLIS(rs.getLong("Beneficiary_Count_No_LIS"));
        drug.setBeneficiaryCountLIS(rs.getLong("Beneficiary_Count_LIS"));
        return drug;
    }
}
