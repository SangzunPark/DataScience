<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        option.empty{
            color:red;
        }
    </style>
    <!-- 부트스트랩 JS 파일 -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container">
    <div class="row" style="height:20px;">
    </div>
    <div class="row">
        <div class="col-md-2">
            <select class="form-control">
                <option value="">Year</option>
                <option value="2001">2001</option>
                <option value="2002">2002</option>
            </select>
        </div>
        <div class="col-md-2">
            <select class="form-control">
                <option value="">Brand</option>
                <option value="Brand1">Brand1</option>
                <option value="Brand2">Brand2</option>
            </select>
        </div>
        <div class="col-md-2">
            <select class="form-control">
                <option value="">Generic</option>
                <option value="Generic1">Generic1</option>
                <option value="Generic2">Generic2</option>
            </select>
        </div>
        <div class="input-group col-md-2" style="white-space: nowrap">
            <input type="text" class="form-control" placeholder="search text here">
            <button class="btn btn-primary" type="button" id="button-addon2"><i class="fas fa-search"></i></button>
        </div>
    </div>
    <div class="row" style="height:20px;">
    </div>
    <div class="row">
        <table class="table table-hover table-striped">
            <thead class="thead-light-blue">
            <tr>
                <th class="sortable">Year<i class="fas fa-sort-up"></i></th>
                <th class="sortable" data-sort="brand">Brand<i class="fas fa-sort-down"></i></th>
                <th class="sortable" data-sort="generic">Generic</th>
                <th class="sortable" data-sort="claim_count">Claim Count</th>
                <th class="sortable" data-sort="total_spending">Total Spending</th>
                <th class="sortable" data-sort="beneficiary_count">Beneficiary Count</th>
                <th class="sortable" data-sort="annual_spending_per_user">Total Annual Spending per User</th>
                <th class="sortable" data-sort="unit_count">Unit Count</th>
                <th class="sortable" data-sort="avg_cost_per_unit">Average Cost per Unit</th>
                <th class="sortable" data-sort="beneficiary_count_no_lis">Beneficiary Count No LIS</th>
                <th class="sortable" data-sort="beneficiary_count_lis">Beneficiary Count LIS</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
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
            <tr>
                <td>2022</td>
                <td>Brand2</td>
                <td>Generic2</td>
                <td>200</td>
                <td>$2,000</td>
                <td>100</td>
                <td>$500</td>
                <td>300</td>
                <td>$7</td>
                <td>50</td>
                <td>50</td>
                <td><button class="btn btn-sm btn-info">Modify</button></td>
            </tr>
            <tr>
                <td>2023</td>
                <td>Brand3</td>
                <td>Generic3</td>
                <td>300</td>
                <td>$3,000</td>
                <td>150</td>
                <td>$500</td>
                <td>400</td>
                <td>$9</td>
                <td>75</td>
                <td>75</td>
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
                            <label for="page-number">Page:</label>
                            <input id="page-number" class="form-control mr-sm-2" type="number" min="1" max="10" step="1" value="1">
                            <span class="total-count">of 10</span>
                            <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Go</button>
                        </form>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>
