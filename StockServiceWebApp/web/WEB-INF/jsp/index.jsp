<%@page import="HTMLStuff.PageComponents"%>
<%@page import="Data.SessionManager"%>
<%@page import="Data.QueryMaker"%>
<%@page import="Data.StaticConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<html>
    
    <head>
          <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CDP Trade Login</title>
           <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

<!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
   
    </head>

    <body>
        <div class="container">
        <%
            out.println(PageComponents.makeLoginNavBar());
        %>
        <p style="padding-left: 10px;">Welcome to CDP Trade. Please login below.</p>
       
        <!--<form>
            Username: <input type="text" name="user"><br>
            Password: <input type="password" name="password">
            <input type="submit" value="Login">
        </form> -->
        <div class="container-fluid">
        <form class="form-signin " method="POST">
        <h2 class="form-signin-heading">Please sign in</h2>
        <label for="user" class="sr-only">User Id</label>
        <input type="text" id="user" class="form-control" name="user" placeholder="Your user id" required autofocus>
        <label for="password" class="sr-only">Password</label>
        <input type="password" id="password" name="password" class="form-control" placeholder="Password" required>
        <button class="btn btn-lg btn-primary btn-block" type="submit" value="Login">Sign in</button>
      </form>
         </div>
        
            <%
                /*
                out.println("<table>");
                StaticConnection.initialize();
                String results[][] =QueryMaker.listOfOrdersByStock(StaticConnection.getDbi(), "DAN");
                for(int i=0; i<results.length; i++){
                    out.println("<tr>");
                    for(int j=0; j<results[i].length; j++){
                        out.println("<td>"+results[i][j]+"</td>");
                    }
                    out.println("</tr>");
                }
                 out.println("</table>");
                        */
            %>

        
        <%
                boolean loggedIn=false;
                String cookieValue=null;
                Cookie[] cookies = request.getCookies();
                if( cookies != null ){
                   
                   for (int i = 0; i < cookies.length; i++){
                      if(cookies[i].getName().equals("cdptradelogin")){
                          cookieValue=cookies[i].getValue();
                          if(SessionManager.checkCookie(cookieValue)){
                            loggedIn=true;
                            SessionManager.refreshSession(cookieValue);
                            response.sendRedirect("dashboard.jsp");
                          }
                      }
                   }
                }
                if(!loggedIn&&request.getParameter("user")!=null)
                {
                    if(request.getParameter("password")!=null){
                        //out.println("uname: "+request.getParameter("user"));
                        //out.println("pwd: "+request.getParameter("password"));
                        //generate a better cookie
                        try{int userName=Integer.parseInt(request.getParameter("user"));
                        String cookieVal=SessionManager.createSession(userName, request.getParameter("password"));
                        if(cookieVal!=null){
                            Cookie loginCookie = new Cookie("cdptradelogin",cookieVal);
                        loginCookie.setHttpOnly(true);
                        loginCookie.setMaxAge(60*60*8);//maximum 8 hr session
                        response.addCookie(loginCookie);
                        response.sendRedirect("dashboard.jsp");
                        }
                        else{
                            out.println("<script>alert(\"Unable to login, check your login details\");</script>");
                        }
                        
                       
                        }
                         catch (Exception ex){
                                out.println("<script>alert(\"Unable to login, check your login details\");</script>");
                                }
                        
                        
                    }
                    
                }
                //else
                  //  out.println("<script>alert(\"Unable to login, check your login details\");</script>");
            %>
        </div>
    </body>
</html>
