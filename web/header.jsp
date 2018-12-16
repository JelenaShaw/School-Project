
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%-- 
    Document   : header
    Created on : 28.05.2018., 11.58.09
    Author     : jelenashaw
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String school_name = "";//from DB school info

    String school_address = "";

    Class.forName("com.mysql.jdbc.Driver").newInstance();//finding driver by its name

    Connection connHeader = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
    Statement sHeader = connHeader.createStatement();//create statement 
    ResultSet rsHeader = sHeader.executeQuery("SELECT * from School");
    while (rsHeader.next()) {
        school_name = rsHeader.getString("school_name");//usersession, to save the school data from DB
        school_address = rsHeader.getString("school_address");//read from DB (from resultset)
    }
    //@include to fetch everything from header.jsp file
%> 


<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span> 
            </button> 
            <% if (session.getAttribute("name") != null) {//if anyone is logged in?
                if (((int)session.getAttribute("role")) == 0) {
            %>
            <a class="navbar-brand  navbar-brand-centered" href="teacher.jsp"><%=school_name%></a>
            <%
                } else 
                {
            %>
            <a class="navbar-brand  navbar-brand-centered" href="student.jsp"><%=school_name%></a>
            <%
                }
            } else {
            %>
            <a class="navbar-brand  navbar-brand-centered" href="#"><%=school_name%></a>
            <%
                }
            %>
        </div>
        <!--teacher's name or parent or student-->
        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav navbar-right">
 
                <%
                    if (session.getAttribute("name") != null) {//if not null then...
                %>
                        <li><a href="#"><%=session.getAttribute("name")%></a></li>

                        <li><a href="Logoutservlet"><i class="fas fa-sign-out-alt"></i></a></li>
                <%
                    } else {
                %>  
                        <li><a href="#">Please log in</a></li>
                <%}%>

            </ul>
        </div>
    </div>
</nav>
