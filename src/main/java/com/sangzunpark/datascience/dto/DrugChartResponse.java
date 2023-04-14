package com.sangzunpark.datascience.dto;

import java.util.List;

public class DrugChartResponse {
    private List<DrugChartSeries> series;
    private List<String> categories;

    public List<DrugChartSeries> getSeries() {
        return series;
    }

    public void setSeries(List<DrugChartSeries> series) {
        this.series = series;
    }

    public List<String> getCategories() {
        return categories;
    }

    public void setCategories(List<String> categories) {
        this.categories = categories;
    }
}
