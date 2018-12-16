<%-- 
    Document   : student
    Created on : 03.06.2018., 10.02.21
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
        <title>School - Student</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="header.css"> 
        <link rel="stylesheet" href="accordion.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp" crossorigin="anonymous">
    </head>
    <body style="padding-top: 75px; padding-left: 50px">
        <%@include file="header.jsp"%>
         <style>
            .panel-body {padding: 20px; text-align: center}
            .panel-body table {float: none; margin: auto}
        </style>
        <style>
            th {width: 120px !important; text-align: center;border-bottom: 3px solid #0088cc; padding: 10px}
            td {width: 120px !important; text-align: center;border-bottom: 2px solid #0088cc; padding: 10px; border-right: 2px solid #0088cc;border-left: 2px solid #0088cc;}
        </style> 
        <%     
            String e_mail = "";
            
            int no_of_meetings = 0;
            
            Class.forName("com.mysql.jdbc.Driver").newInstance();//finding driver by its name
            Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
            PreparedStatement s = conn.prepareStatement("SELECT * FROM Students WHERE student_id = ?");
            s.setInt(1, Integer.parseInt(session.getAttribute("id").toString()));
            
            ResultSet rs = s.executeQuery();//session.getAttribute by id for the user while logged in
            while (rs.next()) {//like Scanner
                e_mail = rs.getString("student_email");
            }
            
            if (session.getAttribute("role").equals(2)) {// if role in session is 2 show HTML - Student role 2
        %>

            <div style="float: right; padding-right: 45px"><b>Your e-mail address:</b> <br> <%=e_mail%></div>

        <%} else {
            s = conn.prepareStatement("SELECT * FROM Parents_Evenings WHERE parent_id = ?");
            s.setInt(1, Integer.parseInt(session.getAttribute("id").toString()));
            
            rs = s.executeQuery();
        %>
            <style>
                th {width: 120px; text-align: center}
                td {width: 120px; text-align: center}
            </style>
            <br>
            <table style="float: right; clear: right; margin-right: 45px; margin-top: 0px;"> 
                <h5 style="float: right; margin-right: 200px; margin-top: -30px;">Parents Evenings:</h5>
                <tr>  <th>Term</th>  <th>Date</th>  <th>Time</th> </tr>  
                <%               
                    while (rs.next()) {//like Scanner goes through the list 
                        no_of_meetings += 1;
                %>
                    <tr> <td> <%=rs.getInt("term_id")%> </td> <td> <%=rs.getDate("date")%> </td> <td> <%=rs.getTime("time")%></td></tr>
                <%
                    }
                %>
            </table> 
            <br>
        <%}%>
        <div class="container" style="padding-top: <%=(50 + no_of_meetings * 40)%>px">
            <div class="panel-group" id="accordion">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                               Cambridge Primary Checkpoint
                            </a>
                        </h4>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in">
                        <div class="panel-body">
        
        <button style="margin-left: 40px"class="btn btn-primary" onclick="Cambridge_Finals(<%=session.getAttribute("id")%>)"> Cambridge Primary Checkpoint </button>
        <div id="out"></div>
        </div>
                    </div>
                </div>
            <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">
                               Reports
                            </a>
                        </h4>
                    </div>
                    <div id="collapseTwo" class="panel-collapse collapse">
                        <div class="panel-body">

        
        <%  
            s = conn.prepareStatement("SELECT * FROM Students_Class JOIN Class_Subjects ON "
                    + " Students_Class.class_id = Class_Subjects.class_id WHERE Students_Class.student_id = ? ");
            s.setInt(1, Integer.parseInt(session.getAttribute("id").toString()));
                    
            rs = s.executeQuery();// do not change
            while (rs.next()) {
                s = conn.prepareStatement("SELECT * FROM Subjects WHERE subject_id = ?");
                s.setInt(1, rs.getInt("Class_Subjects.subject_id"));
                
                ResultSet rs2 = s.executeQuery();
                
                if(rs2.first()){
        %>
            <button style="margin-right: 10px; width: 15%; margin-bottom: 10px" onclick="Reports(<%=session.getAttribute("id")%>,<%=rs2.getInt("subject_id")%>)" class="btn btn-primary"> <%=rs2.getString("subject_name")%></button>
        <% //id student, id subject=button, session logged in, executeQuery and excute the difference? And subject_id and subject_name id and getString? 
            }
        }
        s = conn.prepareStatement("SELECT * FROM Students_Groups WHERE student_id = ?");
        s.setInt(1, Integer.parseInt(session.getAttribute("id").toString()));
        ResultSet rs2 = s.executeQuery();
           while (rs2.next()){
           s = conn.prepareStatement("SELECT * FROM Groups WHERE group_id = ?");
           s.setInt(1, rs2.getInt("group_id"));
           ResultSet rs3 = s.executeQuery();
           if (rs3.first()){
            %>
            <button style="margin-right: 10px; width: 15%; margin-bottom: 10px" onclick="Reports(<%=session.getAttribute("id")%>,<%=rs2.getInt("group_id")%>)" class="btn btn-primary"> <%=rs3.getString("name")%></button>
            <% 
      }
} 
        
        %>
        <br><br>
        <div id="Reportsdisplay" style="width: 90%"></div>
                        </div>
                    </div>
            
            </div>
        

        <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseThree">
                               Mock Exams
                            </a>
                        </h4>
                    </div>
                    <div id="collapseThree" class="panel-collapse collapse">
                        <div class="panel-body">
        <%
            s = conn.prepareStatement("SELECT * FROM Subjects WHERE subject_id in (11,12,13)");
            rs = s.executeQuery(); // do not change
            while (rs.next()) {
        %>
            <button style="margin-left: 40px" onclick="Mex(<%=session.getAttribute("id")%>,<%=rs.getInt("subject_id")%>)" class="btn btn-primary"> <%=rs.getString("subject_name")%></button>
        <%
            }
        %>
        <br> <br>
        <div id="Mexdisplay"></div>
        
                        </div>
        </div>
        </div>

        <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseFour">
                               Tests
                            </a>
                        </h4>
                    </div>
                    <div id="collapseFour" class="panel-collapse collapse">
                        <div class="panel-body">
        <%  
            s = conn.prepareStatement("SELECT * FROM Subjects WHERE subject_id in (11,12,13)");
            rs = s.executeQuery();
            while (rs.next()) {
        %>
            <button style="margin-left: 40px" onclick="Tests(<%=session.getAttribute("id")%>,<%=rs.getInt("subject_id")%>)" class="btn btn-primary"> <%=rs.getString("subject_name")%></button>
        <%
           }
        %>
        <br><br>
        <div style="margin-bottom: 50px" id="Testsdisplay"></div>
        </div>
        </div>
        </div>
         </div>
         </div>

        <%@include file="footer.jsp" %>
    </body>
    <script>
        function Cambridge_Finals(ids) {//ids id student
            $.post( // call servlet over ajax
                "Studentinfoservlet",
                {
                    "ids": ids, "info": "Cambridge"
                }, //info - tell the servlet which piece of info we want
                function (responsetext) 
                { // function that accepts servlets response and displays it
                    document.getElementById("out").innerHTML = responsetext;
                }
            );
        }

        function Reports(ids, subjectid) {//explanation
            $.post(
                "Studentinfoservlet",
                {
                    "info": "Reports", //key, value 
                    "ids": ids,
                    "subjectid": subjectid,
                    "teacher": "false"
                },
                function (responsetext) 
                {
                    var reportdisplay = document.getElementById("Reportsdisplay");
                    reportdisplay.innerHTML = responsetext;
                }
            );
        }

        function Mex(ids, subjectid) {
            $.post(
                "Studentinfoservlet",
                {
                    "info": "Mex",
                    "ids": ids,
                    "subjectid": subjectid,
                    "teacher": "false"
                },
                function (responsetext) 
                {
                    var mexdisplay = document.getElementById("Mexdisplay");
                    mexdisplay.innerHTML = responsetext;
                }
            );
        }

        function Tests(ids, subjectid) {
            $.post(
                "Studentinfoservlet",
                {
                    "ids": ids,
                    "info": "Tests",
                    "teacher": "false", //false - meaning no button is returned
                    "subjectid": subjectid
                },
                function (responsetext) 
                {
                    document.getElementById("Testsdisplay").innerHTML = responsetext;
                }
            );
        }
    </script>
</html>
