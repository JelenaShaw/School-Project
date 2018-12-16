<%-- 
    Document   : teacher_input
    Created on : 20.06.2018., 14.43.10
    Author     : jelenashaw
--%>

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>School - Add <%=request.getParameter("type")%> </title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
        <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
        <link rel="stylesheet" href="header.css"> 
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp" crossorigin="anonymous">
        <!-- Include Editor style. -->
        <link href='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/2.8.5/css/froala_editor.min.css' rel='stylesheet' type='text/css' />
        <link href='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/2.8.5/css/froala_style.min.css' rel='stylesheet' type='text/css' />

        <!-- Include JS file. -->
        <script type='text/javascript' src='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/2.8.5/js/froala_editor.min.js'></script>
    </head>
    <body>
        <%@include file="header.jsp"%>

        <h1 style="margin-left: 20px; margin-top: 60px"> Add <%=request.getParameter("type")%></h1>
        <% if (request.getParameter("type").equals("report")) {
                // This entire block of code loads the name that corresponds to subject and student id parameters
                Class.forName("com.mysql.jdbc.Driver").newInstance();//finding driver by its name
                Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
                PreparedStatement s = conn.prepareStatement("SELECT * FROM Students WHERE student_id = ?");
                s.setInt(1, Integer.parseInt(request.getParameter("idstudent")));

                ResultSet rs = s.executeQuery();//"SELECT * FROM Students WHERE student_id = " + request.getParameter("idstudent"));

                String name = "";
                String surname = "";

                while (rs.next()) {
                    name = rs.getString("name");
                    surname = rs.getString("surname");

                }
                s = conn.prepareStatement("SELECT * FROM Subjects WHERE subject_id = ?");
                s.setInt(1, Integer.parseInt(request.getParameter("subjectid")));
                rs = s.executeQuery();
                String subject = "";

                while (rs.next()) {
                    subject = rs.getString("subject_name");
                }
        %>
        <h5 style="margin-left: 20px"> Subject: <%=subject%> </h5>
        <h5 style="margin-left: 20px">Student: <%=name%> <%=surname%> </h5>
        <script>
            function report_validation() {
                var achievement = document.getElementsByName("achievement")[0];
                var term_id = document.getElementsByName("term_id")[0];
                var description = document.getElementsByName("description")[0];
                var effort = document.getElementsByName("effort")[0];

                var achievementRegex = new RegExp("[A-F]");
                if (!achievementRegex.test(achievement.value)) {
                    alert("Achievement has to be between A and F;\n\n\Effort between 1 and 3;\n\nTerm has to be a number and Description cannot contain fewer than 50 characters");
                    return false;
                }

                var effortRegex = new RegExp("[1-3]");
                if (!effortRegex.test(effort.value)) {
                    alert("Achievement has to be between A and F;\n\n\Effort between 1 and 3;\n\nTerm has to be a number and Description cannot contain fewer than 50 characters");
                    return false;
                }


                var term_idRegex = new RegExp("[1-3]");
                if (!term_idRegex.test(term_id.value)) {
                    alert("Achievement has to be between A and F;\n\n\Effort between 1 and 3;\n\nTerm has to be a number and Description cannot contain fewer than 50 characters");
                    return false;
                }

                if (description.value.length < 50) {
                    alert("Achievement has to be between A and F;\n\n\Effort between 1 and 3;\n\nTerm has to be a number and Description cannot contain fewer than 50 characters");
                    return false;
                }
                return true;
            }
            $(function () {
                $('textarea.froala-editor').froalaEditor();
            });
        </script>
        <style>
            .fr-box{max-width: 80%; z-index: 1}
        </style>

        <form method="POST" action="Inputservlet" onsubmit="return report_validation()" style= "margin-left: 20px" id="report_form">
            <input type="text" name="subject_id" value="<%=request.getParameter("subjectid")%>" hidden>
            <input type="text" name="student_id" value="<%=request.getParameter("idstudent")%>" hidden>
            <input type="text" name="type" value="report" hidden>

            Term: <br> <input type="text" name="term_id"> <br><br>
            Description: <br> <textarea class="froala-editor" rows="5" cols="100" form="report_form" name="description">This term we have been...</textarea> <br><br>
            Teacher Comment: <br> <textarea class="froala-editor" rows="5" cols="100" form="report_form" name="description2">Teacher Comment:</textarea> <br><br>
            Target: <br> <textarea class="froala-editor" rows="5" cols="100" form="report_form" name="description3">Target:</textarea> <br><br>
            Effort: <br> <input  type="text" name="effort"> <br><br>
            Achievement: <br> <input  type="text" name="achievement"> <br><br>

            <input class="btn btn-primary" type="submit" style="margin-bottom: 200px" value="Add Report">
        </form>
        <%} else if (request.getParameter("type").equals("mex")) {
            Class.forName("com.mysql.jdbc.Driver").newInstance();//finding driver by its name
            Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
            PreparedStatement s = conn.prepareStatement("SELECT * FROM Students WHERE student_id = ? ");
            s.setInt(1, Integer.parseInt(request.getParameter("idstudent")));

            ResultSet rs = s.executeQuery();

            String name = "";
            String surname = "";

            while (rs.next()) {
                name = rs.getString("name");
                surname = rs.getString("surname");
            }
            s = conn.prepareStatement("SELECT * FROM Subjects WHERE subject_id = ?");
            s.setInt(1, Integer.parseInt(request.getParameter("subjectid")));
            rs = s.executeQuery();
            String subject = "";

            while (rs.next()) {
                subject = rs.getString("subject_name");
            }
        %>
        <h5 style="margin-left: 20px"> Subject: <%=subject%> </h5>
        <h5 style="margin-left: 20px">Student: <%=name%> <%=surname%> </h5>
        <script>
            function mex_validation() {
                var grade = document.getElementsByName("grade")[0];
                var week_id = document.getElementsByName("week_id")[0];

                var gradeRegex = new RegExp("[A-F]");

                if (!gradeRegex.test(grade.value)) {
                    alert("Grade has to be between A and F and \n\n\Week has to be between numbers 1 and 12");
                    return false;
                }

                if (parseInt(week_id.value) < 1 || parseInt(week_id.value) > 12) {
                    alert("Grade has to be between A and F and \n\n\Week has to be between numbers 1 and 12");
                    return false;
                }
                return true;
            }
        </script>

        <form method="POST" action="Inputservlet" onsubmit="return mex_validation()" style= "margin-left: 20px" id="report_form">
            <input type="text" name="subject_id" value="<%=request.getParameter("subjectid")%>" hidden>
            <input type="text" name="student_id" value="<%=request.getParameter("idstudent")%>" hidden>
            <input type="text" name="type" value="mex" hidden>
            Grade: <br> <input  type="text" name="grade"> <br><br>
            Week: <br> <input type="text" name="week_id"> <br><br>
            <input class="btn btn-primary" type="submit" value="Add Mock Exam">
        </form>

        <%} else if (request.getParameter("type").equals("tests")) {
            Class.forName("com.mysql.jdbc.Driver").newInstance();//finding driver by its name
            Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
            PreparedStatement s = conn.prepareStatement("SELECT * FROM Students WHERE student_id = ? ");
            s.setInt(1, Integer.parseInt(request.getParameter("idstudent")));

            ResultSet rs = s.executeQuery();

            String name = "";
            String surname = "";

            while (rs.next()) {
                name = rs.getString("name");
                surname = rs.getString("surname");
            }
            s = conn.prepareStatement("SELECT * FROM Subjects WHERE subject_id = ?");
            s.setInt(1, Integer.parseInt(request.getParameter("subjectid")));
            rs = s.executeQuery();//"SELECT * from Subjects WHERE subject_id = " + request.getParameter("subjectid"));
            String subject = "";

            while (rs.next()) {
                subject = rs.getString("subject_name");
            }
        %>
        <h5 style="margin-left: 20px"> Subject: <%=subject%> </h5>
        <h5 style="margin-left: 20px">Student: <%=name%> <%=surname%> </h5>
        <script>
            function test_validation() {
                var week_id = document.getElementsByName("week_id")[0];

                if (parseInt(week_id.value) < 1 || parseInt(week_id.value) > 12) {
                    alert("Result can either be in the format points/max points or /max points if graded later and \n\n\Week has to be between numbers 1 and 12");
                    return false;
                }
                return true;
            }
        </script>

        <form method="POST" action="Inputservlet" onsubmit="return test_validation()" style="margin-left: 20px" id="tests_form">
            Week: <br> <input type="text" name="week_id"> <br> <br>
            Result: <br> <input  type="text" name="result"> <br><br>
            <input type="text" name="type" value="tests" hidden>
            <input type="text" name="subject_id" value="<%=request.getParameter("subjectid")%>" hidden>
            <input type="text" name="student_id" value="<%=request.getParameter("idstudent")%>" hidden>
            <input class="btn btn-primary" type="submit" value="Add Test">
        </form>

        <%
        } else if (request.getParameter("type").equals("result")) {
        %>

        <form method="POST" action="Inputservlet" style="margin-left: 20px">
            <input type="text" name="points" value="<%=request.getParameter("max")%>">
            <input type="text" value="<%=request.getParameter("test_id")%>" name="test_id" hidden>
            <input type="text" name="type" value="result" hidden>
            <input type="submit" class="btn btn-primary" value="Add Points">
        </form>
        <%} else if (request.getParameter("type").equals("overall")) {

            Class.forName("com.mysql.jdbc.Driver").newInstance();//finding driver by its name
            Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
            PreparedStatement s = conn.prepareStatement("SELECT * FROM Students WHERE student_id = ?");
            s.setInt(1, Integer.parseInt(request.getParameter("idstudent")));

            ResultSet rs = s.executeQuery();

            String name = "";
            String surname = "";

            while (rs.next()) {
                name = rs.getString("name");
                surname = rs.getString("surname");

            }%>


        <h5 style="margin-left: 20px">Student: <%=name%> <%=surname%> </h5>
        <script>
            $(function () {
                $('textarea.froala-editor').froalaEditor();
            });
        </script>
        <style>
            .fr-box{max-width: 80%; z-index: 1}
        </style>

        <form method="POST" id="overall_form" action="Inputservlet" style="margin-left: 20px; margin-bottom: 50px;">
            <input type="text" name="type" value="overall" hidden=>
            Term: <br ><input type="text" name="term"> <br> <br>
            Description: <br> <textarea class="froala-editor" rows="5" cols="100" form="overall_form" name="description">Class Teacher General Comment: </textarea> <br><br>
            Target: <br> <textarea class="froala-editor" rows="5" cols="100" form="overall_form" name="description2">Target: </textarea> <br><br>    
            <input class="btn btn-primary" type="submit" value="Add Overall Report">
            <input type="text" name="student_id" value="<%=request.getParameter("idstudent")%>" hidden>
        </form>

        <%}%>
        <%@include file="footer.jsp" %>  
    </body>
</html>
