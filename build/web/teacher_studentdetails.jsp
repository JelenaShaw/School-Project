<%-- 
    Document   : teacher_studentdetails
    Created on : 10.06.2018., 12.44.31
    Author     : jelenashaw
--%>

<%@page import="java.sql.PreparedStatement"%>
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
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="header.css"> 
        <link rel="stylesheet" href="accordion.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp" crossorigin="anonymous">
    </head>
    <body style="padding-left: 35px; padding-top: 25px">
        <%@include file="header.jsp" %>
        <h3 style="margin-top: 50px"> </h3>

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

            function Overall(ids) {
                $.post(
                        "Studentinfoservlet",
                        {
                            "info": "Overall",
                            "ids": ids,
                            "teacher": "true"
                        },
                        function (responsetext) {
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
        <%
            String name = "";
            String surname = "";
            String ids = session.getAttribute("ids").toString();//id student from session, which student explicitely
            
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
                                
            
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM Students WHERE student_id = ?");
            ps.setInt(1, Integer.parseInt(ids));
            ResultSet rs = ps.executeQuery();
            
            if (rs.first()){
                name = rs.getString("name");
                surname = rs.getString("surname");
            }
        %>
        <style>
            .panel-body {padding: 20px; text-align: center}
            .panel-body table {float: none; margin: auto}
        </style>
       
        <div class="container">
            
            <h3><%=name + " " + surname%></h3>
            
            <div class="panel-group" id="accordion" style="margin-bottom: 50px;">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                                Parent details
                            </a>
                        </h4>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <%
                                
                                String idp = "";//id parent
                                String class_id = "";

                                PreparedStatement s = conn.prepareStatement("SELECT * FROM Students_Class WHERE student_id = ?");
                                s.setInt(1, Integer.parseInt(ids));

                                ResultSet rs0 = s.executeQuery();

                                while (rs0.next()) {
                                    class_id = "" + (rs0.getInt("class_id"));

                                }
                                s = conn.prepareStatement("SELECT * FROM Parents WHERE student_id = ? ");
                                s.setInt(1, Integer.parseInt(ids));
                                rs = s.executeQuery();//parents by students id

                                while (rs.next()) {
                                    idp = "" + (rs.getInt("parent_id"));
                            %>

                            <h5> Parents: </h5>

                            <p><%=(rs.getString("parent_name").replace(",", " and ") + " " + rs.getString("parent_surname"))%> </p> 
                            <% //parent's name and surname
                                }

                                if (!idp.equals("")) {
                                    s = conn.prepareStatement("SELECT * from Parents_Evenings WHERE parent_id = ? AND student_id = ?");
                                    s.setInt(1, Integer.parseInt(idp));
                                    s.setInt(2, Integer.parseInt(ids));
                                    
                                    rs = s.executeQuery();//"SELECT * from Parents_Evenings WHERE parent_id = " + idp + " AND student_id = " + ids);
                            %>

                            <style>
                                th {width: 120px !important; text-align: center;border-bottom: 3px solid #0088cc;padding: 10px}
                                td {width: 120px !important; text-align: center;border-bottom: 2px solid #0088cc;padding: 10px;border-right: 2px solid #0088cc;border-left: 2px solid #0088cc;}
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
                            <div class="container">
                                <div style="width: 92%; padding: 0; overflow: hidden">

                                    <%
                                        s = conn.prepareStatement("SELECT * FROM Teacher_Class WHERE teacher_id = ?");
                                        s.setInt(1, Integer.parseInt(session.getAttribute("id").toString()));
                                        rs = s.executeQuery();

                                        if (rs.first()) {
                                            s = conn.prepareStatement("SELECT * FROM Class_Subjects JOIN Subjects"
                                            + " on Class_Subjects.subject_id = Subjects.subject_id WHERE Class_Subjects.class_id = ?");
                                            s.setInt(1, rs.getInt("class_id"));
                                            rs = s.executeQuery();//"SELECT * FROM Class_Subjects JOIN Subjects on Class_Subjects.subject_id = Subjects.subject_id"
                                                    //+ " WHERE Class_Subjects.class_id = " + class_id);
                                            while (rs.next()) { //id student, id subject=button
                                    %>
                                    <button style="width:18%; margin-bottom: 10px" onclick="Reports(<%=ids%>,<%=rs.getInt("Subjects.subject_id")%>)" class="btn btn-primary"> <%=rs.getString("Subjects.subject_name")%></button>

                                    <%}

                                    } else {
                                        s = conn.prepareStatement("SELECT * FROM Teacher_Groups WHERE teacher_id = ?");
                                        s.setInt(1, Integer.parseInt(session.getAttribute("id").toString()));
                                        rs = s.executeQuery();//group taught
                                        while (rs.next()) {
                                            s = conn.prepareStatement("SELECT * FROM Subjects WHERE subject_id = ?");
                                            s.setInt(1, rs.getInt("group_id"));
                                            rs = s.executeQuery();
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
                            <div id="Reportsdisplay" style="width: 100%; overflow: hidden;"></div>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseSix">
                                Overall Reports
                            </a>
                        </h4>
                    </div>
                    <div id="collapseSix" class="panel-collapse collapse">
                        <div class="panel-body">
                            <div class="container">
                               <div style="width: 92%; padding: 0; overflow: hidden">
                                    <button style="width:15%;margin-right:10px;margin-bottom: 10px" class="btn btn-primary" onclick="Overall(<%=ids%>)">
                                        Overall Reports
                                    </button>
                                </div>
                            </div>
                            <br><br>
                            <div id="Overalldisplay" style="width: 100%; overflow: hidden;"></div>
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
                            <div style="width: 92%; padding: 0; overflow: hidden">
                            <%  
                                s = conn.prepareStatement("SELECT * from Students_Class join Class"
                                + " on Students_Class.class_id = Class.class_id WHERE Students_Class.student_id = ?");
                                s.setInt(1, Integer.parseInt(ids));
                                
                                rs = s.executeQuery();//"SELECT * from Students_Class join Class on Students_Class.class_id = Class.class_id"
                                        //+ " WHERE Students_Class.student_id = " + ids);
                                String class_name = "";

                                while (rs.next()) {
                                    class_name = rs.getString("Class.class_name");

                                }
                                if (class_name.equals("year 2") || class_name.equals("year 6")) {

                            %>

                            <%  
                                s = conn.prepareStatement("SELECT * from Subjects WHERE subject_id in (11,12,13)");
                                rs = s.executeQuery();
                                while (rs.next()) {
                            %>
                            <button style="margin-left: 40px" onclick="Mex(<%=ids%>,<%=rs.getInt("subject_id")%>)" class="btn btn-primary"> <%=rs.getString("subject_name")%></button>
                            <%
                                }
                            %>
                            
                            <br><br>

                            <div id="Mexdisplay"></div>
                            <%}%>
                            </div>
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
                            <div style="width: 92%; padding: 0; overflow: hidden">
                            <%
                                s = conn.prepareStatement("SELECT * FROM Subjects WHERE subject_id in (11,12,13)");
                                rs = s.executeQuery();
                                while (rs.next()) {
                            %>
                            <button style="margin-left: 40px;margin-top: 5px" onclick="Tests(<%=ids%>,<%=rs.getInt("subject_id")%>)" class="btn btn-primary"> <%=rs.getString("subject_name")%></button>
                            <%
                                }
                            %>
                            <div style="padding-top: 20px; padding-bottom: 20px"id="Testsdisplay"> </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseFive">
                                Cambridge Primary Checkpoint
                            </a>
                        </h4>
                    </div>
                    <div id="collapseFive" class="panel-collapse collapse">
                        <div class="panel-body">
                            <div style="width: 92%; padding: 0; overflow: hidden">
                            <button style="margin-left: 40px;margin-top: 5px" onclick="Cambridge_Finals(<%=ids%>)" class="btn btn-primary"> Cambridge Primary Checkpoint </button>
                            <br><br>
                            <div style="margin-bottom: 50px" id="Cambridgedisplay"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%@include file="footer.jsp" %>
    </body>
</html>
