<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="utf-8">
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
    <!-- 부트스트랩 CDN 추가 -->
    <link rel="stylesheet" href="/common/css/bootstrap.min.4.3.1.css">
    <style>
        .bg-image {
            background-image: url('/common/image/MediView.png');
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
            height: 100vh;
        }
    </style>
    <!-- 부트스트랩 JS 추가 -->
    <script src="/common/js/jquery-3.3.1.slim.min.js"></script>
    <script src="/common/js/popper.min.js"></script>
    <script src="/common/js/bootstrap.min.js"></script>
    <script>
    </script>
</head>
<body class="bg-image">
<div class="container mt-5">
    <div class="row justify-content-center align-items-center" style="height:100vh">
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    Login
                </div>
                <div class="card-body">
                    <form id="loginForm" name="loginForm" method="post" action="/loginProc">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required="Please fill out this field">
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required="Please fill out this field">
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary btn-block">Login</button>
                        </div>
                    </form>
                </div>
                <div class="card-footer">
                    <div class="text-center">
                        Don't have an account? <a href="/signup">Sign up</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>