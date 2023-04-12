<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Drug</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        .row-height {
            height: 25px;
        }
        .sortable {
            cursor: pointer;
        }
        .sortable:hover {
            color: blue;
            text-decoration: underline;
        }
        th{
            white-space: nowrap;
        }
        i.fas{
            margin-left:5px;
        }
        input.rowEdit{
            height:30px;
            width:70px;
        }
        .secondButton{
            margin-left:5px;
        }
    </style>
    <!-- 부트스트랩 JS 파일 -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        let sortInfo = {column:null, desc:false, node:null};
        let clearSortInfo = function(){
            if(sortInfo.node!=null){
                clearSortNode(sortInfo.node);
            }
            sortInfo = {column:null, desc:false, node:null};
        }
        let clearSortNode = function(node){
            if(node==null)
                return;
            let nodeList = node.getElementsByTagName("i");
            if(nodeList!=null && nodeList.length!=0){
                node.removeChild(nodeList[0]);
            }
        }
        let setSortInfo = function(columnName, node){
            if(sortInfo.column!=columnName){
                sortInfo.desc = false;
            }else{
                sortInfo.desc = !sortInfo.desc;
            }
            clearSortNode(sortInfo.node);

            sortInfo.column = columnName;
            sortInfo.node = node;

            let sortIcon = document.createElement("i");
            if(sortInfo.desc){
                sortIcon.className = "fas fa-sort-down"
            }else{
                sortIcon.className = "fas fa-sort-up";
            }
            node.appendChild(sortIcon);
        }
        let clearPageNum = function(){
            document.getElementById("pageNum").value = "1";
        }
        let getPageSize = function(){
            return 5;
        }
        window.onload = function(){
            loadCode("Brand", "Brand", document.getElementById("BrandCombo"));
            loadCode("Generic", "Generic", document.getElementById("GenericCombo"));
            loadCode("Year", "Year", document.getElementById("YearCombo"));

            search();

            document.getElementById("searchButton").addEventListener("click",function (e) {
                clearPageNum();
                clearSortInfo();
                search();
            });

            document.getElementById("pageGoButton").addEventListener("click",function (e) {
                search();
            });

            //SORT
            document.getElementById("sortYear").addEventListener("click",function (e) {
                clearPageNum();
                setSortInfo("Year",document.getElementById("sortYear"));
                search();
            });
            document.getElementById("sortBrand").addEventListener("click",function (e) {
                clearPageNum();
                setSortInfo("Brand",document.getElementById("sortBrand"));
                search();
            });
            document.getElementById("sortGeneric").addEventListener("click",function (e) {
                clearPageNum();
                setSortInfo("Generic",document.getElementById("sortGeneric"));
                search();
            });
            // document.getElementById("sort1").addEventListener("click",function (e) {
            //     clearPageNum();
            //     search();
            // });
            // document.getElementById("sort2").addEventListener("click",function (e) {
            //     clearPageNum();
            //     search();
            // });
            // document.getElementById("sort3").addEventListener("click",function (e) {
            //     clearPageNum();
            //     search();
            // });
            // document.getElementById("sort4").addEventListener("click",function (e) {
            //     clearPageNum();
            //     search();
            // });
            // document.getElementById("sort5").addEventListener("click",function (e) {
            //     clearPageNum();
            //     search();
            // });
            // document.getElementById("sort6").addEventListener("click",function (e) {
            //     clearPageNum();
            //     search();
            // });
            // document.getElementById("sort7").addEventListener("click",function (e) {
            //     clearPageNum();
            //     search();
            // });
            // document.getElementById("sort8").addEventListener("click",function (e) {
            //     clearPageNum();
            //     search();
            // });
        }
        let printRowValue = function(obj, drugItem, admin){
            obj.yearTd.setAttribute("code",drugItem.yearCode);
            obj.yearTd.innerHTML = drugItem.yearName;
            obj.brandTd.setAttribute("code", drugItem.brandCode);
            obj.brandTd.innerHTML = drugItem.brandName;
            obj.genericTd.setAttribute("code", drugItem.genericCode);
            obj.genericTd.innerHTML = drugItem.genericName;

            obj.td1.innerHTML = drugItem.claimCount;
            obj.td2.innerHTML = drugItem.totalSpending;
            obj.td3.innerHTML = drugItem.beneficiaryCount;
            obj.td4.innerHTML = drugItem.totalAnnualSpendingPerUser;
            obj.td5.innerHTML = drugItem.unitCount;
            obj.td6.innerHTML = drugItem.averageCostPerUnit;
            obj.td7.innerHTML = drugItem.beneficiaryCountNoLIS;
            obj.td8.innerHTML = drugItem.beneficiaryCountLIS;
            obj.tdButtun.innerHTML = "";
            if(admin) {
                let button1 = document.createElement("button");
                button1.className = "btn btn-sm btn-info";
                button1.innerText = "Modify";
                button1.addEventListener("click", function () {
                    printRowEdit(obj, drugItem, admin);
                });
                obj.tdButtun.appendChild(button1);

                let button2 = document.createElement("button");
                button2.className = "btn btn-sm btn-info secondButton";
                button2.innerText = "Delete";
                button2.addEventListener("click", function () {

                });
                obj.tdButtun.appendChild(button2);
            }
        }
        let printRowEdit = function(obj, drugItem, admin){
            obj.td1.innerHTML = "";
            obj.td2.innerHTML = "";
            obj.td3.innerHTML = "";
            obj.td4.innerHTML = "";
            obj.td5.innerHTML = "";
            obj.td6.innerHTML = "";
            obj.td7.innerHTML = "";
            obj.td8.innerHTML = "";
            obj.tdButtun.innerHTML = "";

            let valueObj1 = document.createElement("input");
            let valueObj2 = document.createElement("input");
            let valueObj3 = document.createElement("input");
            let valueObj4 = document.createElement("input");
            let valueObj5 = document.createElement("input");
            let valueObj6 = document.createElement("input");
            let valueObj7 = document.createElement("input");
            let valueObj8 = document.createElement("input");
            valueObj1.className = "form-control rowEdit";
            valueObj2.className = "form-control rowEdit";
            valueObj3.className = "form-control rowEdit";
            valueObj4.className = "form-control rowEdit";
            valueObj5.className = "form-control rowEdit";
            valueObj6.className = "form-control rowEdit";
            valueObj7.className = "form-control rowEdit";
            valueObj8.className = "form-control rowEdit";

            valueObj1.type = "number";
            valueObj2.type = "number";
            valueObj3.type = "number";
            valueObj4.type = "number";
            valueObj5.type = "number";
            valueObj6.type = "number";
            valueObj7.type = "number";
            valueObj8.type = "number";

            valueObj1.value = drugItem.claimCount;
            valueObj2.value = drugItem.totalSpending;
            valueObj3.value = drugItem.beneficiaryCount;
            valueObj4.value = drugItem.totalAnnualSpendingPerUser;
            valueObj5.value = drugItem.unitCount;
            valueObj6.value = drugItem.averageCostPerUnit;
            valueObj7.value = drugItem.beneficiaryCountNoLIS;
            valueObj8.value = drugItem.beneficiaryCountLIS;

            obj.td1.appendChild(valueObj1);
            obj.td2.appendChild(valueObj2);
            obj.td3.appendChild(valueObj3);
            obj.td4.appendChild(valueObj4);
            obj.td5.appendChild(valueObj5);
            obj.td6.appendChild(valueObj6);
            obj.td7.appendChild(valueObj7);
            obj.td8.appendChild(valueObj8);

            let button1 = document.createElement("button");
            button1.className = "btn btn-sm btn-info";
            button1.innerText = "Save";
            button1.addEventListener("click",function () {
                let saveParam = {};
                saveParam.yearCode = drugItem.yearCode;
                saveParam.yearName = null;
                saveParam.brandCode = drugItem.brandCode;
                saveParam.brandName = null;
                saveParam.genericCode = drugItem.genericCode;
                saveParam.genericName = null;
                saveParam.claimCount = valueObj1.value;
                saveParam.totalSpending = valueObj2.value;
                saveParam.beneficiaryCount = valueObj3.value;
                saveParam.totalAnnualSpendingPerUser = valueObj4.value;
                saveParam.unitCount = valueObj5.value;
                saveParam.averageCostPerUnit = valueObj6.value;
                saveParam.beneficiaryCountNoLIS = valueObj7.value;
                saveParam.beneficiaryCountLIS = valueObj8.value;
                modify(saveParam);
            });
            obj.tdButtun.appendChild(button1);

            let button2 = document.createElement("button");
            button2.className = "btn btn-sm btn-info secondButton";
            button2.innerText = "Cancel";
            button2.addEventListener("click",function () {
                printRowValue(obj, drugItem, admin);
            });
            obj.tdButtun.appendChild(button2);

        }
        let modify = function(saveParam){
            $.ajax({
                async: false,
                type: "POST",
                url: "/drug/drugModify",
                data: JSON.stringify(saveParam),
                dataType: 'json',
                contentType: "application/json",
                success: function (data) {
                    if(data.success==false){
                        alert(data.errorMessage);
                        return;
                    }
                    clearPageNum();
                    clearSortInfo();
                    search();
                },
                error: function (xhr, status, e) {
                    let httpStatusCode = xhr.status;
                    alert("error : "+httpStatusCode);

                }
            });
        }
        let search = function() {
            let paramObj = {
                year : null,
                brand : null,
                generic : null,
                searchText : "",
                pageNum : Number(document.getElementById("pageNum").value)-1,
                pageSize : getPageSize(),
                orderByColumn : sortInfo.column,
                orderByType : sortInfo.column==null?null:(sortInfo.desc?"Desc":"Asc"),
            };
            if(document.getElementById("YearCombo").value!=""){
                paramObj.year = document.getElementById("YearCombo").value;
            }
            if(document.getElementById("BrandCombo").value!=""){
                paramObj.brand = document.getElementById("BrandCombo").value;
            }
            if(document.getElementById("GenericCombo").value!=""){
                paramObj.generic = document.getElementById("GenericCombo").value;
            }
            paramObj.searchText = document.getElementById("searchText").value;

            let tableBody = document.getElementById("drugListTableBody");
            tableBody.innerHTML = "";
            $.ajax({
                async: false,
                type: "POST",
                url: "/drug/drugList",
                data: JSON.stringify(paramObj),
                dataType: 'json',
                contentType: "application/json",
                success: function (data) {
                    if(data.result!=null){
                        let admin = data.result.admin;
                        let totalPage = Math.ceil(data.result.totalCount / getPageSize());
                        document.getElementById("pageNum").setAttribute("max",totalPage);
                        document.getElementById("pageNumInfo").innerText = "of "+totalPage;

                        for(let i=0; i<data.result.list.length; i++){
                            let drugItem = data.result.list[i];
                            console.log(drugItem);
                            let tr = document.createElement("tr");

                            let yearTd = document.createElement("td");
                            let brandTd = document.createElement("td");
                            let genericTd = document.createElement("td");
                            let td1 = document.createElement("td");
                            let td2 = document.createElement("td");
                            let td3 = document.createElement("td");
                            let td4 = document.createElement("td");
                            let td5 = document.createElement("td");
                            let td6 = document.createElement("td");
                            let td7 = document.createElement("td");
                            let td8 = document.createElement("td");
                            let tdButtun = document.createElement("td");
                            let tdObj = {yearTd:yearTd, brandTd:brandTd, genericTd:genericTd, tdButtun:tdButtun
                                ,td1:td1,td2:td2,td3:td3,td4:td4,td5:td5,td6:td6,td7:td7,td8:td8};

                            tr.appendChild(yearTd);
                            tr.appendChild(brandTd);
                            tr.appendChild(genericTd);
                            tr.appendChild(td1);
                            tr.appendChild(td2);
                            tr.appendChild(td3);
                            tr.appendChild(td4);
                            tr.appendChild(td5);
                            tr.appendChild(td6);
                            tr.appendChild(td7);
                            tr.appendChild(td8);
                            tr.appendChild(tdButtun);

                            printRowValue(tdObj, drugItem, admin);

                            tableBody.appendChild(tr);
                        }
                    }
                },
                error: function (xhr, status, e) {
                    let httpStatusCode = xhr.status;
                    alert("error : "+httpStatusCode);

                }
            });
        }

        let loadCode = function(flag, defaultTitle, comboBoxElement){

            comboBoxElement.innerHTML = "";

            let paramObj = {"flag":flag};

            $.ajax({
                async: false,
                type: "POST",
                url: "/drug/commonCodeList",
                data: JSON.stringify(paramObj),
                dataType: 'json',
                contentType: "application/json",
                success: function (data) {
                    if(data.result!=null){
                        let option = document.createElement("option");
                        option.value ="";
                        option.text = defaultTitle;
                        comboBoxElement.appendChild(option);

                        for(let i=0; i<data.result.length; i++){
                            let codeItem = data.result[i];
                            let option = document.createElement("option");
                            option.value = codeItem.code;
                            option.text = codeItem.name;
                            comboBoxElement.appendChild(option);
                        }
                    }
                },
                error: function (xhr, status, e) {
                    let httpStatusCode = xhr.status;
                    alert("error : "+httpStatusCode);

                }
            });
        }
    </script>
</head>
<body>
<div class="container-fluid">
    <!-- 로그아웃 버튼 -->
    <div class="row" style="height:20px;">
    </div>
    <div class="row justify-content-between">
        <div class="col-md-2">
            <select id="YearCombo" class="form-control">
                <option value="">Year</option>
            </select>
        </div>
        <div class="col-md-2">
            <select id="BrandCombo" class="form-control">
                <option value="">Brand</option>
            </select>
        </div>
        <div class="col-md-2">
            <select id="GenericCombo" class="form-control">
                <option value="">Generic</option>
            </select>
        </div>
        <div class="col-md-4">
            <div class="input-group" style="white-space: nowrap">
                <input id="searchText" type="text" class="form-control" placeholder="search text here">
                <button id="searchButton" class="btn btn-primary" type="button"><i class="fas fa-search"></i></button>
            </div>
        </div>

        <div class="col-md-1  text-right">
            <a href="/logout" class="btn btn-danger btn-block">Logout</a>
        </div>
    </div>
    <div class="row" style="height:20px;">
    </div>
    <div class="row">
        <table class="table table-hover table-striped">
            <thead class="thead-light-blue">
            <tr>
                <th id="sortYear" class="sortable">Year
                    <!--<i class="fas fa-sort-up"></i>-->
                </th>
                <th id="sortBrand" class="sortable" data-sort="brand">Brand
                    <!--<i class="fas fa-sort-down"></i>-->
                </th>
                <th id="sortGeneric" class="sortable" data-sort="generic">Generic</th>
                <th id="sort1" class="sortable" data-sort="claim_count">Claim Count</th>
                <th id="sort2" class="sortable" data-sort="total_spending">Total Spending</th>
                <th id="sort3" class="sortable" data-sort="beneficiary_count">Beneficiary Count</th>
                <th id="sort4" class="sortable" data-sort="annual_spending_per_user">Total Annual Spending per User</th>
                <th id="sort5" class="sortable" data-sort="unit_count">Unit Count</th>
                <th id="sort6" class="sortable" data-sort="avg_cost_per_unit">Average Cost per Unit</th>
                <th id="sort7" class="sortable" data-sort="beneficiary_count_no_lis">Beneficiary Count No LIS</th>
                <th id="sort8" class="sortable" data-sort="beneficiary_count_lis">Beneficiary Count LIS</th>
                <th style="${IsAdmin ? 'width:160px' : 'width:0px'}"></th>
            </tr>
            </thead>
            <tbody id="drugListTableBody">
            <tr>
                <td>2021</td>
                <td>Brand1</td>
                <td>Generic1</td>
                <td>100</td>
                <td>$1,000</td>
                <td>50</td>
                <td>$500</td>
                <td>200</td>
                <td>$5</td>
                <td>25</td>
                <td>25</td>
                <td><button class="btn btn-sm btn-info">Modify</button></td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="row">
        <div class="col-md-12">
            <nav aria-label="Page navigation example">
                <ul class="pagination">
                    <!--
                    <li class="page-item"><a class="page-link" href="#">Previous</a></li>
                    <li class="page-item"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item"><a class="page-link" href="#">4</a></li>
                    <li class="page-item"><a class="page-link" href="#">5</a></li>
                    <li class="page-item"><a class="page-link" href="#">Next</a></li>
                    -->
                    <li class="page-item">
                        <form class="form-inline">
                            <label for="pageNum">Page:</label>
                            <input id="pageNum" class="form-control mr-sm-2" type="number" min="1" max="10" step="1" value="1">
                            <span id="pageNumInfo" class="total-count">of 10</span>
                            <button id="pageGoButton" class="btn btn-primary" type="button">Go</button>
                        </form>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>
