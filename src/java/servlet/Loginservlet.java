
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
@WebServlet(name = "Loginservlet", urlPatterns = {"/Loginservlet"})
public class Loginservlet extends HttpServlet {

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
            throws ServletException, IOException, ClassNotFoundException, SQLException, InstantiationException, IllegalAccessException {

        boolean redirected = false;
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Class.forName("com.mysql.jdbc.Driver").newInstance();

        Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
        
        PreparedStatement s = conn.prepareStatement("SELECT * FROM Students WHERE student_password = ?");
        s.setString(1, password);

        ResultSet rsStudents = s.executeQuery();//students first password ok, there is match then..below
        
        while (rsStudents.next()) {
            String combinedusername = rsStudents.getString("name").toLowerCase().trim()
                    +//username combination check
                    "." + rsStudents.getString("surname").toLowerCase().trim() + "."
                    +//name,dot,surname,dot,id
                    rsStudents.getInt("student_id");

            if (combinedusername.equals(username)) { // if a student with a metching password has the same uswename, that's our guy
                HttpSession session = request.getSession();
                session.setAttribute("name", rsStudents.getString("name") + " " + rsStudents.getString("surname"));
                session.setAttribute("id", rsStudents.getInt("student_id"));
                session.setAttribute("role", 2);// student role 2
                
                redirected = true;
                RequestDispatcher dispatcher = request.getRequestDispatcher("/student.jsp");// redirect to student.jsp
                dispatcher.forward(request, response);
            }
        }

        s = conn.prepareStatement("SELECT * FROM Parents WHERE parent_password = ?");
        s.setString(1, password);
        
        ResultSet rsParents = s.executeQuery();//checks the password first
        
        while (rsParents.next()) {
            // parents have their names stored together and split with ,
            // we want them to be able to log in individually
            String combinedusername = rsParents.getString("parent_name").toLowerCase().trim().split(",")[0]
                    + "." + rsParents.getString("parent_surname").toLowerCase().trim() + "."
                    + rsParents.getInt("parent_id");

            String combinedusername2 = rsParents.getString("parent_name").toLowerCase().trim().split(",")[1]
                    + "." + rsParents.getString("parent_surname").toLowerCase().trim() + "."
                    + rsParents.getInt("parent_id");

            if (combinedusername.equals(username)) {
                HttpSession session = request.getSession();
                session.setAttribute("name", rsParents.getString("parent_name").trim().split(",")[0] + " " + rsParents.getString("parent_surname"));
                session.setAttribute("id", rsParents.getInt("parent_id"));//left side
                session.setAttribute("role", 1);// parent role 1
                
                redirected = true;
                RequestDispatcher dispatcher = request.getRequestDispatcher("/student.jsp");
                dispatcher.forward(request, response);

            } else if (combinedusername2.equals(username)) {
                HttpSession session = request.getSession();
                session.setAttribute("name", rsParents.getString("parent_name").trim().split(",")[1] + " " + rsParents.getString("parent_surname"));
                session.setAttribute("id", rsParents.getInt("parent_id"));//right side
                session.setAttribute("role", 1);
                
                redirected = true;
                RequestDispatcher dispatcher = request.getRequestDispatcher("/student.jsp");// also redirect to student.jsp
                dispatcher.forward(request, response);
            }
        }
        s = conn.prepareStatement("SELECT * FROM Teacher WHERE teacher_password = ?");
        s.setString(1, password);
        ResultSet rsTeacher = s.executeQuery();
        
        while (rsTeacher.next()) {
            String combinedusername = rsTeacher.getString("teacher_name").toLowerCase().trim()
                    + "." + rsTeacher.getString("teacher_surname").toLowerCase().trim() + "."
                    + rsTeacher.getInt("teacher_id");//trims spaces

            if (combinedusername.equals(username)) {
                HttpSession session = request.getSession();
                session.setAttribute("name", rsTeacher.getString("teacher_name") + " " + rsTeacher.getString("teacher_surname"));
                session.setAttribute("id", rsTeacher.getInt("teacher_id"));
                session.setAttribute("role", 0);//role Teacher 0, session-teacher type
          
                redirected = true;
                RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher.jsp"); // redirect to teacher.jsp
                dispatcher.forward(request, response);
            }
        }

        if (redirected != true){
        RequestDispatcher dispatcher = request.getRequestDispatcher("/index.jsp?msg=1");
        dispatcher.forward(request, response);
        }
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
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Loginservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Loginservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            Logger.getLogger(Loginservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            Logger.getLogger(Loginservlet.class.getName()).log(Level.SEVERE, null, ex);
        }
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
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Loginservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Loginservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            Logger.getLogger(Loginservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            Logger.getLogger(Loginservlet.class.getName()).log(Level.SEVERE, null, ex);
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
