<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="utf-8">
<head>
    <meta charset="UTF-8">
    <title>Sign Up</title>
    <!-- 부트스트랩 CDN 추가 -->
    <link rel="stylesheet" href="/common/css/bootstrap.min.4.3.1.css">
    <!-- 부트스트랩 JS 추가 -->
    <script src="/common/js/jquery-3.3.1.slim.min.js"></script>
    <script src="/common/js/popper.min.js"></script>
    <script src="/common/js/bootstrap.min.js"></script>
    <script>
        function check(){
            let password1 = document.getElementById("password");
            let password2 = document.getElementById("confirm-password");
            if(password1.value != password2.value){
                alert("The passwords for verification do not match.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    Sign Up
                </div>
                <div class="card-body">
                    <form name="signupForm" method="post" action="/signupProc" onsubmit="return check();">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required="Please fill out this field">
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required="Please fill out this field">
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required="Please fill out this field">
                        </div>
                        <div class="form-group">
                            <label for="confirm-password">Confirm Password</label>
                            <input type="password" class="form-control" id="confirm-password" name="confirm-password" required="Please fill out this field">
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary btn-block">Sign Up</button>
                        </div>
                    </form>
                </div>
                <div class="card-footer">
                    <div class="text-center">
                        Already have an account? <a href="/login">Login</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>