package com.sangzunpark.datascience.dto.mapper;

import com.sangzunpark.datascience.dto.CodeValue;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class CodeValueMapper implements RowMapper<CodeValue> {
    @Override
    public CodeValue mapRow(ResultSet rs, int rowNum) throws SQLException {
        CodeValue codeValue = new CodeValue();
        codeValue.setCode(rs.getString("CODE"));
        codeValue.setName(rs.getString("NAME"));
        return codeValue;
    }
}
