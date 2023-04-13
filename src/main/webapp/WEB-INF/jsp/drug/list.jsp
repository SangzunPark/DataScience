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
        .rowEdit{
            height:30px;
            width:70px;
        }
        .secondButton{
            margin-left:5px;
        }
        a.whiteFont {
            color: #fff;
            text-decoration: none;
        }
    </style>
    <!-- 부트스트랩 JS 파일 -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        let commonCode = {Brand:[], Generic:[], Year:[]};
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
            return document.getElementById("PageSize").value;
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
            document.getElementById("newBtn").addEventListener("click",function (e) {
                printRowNew();
            })
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
                    if (confirm("Are you sure you want to delete?")) {
                        let saveParam = {};
                        saveParam.yearCode = drugItem.yearCode;
                        saveParam.brandCode = drugItem.brandCode;
                        saveParam.genericCode = drugItem.genericCode;
                        doSave("/drug/admin/deleteDrug",saveParam, null);
                    }
                });
                obj.tdButtun.appendChild(button2);
            }
        }

        let getRowEditInputBox = function(isNew){
            let yearCode = document.createElement("select");
            let yearName = document.createElement("input");
            let brandCode = document.createElement("select");
            let brandName = document.createElement("input");
            let genericCode = document.createElement("select");
            let genericName = document.createElement("input");
            let valueObj1 = document.createElement("input");
            let valueObj2 = document.createElement("input");
            let valueObj3 = document.createElement("input");
            let valueObj4 = document.createElement("input");
            let valueObj5 = document.createElement("input");
            let valueObj6 = document.createElement("input");
            let valueObj7 = document.createElement("input");
            let valueObj8 = document.createElement("input");

            yearCode.className = "form-control rowEdit";
            yearName.className = "form-control rowEdit";
            brandCode.className = "form-control rowEdit";
            brandName.className = "form-control rowEdit";
            genericCode.className = "form-control rowEdit";
            genericName.className = "form-control rowEdit";
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

            let returnOBj = {
                "yearName" : yearName,
                "yearCode" : yearCode,
                "brandCode" : brandCode,
                "brandName" : brandName,
                "genericCode" : genericCode,
                "genericName" : genericName,
                "valueObj1" : valueObj1,
                "valueObj2" : valueObj2,
                "valueObj3" : valueObj3,
                "valueObj4" : valueObj4,
                "valueObj5" : valueObj5,
                "valueObj6" : valueObj6,
                "valueObj7" : valueObj7,
                "valueObj8" : valueObj8
            }
            return returnOBj;
        }
        let printRowNew = function(){
            let tdObj = appendTableTr();
            let valueInputBox =  getRowEditInputBox(true);

            let valueObj1 = valueInputBox.valueObj1;
            let valueObj2 = valueInputBox.valueObj2;
            let valueObj3 = valueInputBox.valueObj3;
            let valueObj4 = valueInputBox.valueObj4;
            let valueObj5 = valueInputBox.valueObj5;
            let valueObj6 = valueInputBox.valueObj6;
            let valueObj7 = valueInputBox.valueObj7;
            let valueObj8 = valueInputBox.valueObj8;
            let yearCode = valueInputBox.yearCode;
            let yearName = valueInputBox.yearName;
            let brandCode = valueInputBox.brandCode;
            let brandName = valueInputBox.brandName;
            let genericCode = valueInputBox.genericCode;
            let genericName = valueInputBox.genericName;

            for(let i=0; i<commonCode['Year'].length; i++){
                let codeItem = commonCode['Year'][i];
                let option = document.createElement("option");
                option.value = codeItem.code;
                option.text = codeItem.name;
                yearCode.appendChild(option);
            }

            for(let i=0; i<commonCode['Brand'].length; i++){
                let codeItem = commonCode['Brand'][i];
                let option = document.createElement("option");
                option.value = codeItem.code;
                option.text = codeItem.name;
                brandCode.appendChild(option);
            }

            for(let i=0; i<commonCode['Generic'].length; i++){
                let codeItem = commonCode['Generic'][i];
                let option = document.createElement("option");
                option.value = codeItem.code;
                option.text = codeItem.name;
                genericCode.appendChild(option);
            }

            let yearComboContainer = document.createElement("div");
            let yearPlusButton = document.createElement("button");
            yearPlusButton.className = "btn btn-sm btn-info";
            yearPlusButton.innerText = "+";
            yearCode.style.float = "left";
            yearComboContainer.style.width = "100px";

            let yearTextContainer = document.createElement("div");
            let yearCancelButton = document.createElement("button");
            yearCancelButton.className = "btn btn-sm btn-info";
            yearCancelButton.innerText = "X";
            yearName.style.float = "left";
            yearTextContainer.style.width = "100px";
            yearTextContainer.style.display = "none";

            yearPlusButton.addEventListener("click",function () {
                yearTextContainer.style.display = "";
                yearComboContainer.style.display = "none";
            });
            yearCancelButton.addEventListener("click",function () {
                yearTextContainer.style.display = "none";
                yearComboContainer.style.display = "";
            });

            yearComboContainer.appendChild(yearCode);
            yearComboContainer.appendChild(yearPlusButton);
            yearTextContainer.appendChild(yearName);
            yearTextContainer.appendChild(yearCancelButton);


            let brandComboContainer = document.createElement("div");
            let brandPlusButton = document.createElement("button");
            brandPlusButton.className = "btn btn-sm btn-info";
            brandPlusButton.innerText = "+";
            brandCode.style.float = "left";
            brandComboContainer.style.width = "100px";

            let brandTextContainer = document.createElement("div");
            let brandCancelButton = document.createElement("button");
            brandCancelButton.className = "btn btn-sm btn-info";
            brandCancelButton.innerText = "X";
            brandName.style.float = "left";
            brandTextContainer.style.width = "100px";
            brandTextContainer.style.display = "none";

            brandPlusButton.addEventListener("click",function () {
                brandTextContainer.style.display = "";
                brandComboContainer.style.display = "none";
            });
            brandCancelButton.addEventListener("click",function () {
                brandTextContainer.style.display = "none";
                brandComboContainer.style.display = "";
            });

            brandComboContainer.appendChild(brandCode);
            brandComboContainer.appendChild(brandPlusButton);
            brandTextContainer.appendChild(brandName);
            brandTextContainer.appendChild(brandCancelButton);

            let genericComboContainer = document.createElement("div");
            let genericPlusButton = document.createElement("button");
            genericPlusButton.className = "btn btn-sm btn-info";
            genericPlusButton.innerText = "+";
            genericCode.style.float = "left";
            genericComboContainer.style.width = "100px";

            let genericTextContainer = document.createElement("div");
            let genericCancelButton = document.createElement("button");
            genericCancelButton.className = "btn btn-sm btn-info";
            genericCancelButton.innerText = "X";
            genericName.style.float = "left";
            genericTextContainer.style.width = "100px";
            genericTextContainer.style.display = "none";

            genericPlusButton.addEventListener("click",function () {
                genericTextContainer.style.display = "";
                genericComboContainer.style.display = "none";
            });
            genericCancelButton.addEventListener("click",function () {
                genericTextContainer.style.display = "none";
                genericComboContainer.style.display = "";
            });

            genericComboContainer.appendChild(genericCode);
            genericComboContainer.appendChild(genericPlusButton);
            genericTextContainer.appendChild(genericName);
            genericTextContainer.appendChild(genericCancelButton);


            tdObj.yearTd.appendChild(yearComboContainer);
            tdObj.yearTd.appendChild(yearTextContainer);
            tdObj.brandTd.appendChild(brandComboContainer);
            tdObj.brandTd.appendChild(brandTextContainer);
            tdObj.genericTd.appendChild(genericComboContainer);
            tdObj.genericTd.appendChild(genericTextContainer);
            tdObj.td1.appendChild(valueObj1);
            tdObj.td2.appendChild(valueObj2);
            tdObj.td3.appendChild(valueObj3);
            tdObj.td4.appendChild(valueObj4);
            tdObj.td5.appendChild(valueObj5);
            tdObj.td6.appendChild(valueObj6);
            tdObj.td7.appendChild(valueObj7);
            tdObj.td8.appendChild(valueObj8);

            let button1 = document.createElement("button");
            button1.className = "btn btn-sm btn-info";
            button1.innerText = "Save";
            button1.addEventListener("click",function () {
                let saveParam = {};
                if(yearTextContainer.style.display=="none"){
                    saveParam.yearCode = yearCode.value;
                    saveParam.yearName = null;
                }else{
                    saveParam.yearCode = null;
                    saveParam.yearName = yearName.value;
                    if(yearName.value==""){
                        alert("The year name is blank.");
                        return;
                    }
                }
                if(brandTextContainer.style.display=="none"){
                    saveParam.brandCode = brandCode.value;
                    saveParam.brandName = null;
                }else{
                    saveParam.brandCode = null;
                    saveParam.brandName = brandName.value;
                    if(brandName.value==""){
                        alert("The brand name is blank.");
                        return;
                    }
                }
                if(genericTextContainer.style.display=="none"){
                    saveParam.genericCode = genericCode.value;
                    saveParam.genericName = null;
                }else{
                    saveParam.genericCode = null;
                    saveParam.genericName = genericName.value;
                    if(genericName.value==""){
                        alert("The generic name is blank.");
                        return;
                    }
                }
                saveParam.claimCount = valueObj1.value;
                saveParam.totalSpending = valueObj2.value;
                saveParam.beneficiaryCount = valueObj3.value;
                saveParam.totalAnnualSpendingPerUser = valueObj4.value;
                saveParam.unitCount = valueObj5.value;
                saveParam.averageCostPerUnit = valueObj6.value;
                saveParam.beneficiaryCountNoLIS = valueObj7.value;
                saveParam.beneficiaryCountLIS = valueObj8.value;
                doSave("/drug/admin/saveDrug", saveParam, function () {
                    //새로운 코드가 들어가있을수 있기때문에 코드를 다시 갱신한다.
                    loadCode("Brand", "Brand", document.getElementById("BrandCombo"));
                    loadCode("Generic", "Generic", document.getElementById("GenericCombo"));
                    loadCode("Year", "Year", document.getElementById("YearCombo"));
                });
            });
            tdObj.tdButtun.appendChild(button1);

            let button2 = document.createElement("button");
            button2.className = "btn btn-sm btn-info secondButton";
            button2.innerText = "Cancel";
            button2.addEventListener("click",function () {
                tdObj.tr.innerHTML = "";
                tdObj.tr.parentElement.removeChild(tdObj.tr);
            });
            tdObj.tdButtun.appendChild(button2);
        }

        let printRowEdit = function(tdObj, drugItem, admin){
            tdObj.td1.innerHTML = "";
            tdObj.td2.innerHTML = "";
            tdObj.td3.innerHTML = "";
            tdObj.td4.innerHTML = "";
            tdObj.td5.innerHTML = "";
            tdObj.td6.innerHTML = "";
            tdObj.td7.innerHTML = "";
            tdObj.td8.innerHTML = "";
            tdObj.tdButtun.innerHTML = "";

            let valueInputBox =  getRowEditInputBox(false);
            let valueObj1 = valueInputBox.valueObj1;
            let valueObj2 = valueInputBox.valueObj2;
            let valueObj3 = valueInputBox.valueObj3;
            let valueObj4 = valueInputBox.valueObj4;
            let valueObj5 = valueInputBox.valueObj5;
            let valueObj6 = valueInputBox.valueObj6;
            let valueObj7 = valueInputBox.valueObj7;
            let valueObj8 = valueInputBox.valueObj8;

            valueObj1.value = drugItem.claimCount;
            valueObj2.value = drugItem.totalSpending;
            valueObj3.value = drugItem.beneficiaryCount;
            valueObj4.value = drugItem.totalAnnualSpendingPerUser;
            valueObj5.value = drugItem.unitCount;
            valueObj6.value = drugItem.averageCostPerUnit;
            valueObj7.value = drugItem.beneficiaryCountNoLIS;
            valueObj8.value = drugItem.beneficiaryCountLIS;

            tdObj.td1.appendChild(valueObj1);
            tdObj.td2.appendChild(valueObj2);
            tdObj.td3.appendChild(valueObj3);
            tdObj.td4.appendChild(valueObj4);
            tdObj.td5.appendChild(valueObj5);
            tdObj.td6.appendChild(valueObj6);
            tdObj.td7.appendChild(valueObj7);
            tdObj.td8.appendChild(valueObj8);

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
                doSave("/drug/admin/modifyDrug",saveParam, null);
            });
            tdObj.tdButtun.appendChild(button1);

            let button2 = document.createElement("button");
            button2.className = "btn btn-sm btn-info secondButton";
            button2.innerText = "Cancel";
            button2.addEventListener("click",function () {
                printRowValue(tdObj, drugItem, admin);
            });
            tdObj.tdButtun.appendChild(button2);
        }

        let doSave = function(url, saveParam, callback){
            $.ajax({
                async: false,
                type: "POST",
                url: url, // /drug/admin/drugModify, /drug/admin/drugSave
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
                    if(callback!=null){
                        callback();
                    }
                },
                error: function (xhr, status, e) {
                    let httpStatusCode = xhr.status;
                    console.log(hhr, status, e);
                    alert("error : "+httpStatusCode);

                }
            });
        }
        let appendTableTr = function(){
            let tableBody = document.getElementById("drugListTableBody");

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
            let tdObj = {tr:tr, yearTd:yearTd, brandTd:brandTd, genericTd:genericTd, tdButtun:tdButtun
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

            tableBody.appendChild(tr);

            return tdObj;
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
                            let tdObj = appendTableTr();
                            printRowValue(tdObj, drugItem, admin);
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
                        commonCode[flag] = data.result;
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
    <div class="row" style="height:20px;">
    </div>
    <!-- 로그아웃 버튼 -->
    <div class="row">
        <div class="text-right">
            <button class="btn btn-danger"><a class="whiteFont" href="/logout">Logout</a></button>
        </div>
    </div>
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
                <th style="${IsAdmin ? 'width:140px' : 'width:0px'}"></th>
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
        <div class="text-right">
            <button id="newBtn" style="margin-right: 10px;" class="btn btn-primary">Add New</button>
        </div>
    </div>
    <div class="row">
        <div class="col-md-3">
            <select id="PageSize" class="form-control" style="float:left; width:100px;">
                <option value="5">5 Size</option>
                <option value="10">10 Size</option>
                <option value="50">50 Size</option>
                <option value="100">100 Size</option>
                <option value="200">200 Size</option>
            </select>
        </div>
        <div class="col-md-12">
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
                <li class="page-item" style="">
                    <form class="form-inline">
                        <label for="pageNum">Page:</label>
                        <input id="pageNum" class="form-control mr-sm-2" type="number" min="1" max="10" step="1" value="1">
                        <span id="pageNumInfo" class="total-count">of 10</span>
                        <button id="pageGoButton" class="btn btn-primary" type="button">Go</button>
                    </form>
                </li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>
