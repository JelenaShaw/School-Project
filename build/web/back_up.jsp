<%-- 
    Document   : teacher_studentdetails
    Created on : 10.06.2018., 12.44.31
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
        <title>School - Teacher (Student details)</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
        <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
        <link rel="stylesheet" href="header.css"> 
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp" crossorigin="anonymous">
    </head>
    <body style="padding-left: 35px; padding-top: 25px">
        <%@include file="header.jsp" %>
        <h3 style="margin-top: 50px"> </h3>

        <%
            String ids = session.getAttribute("ids").toString();//id student from session, which student explicitely
            String idp = "";//id parent
            String class_id = "";

            Class.forName("com.mysql.jdbc.Driver").newInstance();
            Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
            Statement s = conn.createStatement();

            ResultSet rs0 = s.executeQuery("SELECT * from Students_Class WHERE student_id = " + ids);

            while (rs0.next()) {
                class_id = "" + (rs0.getInt("class_id"));

            }

            ResultSet rs = s.executeQuery("SELECT * from Parents WHERE student_id = " + ids);//parents by students id

            while (rs.next()) {
                idp = "" + (rs.getInt("parent_id"));
        %>

        <h5> Parents: </h5>

        <p><%=(rs.getString("parent_name").replace(",", " and ") + " " + rs.getString("parent_surname"))%> </p> 
        <% //parent's name and surname
            }

            if (!idp.equals("")) {
                rs = s.executeQuery("SELECT * from Parents_Evenings WHERE parent_id = " + idp + " AND student_id = " + ids);
        %>

        <style>
            th {width: 120px; text-align: center;border-bottom: 3px solid #0088cc;padding: 10px}
            td {width: 120px; text-align: center;border-bottom: 2px solid #0088cc;padding: 10px;border-right: 2px solid #0088cc;border-left: 2px solid #0088cc;}
        </style> 

        <br>
        <table> 
            <h5>Parents Evenings:</h5>
            <tr>  <th>Term</th>  <th>Date</th>  <th>Time</th> </tr>  
                    <%
                        while (rs.next()) {
                    %>
            <tr> <td> <%=rs.getInt("term_id")%> </td> <td> <%=rs.getDate("date")%> </td> <td> <%=rs.getTime("time")%></td></tr> 
            <%
                }
            %>
        </table> 
        <br>
        <%}%>

        <script>
            function Tests(ids, subjectid)
            {
                $.post(
                        "Studentinfoservlet",
                        {
                            "ids": ids,
                            "info": "Tests",
                            "teacher": "true",
                            "subjectid": subjectid
                        },
                        function (responsetext)
                        {
                            document.getElementById("Testsdisplay").innerHTML = responsetext;
                        }
                );
            }

            function Cambridge_Finals(ids)
            {
                $.post(
                        "Studentinfoservlet",
                        {
                            "ids": ids,
                            "info": "Cambridge"
                        },
                        function (responsetext)
                        {
                            document.getElementById("Cambridgedisplay").innerHTML = responsetext;
                        }
                );
            }

            function Reports(ids, subjectid)
            {
                $.post(
                        "Studentinfoservlet",
                        {
                            "info": "Reports", //key, value 
                            "ids": ids,
                            "subjectid": subjectid,
                            "teacher": "true"
                        },
                        function (responsetext)
                        {
                            var reportdisplay = document.getElementById("Reportsdisplay");
                            reportdisplay.innerHTML = responsetext;
                        }
                );
            }
            
            function Overall(ids){
                $.post(
                        
                     "Studentinfoservlet",
             {
                     "info": "Overall",
                     "ids": ids,
                     "teacher": "true"
                 },
                 function (responsetext)
                 {
                     var overalldisplay = document.getElementById("Overalldisplay");
                     overalldisplay.innerHTML = responsetext;
                     
                 }
                );
                
            }
            

            function Mex(ids, subjectid)
            {
                $.post(
                        "Studentinfoservlet",
                        {
                            "info": "Mex",
                            "ids": ids,
                            "subjectid": subjectid,
                            "teacher": "true"
                        },
                        function (responsetext)
                        {
                            var mexdisplay = document.getElementById("Mexdisplay");
                            mexdisplay.innerHTML = responsetext;
                        }
                );
            }
        </script>

        <h5> Reports: </h5>
        <div class="container">
            <div class="row">

                <%
                    rs = s.executeQuery("SELECT * from Teacher_Class WHERE teacher_id = " + session.getAttribute("id"));

                    if (rs.first()) {

                        rs = s.executeQuery("SELECT * from Class_Subjects JOIN Subjects on Class_Subjects.subject_id = Subjects.subject_id"
                                + " WHERE Class_Subjects.class_id = " + class_id);
                        while (rs.next()) { //id student, id subject=button
                %>
                <button style="width:15%;margin-right:10px;margin-bottom: 10px" onclick="Reports(<%=ids%>,<%=rs.getInt("Subjects.subject_id")%>)" class="btn btn-primary"> <%=rs.getString("Subjects.subject_name")%></button>

                <%}

                } else {
                    rs = s.executeQuery("SELECT * from Teacher_Groups WHERE teacher_id = " + session.getAttribute("id"));//group taught
                    while (rs.next()) {
                        rs = s.executeQuery("SELECT * from Subjects WHERE subject_id = " + rs.getInt("group_id"));
                        while (rs.next()) { //id student, id subject=button
                %>
                <button style="width:15%;margin-right:10px;margin-bottom: 10px" onclick="Reports(<%=ids%>,<%=rs.getInt("subject_id")%>)" class="btn btn-primary"> <%=rs.getString("subject_name")%></button>

                <%}
                        }
                    }

                %>
            </div>
        </div>
        <br><br>
        <div id="Reportsdisplay"></div>
        
        <h5> Overall Reports: </h5>
        <button style="margin-left: 40px" onclick="Overall(<%=ids%>)" class="btn btn-primary"> Overall Reports </button>
        <div id="Overalldisplay"> </div>

        <%            rs = s.executeQuery("SELECT * from Students_Class join Class on Students_Class.class_id = Class.class_id"
                    + " WHERE Students_Class.student_id = " + ids);
            String class_name = "";

            while (rs.next()) {
                class_name = rs.getString("Class.class_name");

            }
            if (class_name.equals("year 2") || class_name.equals("year 6")) {
            

        %>
        
        <h5> Mock Exams: </h5>

        <%            rs = s.executeQuery("SELECT * from Subjects WHERE subject_id in (11,12,13)");
            while (rs.next()) {
        %>
        <button style="margin-left: 40px" onclick="Mex(<%=ids%>,<%=rs.getInt("subject_id")%>)" class="btn btn-primary"> <%=rs.getString("subject_name")%></button>
        <%
            }
        %>
        <br><br>
        <div id="Mexdisplay"></div>
        <%}%>

        <h5> Tests: </h5>
        <%
            rs = s.executeQuery("SELECT * from Subjects WHERE subject_id in (11,12,13)");
            while (rs.next()) {
        %>
        <button style="margin-left: 40px;margin-top: 5px" onclick="Tests(<%=ids%>,<%=rs.getInt("subject_id")%>)" class="btn btn-primary"> <%=rs.getString("subject_name")%></button>
        <%
            }
        %>
        <div style="padding-top: 20px; padding-bottom: 20px"id="Testsdisplay"> </div>

        <h5> Cambridge Finals: </h5>
        <button style="margin-left: 40px;margin-top: 5px" onclick="Cambridge_Finals(<%=ids%>)" class="btn btn-primary"> Cambridge Finals </button>
        <br><br>
        <div style="margin-bottom: 50px" id="Cambridgedisplay"></div>

        <%@include file="footer.jsp" %>
    </body>
</html>
