<%-- 
    Document   : teacher_students
    Created on : 03.06.2018., 13.01.33
    Author     : jelenashaw
--%>

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>School - Teacher (Students)</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
        <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
        <link rel="stylesheet" href="header.css"> 
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp" crossorigin="anonymous">

        <script>
            function Studentdetails(id) {
                $.post(
                    "Studentdetailsservlet",
                    {
                        "id": id

                    },
                    function (text) 
                    {
                        document.getElementById("Details").innerHTML = text;
                    }
                );
            }
        </script>
    </head>
    <body>
        <%
            Class.forName("com.mysql.jdbc.Driver").newInstance();

            Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
            PreparedStatement s = conn.prepareStatement(""); //"SELECT * FROM Students_Class JOIN Students"
//                     + " on Students_Class.student_id"
//                     + " = Students.student_id WHERE Students_Class.class_id = ? ");
//                     s.setInt(1, Integer.parseInt(session.getAttribute("id").toString()));
          
//            ResultSet rs = s.executeQuery("SELECT Class.class_id from Teacher join Teacher_Class"//rows from junction table=rs
//                    + " on Teacher.teacher_id = Teacher_Class.teacher_id join Class on "
//                    + "Teacher_Class.class_id = Class.class_id WHERE Teacher.teacher_id = " + (int) session.getAttribute("id"));//
//            //joint tables Teacher and Teacher_Class on teacher_id then joint with te Class table on class_id, many to many
//
//            ArrayList<String> Students = new ArrayList<>();//list of students
//            
//            while (rs.next()) {//class_id ad students,query
//                s = conn.createStatement();
//                //ResultSet rs2 = s.executeQuery("SELECT * FROM Students WHERE class_id = " + rs.getInt(1));//list of all students from every class of this teacher i.e. id=2
//                ResultSet rs2 = s.executeQuery("SELECT * from Students_Class JOIN Students ON Students_Class.student_id"
//                        + " = Students.student_id WHERE Students_Class.class_id = " + rs.getInt(1));
//                while (rs2.next()) {//iterate through students from one of the classes using the class id
//                    Students.add(rs2.getString("Students.name") + " " + rs2.getString("Students.surname") + "," + rs2.getInt("student_id"));
//                }
//            }
            ArrayList<String> Students = new ArrayList<>();//list of students
            String type = request.getParameter("type");
            int id = Integer.parseInt(request.getParameter("id"));
            

            if (type.equals("Class")){
                s = conn.prepareStatement("SELECT * FROM Students_Class JOIN Students"
                + " on Students_Class.student_id" 
                + " = Students.student_id WHERE Students_Class.class_id = ?");
                s.setInt(1, id);
                
                 ResultSet rs2 = s.executeQuery();//"SELECT * FROM Students_Class JOIN Students ON Students_Class.student_id"
                     //+ " = Students.student_id WHERE Students_Class.class_id = " + id);
                 while (rs2.next()) {//iterate through students from one of the classes using the class id
                   Students.add(rs2.getString("Students.name") + " " + rs2.getString("Students.surname") + "," + rs2.getInt("student_id"));
                
                }
            } else { 
                s = conn.prepareStatement("SELECT * FROM Students_Groups JOIN Students"
                + " on Students_Groups.student_id" 
                + " = Students.student_id WHERE Students_Groups.group_id = ?");
                s.setInt(1, id);
                
                ResultSet rs2 = s.executeQuery();//"SELECT * FROM Students_Groups JOIN Students ON Students_Groups.student_id"
                     //+ " = Students.student_id WHERE Students_Groups.group_id = " + id);
                 while (rs2.next()) {//iterate through students from one of the groups using the group id
                   Students.add(rs2.getString("Students.name") + " " + rs2.getString("Students.surname") + "," + rs2.getInt("student_id"));
                
                }
               
            }
        %>
        <%@include file="header.jsp" %>

        <table style="margin-top: 60px; width: 25%; float: left; margin-left: 15px; border: solid 1px #CCC; border-radius: 25px">
            <tr><th style="padding: 5px; font-weight: bolder">Students</th></tr>
                    <%
                        for (String Student : Students) {
                    %> 
                    <tr style="border: solid 1px #CCC; "><td style="padding: 5px"><a onclick="Studentdetails(<%=Student.split(",")[1]%>)"><%=Student.split(",")[0]%> <i class="fas fa-angle-right"></i></a>
                    </td></tr> 
                    <%
                        }
                    %>
        </table>

        <div style="width: 30%; float: left; border: solid 1px #CCC; padding: 20px; margin-left: 50px; margin-top: 60px" id="Details">Please select a student...</div>
        
        <%@include file="footer.jsp" %>
    </body>
</html>
