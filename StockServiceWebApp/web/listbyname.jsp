<%@page import="HTMLStuff.PageComponents"%>
<%@page import="Data.SessionManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Data.QueryMaker"%>
<%@page import="Data.StaticConnection"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CDP: List Transactions by Stock Name</title>
          <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

<!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
   
    </head>

    <body>
       
        
        <p>
        
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
                            out.println(PageComponents.makeUserNavBar(SessionManager.getUserId(cookieValue)+""));
                          }
                      }
                   }
                }
                 out.println("<p>This is the page where you select to see somebody's stock holdings.</p>");
                   if(loggedIn){
                       out.println("<table class=\"table\">");
                if(request.getParameter("stock")!=null)
                {
                StaticConnection.initialize();
                String results[][] =QueryMaker.listOfOrdersByStock(StaticConnection.getDbi(),request.getParameter("stock"));
                for(int i=0; i<results.length; i++){
                    out.println("<tr>");
                    for(int j=0; j<results[i].length; j++){
                        out.println("<td>"+results[i][j]+"</td>");
                    }
                    out.println("</tr>");
                }
                        out.println("</table>");

                }
                else
                    out.println("No stock selected");
                   }
                   else
                       out.println("<td><tr>Not logged in!</td></tr>");
            %>
            
            <form action="listbyname.jsp" method="post">
            Stock Id: <input type="text" name="stock"><br>
      
      <input type="submit" value="Submit">

        <p><i>To display a different welcome page for this project, modify</i>
             </form>
  
    </body>
</html>
