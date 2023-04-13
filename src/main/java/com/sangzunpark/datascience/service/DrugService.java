package com.sangzunpark.datascience.service;

import com.sangzunpark.datascience.dto.*;
import com.sangzunpark.datascience.dto.mapper.CodeValueMapper;
import com.sangzunpark.datascience.dto.mapper.DrugMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.util.StringUtils;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Component
public class DrugService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    DataSource dataSource;

    public List<CodeValue> getBrandCodeList(){
        List<CodeValue> codeValueList =  jdbcTemplate.query(
                "select Brand_Code as CODE , Brand_Name as NAME " +
                        "from Brand ", new CodeValueMapper());
        return codeValueList;
    }

    public List<CodeValue> getGenericCodeList(){
        List<CodeValue> codeValueList =  jdbcTemplate.query(
                "select Generic_Code as CODE , Generic_Name as NAME " +
                        "from Generic ", new CodeValueMapper());
        return codeValueList;
    }

    public List<CodeValue> getYearDimCodeList(){
        List<CodeValue> codeValueList =  jdbcTemplate.query(
                "select Year_Code as CODE , Year_Name as NAME " +
                        "from YearDim ", new CodeValueMapper());
        return codeValueList;
    }

    public UpdateResult modifyDrug(Drug param){
        boolean success = true;
        UpdateResult updateResult = new UpdateResult();

        List<Object> paramList = new ArrayList<>();
        paramList.add(param.getClaimCount());
        paramList.add(param.getTotalSpending());
        paramList.add(param.getBeneficiaryCount());
        paramList.add(param.getTotalAnnualSpendingPerUser());
        paramList.add(param.getUnitCount());
        paramList.add(param.getAverageCostPerUnit());
        paramList.add(param.getBeneficiaryCountNoLIS());
        paramList.add(param.getBeneficiaryCountLIS());
        paramList.add(param.getYearCode());
        paramList.add(param.getBrandCode());
        paramList.add(param.getGenericCode());

        try{
            String sql = "update medi_fact set " +
                            "   Claim_Count = ?" +
                            " , Total_Spending = ? " +
                            " , Beneficiary_Count = ? " +
                            " , Total_Annual_Spending_per_User = ? " +
                            " , Unit_Count = ? " +
                            " , Average_Cost_Per_Unit = ? " +
                            " , Beneficiary_Count_No_LIS = ? " +
                            " , Beneficiary_Count_LIS = ? " +
                        " where Year_Code = ? " +
                        "   and Brand_Code = ? " +
                        "   and Generic_Code = ? ";
            int updateCount = jdbcTemplate.update(sql,paramList.toArray());
            updateResult.setUpdateCount(updateCount);
        }catch(Exception e){
            success = false;
            updateResult.setErrorMessage(e.getMessage());
        }
        updateResult.setSuccess(success);
        return updateResult;
    }

    public UpdateResult saveDrug(Drug param){
        PlatformTransactionManager transactionManager = new DataSourceTransactionManager(dataSource);
        TransactionDefinition transactionDefinition = new DefaultTransactionDefinition();
        TransactionStatus transactionStatus = transactionManager.getTransaction(transactionDefinition);
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        UpdateResult updateResult = new UpdateResult();
        boolean success = true;
        int updateCount = 0;
        try{
            if(param.getYearCode()==null || param.getYearCode().equals("")){
                String sql = "insert into YearDim(Year_Name) values (?)";
                updateCount += jdbcTemplate.update(sql,param.getYearName());

                List<Integer> maxNum = jdbcTemplate.query("select max(Year_Code) as MAX_CODE from YearDim ",  new RowMapper<Integer>() {
                    @Override
                    public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {
                        return rs.getInt("MAX_CODE");
                    }
                });
                param.setYearCode(maxNum.get(0));
            }

            if(param.getGenericCode()==null || param.getGenericCode().equals("")){
                String sql = "insert into Generic(Generic_Name) values (?)";
                updateCount += jdbcTemplate.update(sql,param.getGenericName());

                List<Integer> maxNum = jdbcTemplate.query("select max(Generic_Code) as MAX_CODE from Generic ",  new RowMapper<Integer>() {
                    @Override
                    public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {
                        return rs.getInt("MAX_CODE");
                    }
                });
                param.setGenericCode(maxNum.get(0));
            }

            if(param.getBrandCode()==null || param.getBrandCode().equals("")){
                String sql = "insert into Brand(Brand_Name) values (?)";
                updateCount += jdbcTemplate.update(sql,param.getBrandName());

                List<Integer> maxNum = jdbcTemplate.query("select max(Brand_Code) as MAX_CODE from Brand ",  new RowMapper<Integer>() {
                    @Override
                    public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {
                        return rs.getInt("MAX_CODE");
                    }
                });
                param.setBrandCode(maxNum.get(0));
            }

            List<Object> paramList = new ArrayList<>();
            paramList.add(param.getClaimCount());
            paramList.add(param.getTotalSpending());
            paramList.add(param.getBeneficiaryCount());
            paramList.add(param.getTotalAnnualSpendingPerUser());
            paramList.add(param.getUnitCount());
            paramList.add(param.getAverageCostPerUnit());
            paramList.add(param.getBeneficiaryCountNoLIS());
            paramList.add(param.getBeneficiaryCountLIS());
            paramList.add(param.getYearCode());
            paramList.add(param.getBrandCode());
            paramList.add(param.getGenericCode());
            String sql = "insert into medi_fact( " +
                    "   Claim_Count " +
                    " , Total_Spending  " +
                    " , Beneficiary_Count  " +
                    " , Total_Annual_Spending_per_User  " +
                    " , Unit_Count  " +
                    " , Average_Cost_Per_Unit  " +
                    " , Beneficiary_Count_No_LIS  " +
                    " , Beneficiary_Count_LIS  " +
                    " , Year_Code  " +
                    " , Brand_Code  " +
                    " , Generic_Code " +
                    " ) values (?,?,?,?,?,?,?,?,?,?,?)";
            updateCount+= jdbcTemplate.update(sql,paramList.toArray());
            updateResult.setUpdateCount(updateCount);

            transactionManager.commit(transactionStatus);
        }catch(Exception e){
            transactionManager.rollback(transactionStatus);
            success = false;
            updateResult.setErrorMessage(e.getMessage());
        }
        updateResult.setSuccess(success);
        return updateResult;
    }

    public UpdateResult deleteDrug(Drug param){
        UpdateResult updateResult = new UpdateResult();
        boolean success = true;
        int updateCount = 0;
        List<Object> paramList = new ArrayList<>();
        paramList.add(param.getYearCode());
        paramList.add(param.getBrandCode());
        paramList.add(param.getGenericCode());

        try{
            String sql = "delete from medi_fact where " +
                    "     Year_Code = ? " +
                    " and Brand_Code = ? " +
                    " and Generic_Code = ?" ;
            updateCount = jdbcTemplate.update(sql,paramList.toArray());
            updateResult.setUpdateCount(updateCount);
        }catch(Exception e){
            success = false;
            updateResult.setErrorMessage(e.getMessage());
        }
        updateResult.setSuccess(success);
        return updateResult;
    }

    public DrugResponse getDrugList(DrugParam param){
        List<Object> paramList = new ArrayList<>();
        String sql = "select f.*  " +
                    " , y.Year_Name " +
                    " , g.Generic_Name " +
                    " , b.Brand_Name " +
                    " from medi_fact f " +
                    " left outer join YearDim y " +
                    "   on y.Year_Code = f.Year_Code " +
                    " left outer  join Generic g " +
                    "   on g.Generic_Code = f.Generic_Code " +
                    " left outer join Brand b " +
                    "   on b.Brand_Code = f.Brand_Code " +
                    " where 1=1 ";
        if(param.getBrand()!=null){
            sql += " and f.Brand_Code = ? ";
            paramList.add(param.getBrand());
        }
        if(param.getYear()!=null){
            sql += " and f.Year_Code = ? ";
            paramList.add(param.getYear());
        }
        if(param.getGeneric()!=null){
            sql += " and f.Generic_Code = ? ";
            paramList.add(param.getGeneric());
        }
        if(StringUtils.hasText(param.getSearchText())){
            sql += " and (y.Year_Name like ? or g.Generic_Name like ? or b.Brand_Name like ?)";
            paramList.add("%"+param.getSearchText()+"%");
            paramList.add("%"+param.getSearchText()+"%");
            paramList.add("%"+param.getSearchText()+"%");
        }

        List<Integer> totalCount = jdbcTemplate.query("select count(*) as CNT from ("+sql+") as total_temp ", paramList.toArray() , new RowMapper<Integer>() {
            @Override
            public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {
                return rs.getInt("CNT");
            }
        });

        if(param.getOrderByColumn()!=null){
            sql += " Order by ";
            if(param.getOrderByColumn().equals("Year")){
                sql += " y.Year_Name ";
            }
            if(param.getOrderByColumn().equals("Brand")){
                sql += " b.Brand_Name ";
            }
            if(param.getOrderByColumn().equals("Generic")){
                sql += " g.Generic_Name ";
            }

            if(param.getOrderByType()!=null && param.getOrderByType().equals("Desc")){
                sql += " Desc ";
            }
        }

        sql += " limit ";
        int offset = param.getPageNum() * param.getPageSize();
        if(offset!=0){
            sql += " ? ,";
            paramList.add(offset);
        }
        sql += "? ";
        paramList.add(param.getPageSize());

        List<Drug> drugList =  jdbcTemplate.query(sql, paramList.toArray() , new DrugMapper());

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        DrugResponse response = new DrugResponse();
        response.setList(drugList);
        response.setTotalCount(totalCount.get(0));
        response.setAdmin(authentication.getAuthorities().stream()
                .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ADMIN")));
        return response;
    }
}
