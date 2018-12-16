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
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author jelenashaw
 */
@WebServlet(name = "Studentdetailsservlet", urlPatterns = {"/Studentdetailsservlet"})
public class Studentdetailsservlet extends HttpServlet {

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
            throws ServletException, IOException {//details butten has been clicked and this takes place after 
  
        String id_Student = request.getParameter("ids");//idstudent, we read it
        
        HttpSession session = request.getSession();//parameter, we know what the sudent is and we do to a new page-info about a certan student
        session.setAttribute("ids", id_Student);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher_studentdetails.jsp");
        dispatcher.forward(request, response);
    }

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

        int id = Integer.parseInt(request.getParameter("id"));//it is taken form the request from AJAX, logically this is student's id

        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
            PreparedStatement s = conn.prepareStatement("SELECT * FROM Students WHERE student_id = ?");
            s.setInt(1, id);
            ResultSet rs = s.executeQuery();
            String result = "";

            if (rs.first()) {//only one wuth one id
                result += "Name: " + rs.getString("name");//HTML
                result += "<br>Surname: " + rs.getString("surname");
                String dob = rs.getDate("date_of_birth").toString();
                String fl = rs.getString("first_language");
                String cor = rs.getString("country_of_origin");
                String em = rs.getString("student_email");
                
                s = conn.prepareStatement("SELECT * FROM Students_Class JOIN Class" 
                + " on Students_Class.class_id = Class.class_id WHERE Students_Class.student_id = ?");
                s.setInt(1, id);
                        
                ResultSet rs2 = s.executeQuery();//"SELECT * FROM Students_Class JOIN Class ON "
                        //+ "Students_Class.class_id = Class.class_id WHERE Students_Class.student_id = " + id);
                String classes = "";
                
                while(rs2.next()){
                
                    classes+=rs2.getString("Class.class_name") + ", ";
                }
                
                result += "<br>Class: " + classes.substring(0,classes.length()-2);
                result += "<br>DOB: " + dob;
                result += "<br>First Language: " + fl;
                result += "<br>Country: " + cor;
                result += "<br>E-mail: " + em;
                result += "<br><a href=\"Studentdetailsservlet?ids=" + id + "\"><button style=\"width:100px;margin-top:10px\" class=\"btn btn-primary\">Details</button></a>";//instead of using a form to get parametars via link    
            }

            response.setContentType("text/plain");// we return a plain messsage using AJAX and the data of students
            response.getWriter().write(result);

        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Studentdetailsservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            Logger.getLogger(Studentdetailsservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            Logger.getLogger(Studentdetailsservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Studentdetailsservlet.class.getName()).log(Level.SEVERE, null, ex);
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
