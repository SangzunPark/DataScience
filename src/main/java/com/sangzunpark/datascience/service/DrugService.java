package com.sangzunpark.datascience.service;

import com.sangzunpark.datascience.dto.CodeValue;
import com.sangzunpark.datascience.dto.Drug;
import com.sangzunpark.datascience.dto.DrugParam;
import com.sangzunpark.datascience.dto.DrugResponse;
import com.sangzunpark.datascience.dto.mapper.CodeValueMapper;
import com.sangzunpark.datascience.dto.mapper.DrugMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Component
public class DrugService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

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

        DrugResponse response = new DrugResponse();
        response.setList(drugList);
        response.setTotalCount(totalCount.get(0));
        return response;
    }
}
