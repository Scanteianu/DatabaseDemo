<%-- 
    Document   : dashboard
    Created on : Apr 17, 2016, 4:47:09 PM
    Author     : Dan
--%>

<%@page import="HTMLStuff.PageComponents"%>
<%@page import="Data.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CDPTrade: Dashboard</title>
           <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

<!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
    <link rel="stylesheet" href="main.css">

    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
   
    </head>
    <body>
        <div class="container">
        <% 
                boolean loggedIn=false;
                String cookieValue=null;
                SessionPermission permission=null;
                Cookie[] cookies = request.getCookies();
                if( cookies != null ){
                   
                   for (int i = 0; i < cookies.length; i++){
                      if(cookies[i].getName().equals("cdptradelogin")){
                          cookieValue=cookies[i].getValue();
                          if(SessionManager.checkCookie(cookieValue)){
                            loggedIn=true;
                            SessionManager.refreshSession(cookieValue);
                            permission=SessionManager.getPermission(cookieValue);
                          }
                      }
                   }
                }
                   if(loggedIn){
                       if(permission==SessionPermission.manager)
                           out.println(PageComponents.makeManagerNavBar(SessionManager.getUserId(cookieValue)+""));
                       else if(permission==SessionPermission.employee)
                        out.println(PageComponents.makeCSRepNavBar(SessionManager.getUserId(cookieValue)+""));
                       else
                           out.println(PageComponents.makeClientNavBar(SessionManager.getUserId(cookieValue)+""));
                   out.println("<p>Logged in as "+SessionManager.getUserId(cookieValue)+" permission level " +SessionManager.getPermission(cookieValue)+".</p>");
                        if(request.getParameter("logout")!=null){
                            SessionManager.logoutSession(cookieValue);
                            response.sendRedirect("index.htm");
                        }
                        
                   }
              
                   else
                       response.sendRedirect("index.htm");
            %>
        <div class="panel panel-primary">
        <div class="panel-heading">Current Stock Prices</div>
        <div class="panel-body" style="max-height: 350px; overflow-y: scroll;">
            <%
                   out.println("<table class=\"table\">");
                   out.print("<tr><td>Symbol</td><td>Name</td><td>Type</td>");
                   out.println("<td>Price</td><td>Shares</td></tr>");
                
                StaticConnection.initialize();
                String results[][] =QueryMaker.listOfStocks(StaticConnection.getDbi());
                for(int i=0; i<results.length; i++){
                    out.println("<tr>");
                    for(int j=0; j<results[i].length; j++){
                        out.println("<td>"+results[i][j]+"</td>");
                    }
                    out.println("</tr>");
                }
                        out.println("</table>");
                 //out.println("<p>Logged in as "+SessionManager.getUserId(cookieValue)+" permission level " +SessionManager.getPermission(cookieValue)+".</p>");
                 //variables carry over, yay!!!     
                
                   
            %>
        </div>
      </div>
    </div>
       <!--    <p>Please visit <a href="listbyname.jsp">the interactive transaction filter.</a></p> -->
    </body>
</html>
