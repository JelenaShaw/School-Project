<%-- 
    Document   : index
    Created on : 05.05.2018., 15.20.51
    Author     : jelenashaw
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>School - Log in</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="header.css"> 
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp" crossorigin="anonymous">
    </head>
    <script>
        function validation() {
            var username = document.getElementsByName("username")[0].value;//value only - text from input tag
            var password = document.getElementsByName("password")[0].value;

            var userRegex = new RegExp("[a-zA-Z]+\\.[a-zA-Z]+\\.[0-9]+");//name.surname.id <- pattern
            
            if (userRegex.test(username))//user regex, first we check username if correct then we check password
            {
                var passwordRegex = new RegExp(".*[0-9].*");//password regex, must contain a digit
                if (passwordRegex.test(password)) {

                    return true;//validation passed
                }
            }
            alert("Username should be in the following format: name.surname.id\n\
                 Password must contain at least one digit");//user to know the format of username and password
            return false;
        }
    </script>
    <body>
        <%@include file="header.jsp"%>
        <div style="float: left; width: 25%; padding-left: 35px; padding-top: 50px">
            <h2 style="margin-top: 55px">Enter your details:</h2>
            <form method="POST" action="Loginservlet" style="width: 25%">
                Username: <input type="text" name="username">        
                Password: <input type="password" name="password">
                <input style="margin-top: 10px" type="submit" name="button" class="btn btn-primary" onclick="return validation()" value="Log in">
            </form>
            <%
                if (request.getParameter("msg") != null) {//mistake log in form shows it
            %>
                <h3 style="color: red;"> Invalid Log In Details! </h3>
            <%}%> 
        </div>
        <div class="container" style="width: 100%; padding: 0">

            <div id="myCarousel" class="carousel slide" data-ride="carousel" style="float: right; width: 70%; height: 600px;">
                <ol class="carousel-indicators">
                    <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                    <li data-target="#myCarousel" data-slide-to="1"></li>
                    <li data-target="#myCarousel" data-slide-to="2"></li>
                </ol>

                <div class="carousel-inner">
                    <div class="item active">
                        <img src="img3.jpg" alt="Image 1" style="width:auto; height: 600px">
                    </div>

                    <div class="item">
                        <img src="img2.jpg" alt="Image 2" style="width:auto; height: 600px">
                    </div>

                    <div class="item">
                        <img src="img1.jpg" alt="Image 3" style="width:auto; height: 600px">
                    </div>
                </div>

                <a class="left carousel-control" href="#myCarousel" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left"></span>
                    <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control" href="#myCarousel" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right"></span>
                    <span class="sr-only">Next</span>
                </a>
            </div>
        </div>

        <%@include file="footer.jsp" %>
    </body>
</html>
