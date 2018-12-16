<%-- 
    Document   : teacher
    Created on : 05.05.2018., 16.00.54
    Author     : jelenashaw
--%>

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>School - Teacher</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
        <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
        <link rel="stylesheet" href="header.css"> 
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp" crossorigin="anonymous">

<!--        <script>
            function changeEmail() {
                var Email = document.getElementsByName("e-mail")[0];
                if (Email.value.split("@")[0].length > 3 && Email.value.split("@")[1] === "bis.edu.rs") {//explanation left/right handside
                    $.post(
                            "Changemailservlet", //servlet
                            {
                                "e-mail": Email.value//parametar (dictionary)
                            },
                            function (text)
                            {
                                alert(text);
                            } //execute above when you get response
                    );
                }
            }
        </script>-->
    </head>
    <body style="padding-top: 55px">
        <%@include file="header.jsp"%>
        <%
            if (session.getAttribute("role").equals(0)) {

                String e_mail = "";

                Class.forName("com.mysql.jdbc.Driver").newInstance();//finding driver by its name

                Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
                PreparedStatement s = conn.prepareStatement("SELECT * FROM Teacher WHERE teacher_id = ?");//connection to DB
                s.setInt(1, Integer.parseInt(session.getAttribute("id").toString()));

                ResultSet rs = s.executeQuery();
                while (rs.next()) {
                    e_mail = rs.getString("teacher_email");
                }
        %>
        <div style="float: right; text-align: center; margin-right: 45px; margin-top: 25px">
            <b> Your e-mail address:</b><br> <input style="width: 200px; margin: 10px 0; text-align: center" disabled="" type="email" name="e-mail" value="<%=e_mail%>">
            <br> 
            <!--<button style="width:200px;" class="btn btn-primary" onclick="changeEmail()"> Change </button >-->
        </div>
        <div style="padding-left: 30px" class="sidebar-nav">
            <div class="well" style="width:300px; padding: 8px 0;">
                <ul class="nav nav-list"> 
                    <li class="nav-header" style="margin-left: 5px">Students</li>
                        <%
                            ArrayList<String> years = new ArrayList<>();
                            s = conn.prepareStatement("SELECT * FROM Teacher join Teacher_Class"
                                    + " on Teacher.teacher_id = Teacher_Class.teacher_id join Class on "
                                    + "Teacher_Class.class_id = Class.class_id WHERE Teacher.teacher_id = ?");
                                    s.setInt(1, Integer.parseInt(session.getAttribute("id").toString()));
                            
                            ResultSet rs2 = s.executeQuery();

                            while (rs2.next()) {
                                if (rs2.getString("Class.class_name").contains("year")) {
                                    if (!years.contains(rs2.getString("Class.class_name"))) {
                                        years.add(rs2.getString("Class.class_name"));

                        %>
                    
                    
                           <li><a href="teacher_students.jsp?type=Class&id=<%=rs2.getInt("Class.class_id")%>"><%=(rs2.getString("Class.class_name")).toUpperCase()%></a></li>
                        <%
                        }
                        }
                        }
                        
                          ArrayList<String> groups = new ArrayList<>();
                           s = conn.prepareStatement("SELECT * FROM Teacher join Teacher_Groups"
                            + " on Teacher.teacher_id = Teacher_Groups.teacher_id join Groups on"
                            + " Teacher_Groups.group_id = Groups.group_id WHERE Teacher.teacher_id = ?" );
                            s.setInt(1, Integer.parseInt(session.getAttribute("id").toString()));
                            
                          ResultSet rs3 = s.executeQuery();
                                
                                while (rs3.next()) {
                        %>

                           <li><a href="teacher_students.jsp?type=Group&id=<%=rs3.getInt("Groups.group_id")%>"><%=rs3.getString("Groups.name")%></a></li>
                        <%
                            }
                        %>
                        
                </ul>
            </div>
        </div>
        <%
        } else {
        %> 
        <h2> 404 Page Not Found </h2>
        <%  }
        %>
        <%@include file="footer.jsp" %>
    </body>
</html>
