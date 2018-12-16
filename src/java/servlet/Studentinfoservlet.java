/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jelenashaw
 */
@WebServlet(name = "Studentinfoservlet", urlPatterns = {"/Studentinfoservlet"})
public class Studentinfoservlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {}

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("ids"));//id student
            String info = request.getParameter("info");//parameter

            int subject_id = -1;
            
            if (request.getParameter("subjectid") != null){
                subject_id = Integer.parseInt(request.getParameter("subjectid"));
            }
            
            Class.forName("com.mysql.jdbc.Driver").newInstance();

            Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
            PreparedStatement s = conn.prepareStatement("");
            
            if (info.equals("Cambridge")) {
        
                String data = "<table> <tr><th style=\"width: 100px; text-align: center;\">Centre ID</th><th style=\"width: 100px; text-align: center;\">Subject</th><th style=\"width: 100px; text-align: center;\">Grade</th></tr>";

                s = conn.prepareStatement("SELECT * FROM Cambridge_Final_Exams JOIN Subjects ON Cambridge_Final_Exams.subject_id "
                        + " = Subjects.subject_id WHERE student_id = ? ");
                s.setInt(1, id);
                ResultSet rs = s.executeQuery(); // join is done so we get subject names and not ids, name of the subject
                
                while (rs.next()) {
                    data += "<tr><td>" + rs.getInt("Cambridge_Final_Exams.cfe_id") + " </td>  <td> " + rs.getString("Subjects.subject_name") + " </td> <td>" + rs.getString("Cambridge_Final_Exams.grade") + "</td> </tr>";
                }
                
                data += "</table>";//Data is a variable that stores our info as a table
                
                response.setContentType("text/html");//type that is returned
                response.getWriter().write(data);

            } else if (info.equals("Reports")) {
                
                String data = "<table style=\"width: 100% !important;\"> <tr> <th>Term</th> <th>Effort</th> <th>Achievement</th> <th style=\"max-width: 800px;\">Description</th> </tr>";
                s = conn.prepareStatement("SELECT * FROM Reports WHERE student_id = ? AND subject_id = ?");
                s.setInt(1, id);
                s.setInt(2, subject_id);
                
                
                ResultSet rs = s.executeQuery();//"SELECT * FROM Reports WHERE student_id = " + id + " AND subject_id = " + request.getParameter("subjectid"));
                
                while (rs.next()) {
                    data += "<tr><td style=\"padding-bottom:10px\">" + rs.getInt("term_id") + "</td> <td style=\"padding-bottom:10px\">" + rs.getString("achievement") + "</td> <td style=\"padding-bottom:10px\">" + rs.getString("effort") + "</td> <td style=\"text-align: justify; padding-bottom: 10px; max-width: 800px;\">" + rs.getString("description") + "</td> </tr>";
                }// reports read from DB and organized in a table
          
                data += "</table>";
                
                if (request.getParameter("teacher").equals("true")) {
                        // add new report button if user is a teacher
                    data += "<a href=\"teacher_input.jsp?type=report&idstudent=" + id + "&subjectid=" + subject_id + "\"><button style=\"margin-left:20px; margin-top: 20px; width: 200px;\" class=\"btn btn-primary\">Add New Report</button></a>";//button=id subject and id student
                }

                response.setContentType("text/html");//notifies the caller that HTML will be returned
                response.getWriter().write(data); //return the organized data
                
            } else if (info.equals("Mex")) {
                
                String data = "<table> <tr> <th>Week</th> <th>Grade</th> </tr>";
                s = conn.prepareStatement("SELECT * FROM Mock_Exams WHERE student_id = ? AND subject_id = ?");
                s.setInt(1, id);
                s.setInt(2, subject_id);
                
                ResultSet rs = s.executeQuery();//"SELECT * FROM Mock_Exams WHERE student_id = " + id + " AND subject_id = " + request.getParameter("subjectid"));
                
                while (rs.next()) {
                    data += "<tr><td>" + rs.getInt("week_id") + "</td> <td>" + rs.getString("grade") + "</td> </tr>";
                }
                
                data += "</table>";
                
                if (request.getParameter("teacher").equals("true")) {//add new mex button if teacher asks...
                    data += "<a href=\"teacher_input.jsp?type=mex&idstudent=" + id + "&subjectid=" + subject_id + "\"><button style=\"margin-top:20px;margin-left:20px; width:200;\" class=\"btn btn-primary\">Add New Mock Exam</button></a>";
                }
                
                response.setContentType("text/html");// it returns data
                response.getWriter().write(data);
                
            } else if (info.equals("Tests")) {
                
                String data = "<table style=\"margin-bottom: 10px\"> <tr> <th> Result </th> <th> Week </th> ";
                
                if (request.getParameter("teacher").equals("true")) {//if teacher add space for 2 neww buttons
                    data += "<th> </th><th> </th>";//teacher sends AJAX request (buttons for tests)
                }
                
                data += " </tr>";
               
                s = conn.prepareStatement("SELECT * FROM Tests WHERE student_id = ? AND subject_id = ?");
                s.setInt(1, id);
                s.setInt(2, subject_id);
                
                ResultSet rs = s.executeQuery();//"SELECT * FROM Tests WHERE student_id = " + id + " AND subject_id = " + request.getParameter("subjectid"));
                
                while (rs.next()) {
                    data += "<tr><td>" + rs.getString("result") + "</td><td>" + rs.getInt("week_id") + "</td>  ";//both students and teachers see this
                
                    if (request.getParameter("teacher").equals("true")) {//if it is a teachet 2 buttons are added for grading or deleting a test
                        data += "<td> <a href=\"teacher_input.jsp?type=result&test_id=" + rs.getInt("test_id") + "&max=" + rs.getString("result") + "\"><i class=\"far fa-check-square\"></i> </a></td><td> <a href=\"Deleteservlet?test_id=" + rs.getInt("test_id") + "&student_id="+id+"\"><i class=\"fas fa-trash-alt\"></i> </a></td>";
                    }
                    
                    data += " </tr>";
                }
                
                data += "</table>";

                if (request.getParameter("teacher").equals("true")) {//new MEX add a new report or...add new Test
                    data += "<a href=\"teacher_input.jsp?type=tests&idstudent=" + id + "&subjectid=" + subject_id + "\"><button style=\"margin-left:20px; width: 200px;\" class=\"btn btn-primary\">Add New Test</button></a>";
                }
                
                response.setContentType("text/html");
                response.getWriter().write(data);
            } else if(info.equals("Overall")) {
                String data = "<table style=\"width: 100% !important;\"> <tr> <th>Term</th> <th style=\"max-width: 800px;\">Description</th> </tr>";
                s = conn.prepareStatement("SELECT * FROM Overall_Reports WHERE student_id = ?");
                s.setInt(1, id);
                ResultSet rs = s.executeQuery();//"SELECT * FROM Overall_Reports WHERE student_id = " + id);
                while (rs.next()) {
                    data += "<tr><td style=\"padding-bottom:10px\">" + rs.getInt("term_id") + "</td>" + "<td style=\"style=\"text-align: justify; padding-bottom: 10px; max-width: 800px;\">" + rs.getString("description") + "</td> </tr>";
                            }
                
                   data += "</table>";
                   
                   if (request.getParameter("teacher").equals("true")) {//new Overall add a new report
                    data += "<a href=\"teacher_input.jsp?type=overall&idstudent=" + id + "\"><button style=\"margin-left:20px;width: 200px; margin-top:25px;\" class=\"btn btn-primary\">Add New Overall Report </button></a>";
                }
                   response.setContentType("text/html");//notifies the caller that HTML will be returned
                   response.getWriter().write(data); //return the organized data
            }
            

        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Studentinfoservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            Logger.getLogger(Studentinfoservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            Logger.getLogger(Studentinfoservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Studentinfoservlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
