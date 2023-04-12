package com.sangzunpark.datascience.dto;

import java.util.List;

public class DrugResponse {
    private List<Drug> list;
    private int totalCount;
    private boolean admin;

    public List<Drug> getList() {
        return list;
    }

    public void setList(List<Drug> list) {
        this.list = list;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public boolean isAdmin() {
        return admin;
    }

    public void setAdmin(boolean admin) {
        this.admin = admin;
    }
}
