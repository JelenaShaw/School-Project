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
@WebServlet(name = "Inputservlet", urlPatterns = {"/Inputservlet"})
public class Inputservlet extends HttpServlet {

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
            throws ServletException, IOException, ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException {

        String type = request.getParameter("type");// what we need to add to DB i.e. test, report

        Class.forName("com.mysql.jdbc.Driver").newInstance();//finding driver by its name

        Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/School", "root", "london020");
        PreparedStatement s = conn.prepareStatement("");

        if (type.equals("report")) {
            s = conn.prepareStatement("insert into Reports (term_id,effort, achievement,description,subject_id,student_id) values (?,?,?,?,?,?)");
            s.setInt(1,Integer.parseInt(request.getParameter("term_id")));
            s.setString(2, request.getParameter("effort"));
            s.setString(3,request.getParameter("achievement"));
            s.setString(4, request.getParameter("description") + "<hr>" + request.getParameter("description2") + "<hr>"
                    + request.getParameter("description3"));
            s.setInt(5, Integer.parseInt(request.getParameter("subject_id")));
            s.setInt(6, Integer.parseInt(request.getParameter("student_id")));
            s.execute();//it does not return ResultSet, it updates DB

            HttpSession session = request.getSession();
            session.setAttribute("ids", request.getParameter("student_id"));

            RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher_studentdetails.jsp");
            dispatcher.forward(request, response);

        } else if (type.equals("mex")) {
            s = conn.prepareStatement("insert into Mock_Exams (student_id, subject_id, grade, week_id) values (?,?,?,?)");
            s.setInt(1, Integer.parseInt(request.getParameter("student_id")));
            s.setInt(2, Integer.parseInt(request.getParameter("subject_id")));
            s.setString(3,request.getParameter("grade"));
            s.setInt(4, Integer.parseInt(request.getParameter("week_id")));
            s.execute();

            HttpSession session = request.getSession();
            session.setAttribute("ids", request.getParameter("student_id"));

            RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher_studentdetails.jsp");
            dispatcher.forward(request, response);

        } else if (type.equals("tests")) {
            s = conn.prepareStatement("insert into Tests (student_id, subject_id, result, week_id) values (?,?,?,?)");
            s.setInt(1, Integer.parseInt(request.getParameter("student_id")));
            s.setInt(2, Integer.parseInt(request.getParameter("subject_id")));
            s.setString(3, request.getParameter("result"));
            s.setInt(4, Integer.parseInt(request.getParameter("week_id")));
            s.execute();/*"insert into Tests (student_id, subject_id, result, week_id) values"
                    + " (" + request.getParameter("student_id") + "," + request.getParameter("subject_id") + ",'" + request.getParameter("result") + "',"
                    + request.getParameter("week_id") + ")");*/
            HttpSession session = request.getSession();
            session.setAttribute("ids", request.getParameter("student_id"));

            RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher_studentdetails.jsp");
            dispatcher.forward(request, response);

        } else if (type.equals("result")) {

            String points = request.getParameter("points");//number of points
            int test_id = Integer.parseInt(request.getParameter("test_id"));//id of the test in DB to add points
            s = conn.prepareStatement("UPDATE Tests SET result = ? WHERE test_id = ?");
            s.setString(1, points);
            s.setInt(2, test_id);
           
            s.execute();

            HttpSession session = request.getSession();
            session.setAttribute("ids", request.getParameter("student_id"));

            RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher_studentdetails.jsp");
            dispatcher.forward(request, response);
        } else if (type.equals("overall")){
            
            int term_id = Integer.parseInt(request.getParameter("term"));
            String description = request.getParameter("description");
            String description2 = request.getParameter("description2");
            int student_id = Integer.parseInt(request.getParameter("student_id"));
            s = conn.prepareStatement("INSERT into Overall_Reports (student_id, description, term_id) values (?,?,?)");
            s.setInt(1, term_id);
            s.setInt(2, student_id);
            s.setString(3, description + "<hr>" + description2);
            s.execute();
            HttpSession session = request.getSession();
            session.setAttribute("ids", request.getParameter("student_id"));

            RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher_studentdetails.jsp");
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
            Logger.getLogger(Inputservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            Logger.getLogger(Inputservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            Logger.getLogger(Inputservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Inputservlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(Inputservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            Logger.getLogger(Inputservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            Logger.getLogger(Inputservlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Inputservlet.class.getName()).log(Level.SEVERE, null, ex);
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
