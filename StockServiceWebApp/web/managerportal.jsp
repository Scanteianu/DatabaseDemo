<%-- 
    Document   : managerportal
    Created on : Apr 27, 2016, 5:11:24 PM
    Author     : Dan
--%>

<%@page import="Data.DebugPrint"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="Data.StaticConnection"%>
<%@page import="Data.QueryMaker"%>
<%@page import="HTMLStuff.PageComponents"%>
<%@page import="Data.SessionPermission"%>
<%@page import="Data.SessionManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CDPTrade: Manager Portal</title>
          <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

<!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
   
    </head>
    <body>
        <div class="container">
         <% 
                boolean loggedIn=false;
                boolean correctPermission=false;
                String cookieValue=null;
                Cookie[] cookies = request.getCookies();
                if( cookies != null ){
                   
                   for (int i = 0; i < cookies.length; i++){
                      if(cookies[i].getName().equals("cdptradelogin")){
                          cookieValue=cookies[i].getValue();
                          if(SessionManager.checkCookie(cookieValue)){
                            loggedIn=true;
                            SessionManager.refreshSession(cookieValue);
                            if(SessionManager.getPermission(cookieValue).getLevel()<SessionPermission.manager.getLevel())
                                ;//response.sendRedirect("dashboard.jsp");
                            else 
                                correctPermission=true;
                          }
                      }
                   }
                }
                   if(loggedIn&&correctPermission){
                        if(request.getParameter("logout")!=null){
                            SessionManager.logoutSession(cookieValue);
                            response.sendRedirect("index.htm");
                            
                        }
                        else
                        {
                            out.println(PageComponents.makeManagerNavBar(SessionManager.getUserId(cookieValue)+""));
                            out.println("<p>Logged in as "+SessionManager.getUserId(cookieValue)+" permission level " +SessionManager.getPermission(cookieValue)+".</p>");
                        
                        }
                   }
              
                   else
                       response.sendRedirect("index.htm");
            %>
            <!-- Update Stock Price -->
            <div class="panel panel-primary">
                <div class="panel-heading">Update Stock Price</div>
            <div class="panel-body">
            
              <form class="form-inline" role="form" method="post">
                <div class="form-group">
                  <label for="text">Symbol:</label>
                  <input type="text" class="form-control" id="stock-symbol" name="stock-symbol">
                </div>
                <div class="form-group">
                  <label for="price">Price:</label>
                  <input type="text" class="form-control" id="price" name="price">
                  <input type="hidden" id="update-price" name="update-price" value="1">
                </div>
                <button type="submit" class="btn btn-default">Update</button>
              </form>
            </div>
          </div>
            <%
                   //handle form submission immediately after form
                   if(request.getParameter("update-price")!=null){
                       System.out.println("handled request for update.");
                       double oldPrice = QueryMaker.getPrice(StaticConnection.getDbi(), request.getParameter("stock-symbol"));
                       if(request.getParameter("stock-symbol")!=null&&request.getParameter("price")!=null&&!request.getParameter("stock-symbol").isEmpty()&&!request.getParameter("price").isEmpty()){
                           try{
                               double price=Double.parseDouble(request.getParameter("price"));
                               if(QueryMaker.updateStockPrice(StaticConnection.getDbi(), request.getParameter("stock-symbol"), (int)(price*100))) {
                                   out.println("<script>alert(\"Stock price updated!\");</script>");
                                   if(price < oldPrice){
                                       //Price fell, do a Sell check
                                       QueryMaker.sellConditionalOrders(StaticConnection.getDbi(), request.getParameter("stock-symbol"), price);
                                   }else if(price > oldPrice){
                                       //Price rose, increment the Trailing Stops
                                       String[][] results = QueryMaker.getCondOrder(StaticConnection.getDbi(), request.getParameter("stock-symbol"));
                                       for (String[] arr : results) {
                                           double diff = Double.parseDouble(arr[0]);
                                           double target = Double.parseDouble(arr[1]);
                                           if (diff >= .01 && price - diff > target + diff) {
                                               target = price - diff;
                                               QueryMaker.updateConditionalOrders(StaticConnection.getDbi(), request.getParameter("stock-symbol"), diff, target);
                                           } else if (diff < .01 && price * (1 - (diff * 100)) > target * (1- (diff * 100))) {
                                               target = price * (1- (diff * 100));
                                               QueryMaker.updateConditionalOrders(StaticConnection.getDbi(), request.getParameter("stock-symbol"), diff, target);
                                           }
                                       }
                                       //QueryMaker.updateConditionalOrders(StaticConnection.getDbi(), request.getParameter("stock-symbol"), (price-oldPrice),oldPrice);
                                   }
                               } else
                                   out.println("<script>alert(\"Update failed. Please check that you have a valid stock and stock price.\");</script>");
                           }
                           catch(NumberFormatException e){
                               out.println("<script>alert(\"Please enter a valid price.\");</script>");
                           }
                       }
                       else{
                           out.println("<script>alert(\"Make sure you enter both a stock symbol and a price.\");</script>");
                       }
                           
                   }
                   %>
             <div class="panel panel-primary">
                 <div class="panel-heading">Create Stock</div>
            <div class="panel-body">
                
              <form role="form" method="post">
                <div class="form-group">
                  <label for="text">Symbol:</label>
                  <input type="text" class="form-control" id="stock-symbol" name="stock-symbol">
                </div>
                <div class="form-group">
                  <label for="text">Company Name:</label>
                  <input type="text" class="form-control" id="stock-description" name="stock-description">
                </div>
                <div class="form-group">
                  <label for="text">Type:</label>
                  <input type="text" class="form-control" id="stock-type" name="stock-type">
                </div>
                <div class="form-group">
                  <label for="text">Number Of Shares:</label>
                  <input type="text" class="form-control" id="num-shares" name="num-shares">
                </div>
                <div class="form-group">
                  <label for="text">Price:</label>
                  <input type="text" class="form-control" id="price" name="price">
                  <input type="hidden" id="make-stock" name="make-stock" value="1">
                </div>
                <button type="submit" class="btn btn-default">Create</button>
              </form>
            </div>
          </div>
            <%
                   //handle form submission immediately after form
                   if(request.getParameter("make-stock")!=null){
                       System.out.println("handled request for update.");
                       if(request.getParameter("make-stock")!=null&&!request.getParameter("make-stock").isEmpty()
                               &&request.getParameter("num-shares")!=null&&!request.getParameter("num-shares").isEmpty()
                               &&request.getParameter("stock-type")!=null&&!request.getParameter("stock-type").isEmpty()
                               &&request.getParameter("stock-symbol")!=null&&!request.getParameter("stock-symbol").isEmpty()
                               &&request.getParameter("stock-description")!=null&&!request.getParameter("stock-description").isEmpty()
                               &&request.getParameter("price")!=null&&!request.getParameter("price").isEmpty()
                               ){
                           try{
                               double price=Double.parseDouble(request.getParameter("price"));
                               double ns=Double.parseDouble(request.getParameter("num-shares"));
                               if(QueryMaker.createStock(StaticConnection.getDbi(), request.getParameter("stock-symbol"), request.getParameter("stock-description"),request.getParameter("stock-type"),((int)(price*100)),(float)ns))
                                   out.println("<script>alert(\"Stock created!\");</script>");
                               else
                                   out.println("<script>alert(\"Stock Creation failed. Please check that you have a valid stock and stock price.\");</script>");
                           }
                           catch(NumberFormatException e){
                               out.println("<script>alert(\"Please enter a valid price and number of stocks.\");</script>");
                           }
                       }
                       else{
                           out.println("<script>alert(\"Make sure you fill out all the fields.\");</script>");
                       }
                           
                   }
                   %>
                   <hr>
                   <div class="panel panel-primary">
                       <div class="panel-heading">Transaction Filter</div>
            <div class="panel-body">
               <form class="form-inline" role="form" method="post">
                <div class="form-group">
                      <label class="radio-inline"><input type="radio" id="filter" name="filter" value="by-user" checked="checked">By Client ID</label>
              <label class="radio-inline"><input type="radio" name = "filter" id="filter" value="by-stock">By Stock Symbol</label>
              <br><br>
                  <label for="text">Filter:</label>
                  <input type="text" class="form-control" id="criteria" name="criteria">
                <input type="hidden" id="filter-trans" name="filter-trans" value="1">  
                </div>
                  

                <button type="submit" class="btn btn-default">List</button>
              </form>
            
                   <%
                   out.println("<table class=\"table\">");
                   out.println("<tr><td>Trans #</td><td>Client</td><td>Account</td><td>Type</td><td>Employee</td><td>Stock</td><td>Timestamp</td><td>Fee</td><td>Individual Share Price</td><td># Shares</td><td>Price Type</td></tr>");   
                    
                if(request.getParameter("filter-trans")!=null&&request.getParameter("criteria")!=null&&request.getParameter("filter")!=null){
                    //StaticConnection.initialize();
                    String results[][]=null;
                    if(request.getParameter("filter").equals("by-user")){
                        try{
                            results=QueryMaker.listOfOrdersByClient(StaticConnection.getDbi(),Integer.parseInt(request.getParameter("criteria")));
                    
                        }
                        catch(NumberFormatException e){
                            out.println("<script>alert(\"Invalid User Id\");</script>");
                            results=QueryMaker.listOfOrdersByClient(StaticConnection.getDbi(),0);
                        }
                    }
                    else
                     results=QueryMaker.listOfOrdersByStock(StaticConnection.getDbi(),request.getParameter("criteria"));
                    
                    for(int i=0; i<results.length; i++){
                        out.println("<tr>");
                        for(int j=0; j<results[i].length; j++){
                            out.println("<td>"+results[i][j]+"</td>");
                        }
                        out.println("</tr>");
                    }
                           
                     //out.println("<p>Logged in as "+SessionManager.getUserId(cookieValue)+" permission level " +SessionManager.getPermission(cookieValue)+".</p>");
                     //variables carry over, yay!!!     
                    }
             
                 out.println("</table>");
            %>
             </div>
          </div>
   

             <hr>
             
           <div class="panel panel-primary">
               <div class="panel-heading">Revenue Summary</div>
               <div class="panel-body">
                   <div>
               <form class="form-inline" role="form" method="post">
                <div class="form-group">
                    <%
                     SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd");
                    String date;
                     if(request.getParameter("month-date")==null)
                        date=df.format(new Date(System.currentTimeMillis()));
                     else date=request.getParameter("month-date");
                    %>
                  <label for="text">End Date of Month:</label>
                  <input type="date" class="form-control" id="month-date" value="<%out.print(date);%>" name="month-date">
                </div>
                <button type="submit" class="btn btn-default">Set Date</button>
                              

              </form> 
                   </div>
               <table class="table">
                   <tr>
                       <td>All-Time Top Employee</td>
                       <td><% out.print(QueryMaker.topEmployeeRevenue(StaticConnection.getDbi())); %></td>
                   </tr>
                   <tr>
                       <td>All-Time Top Client</td>
                       <td><% out.print(QueryMaker.topCustomerRevenue(StaticConnection.getDbi())); %></td>
                   </tr>
                  <tr>
                       <td>Month End Date</td>
                       <td><% out.print(date); %></td>
                   </tr>
                     <tr>
                       <td>Corporation Revenue For Month</td>
                       <td><% out.print(QueryMaker.corpRevenue(StaticConnection.getDbi(), date)); %></td>
                   </tr>
                   <tr>
                       <td>Corporation Revenue For Month</td>
                       <td><% out.print(QueryMaker.corpRevenue(StaticConnection.getDbi(), date)); %></td>
                   </tr>
                   
               </table>
                   Sales for month:
                   <div style="max-height:200px; overflow-y:scroll;">
                      <% out.println("<table class=\"table\">");
                      if(true){
                      String[][] results=QueryMaker.salesMonth(StaticConnection.getDbi(),date);
                      out.println("<tr><td>Trans #</td><td>Client</td><td>Account</td><td>Type</td><td>Employee</td><td>Stock</td><td>Timestamp</td><td>Fee</td><td>Individual Share Price</td><td># Shares</td><td>Price Type</td></tr>");   
                    for(int i=0; i<results.length; i++){
                        out.println("<tr>");
                        for(int j=0; j<results[i].length; j++){
                            if (results[i][j] != null) out.println("<td>"+results[i][j]+"</td>");
                            else out.println("<td>"+"0.00"+"</td>");
                        }
                        out.println("</tr>");
                    }
                            out.println("</table>");
                     //out.println("<p>Logged in as "+SessionManager.getUserId(cookieValue)+" permission level " +SessionManager.getPermission(cookieValue)+".</p>");
                     //variables carry over, yay!!!     
                    }%>
                   </div>
                
                
                <div class="panel panel-primary">
               <div class="panel-heading">Total Revenue by Client</div>
               <div class="panel-body">
                    <form class="form-inline" role="form" method="post">
                <div class="form-group">
                  
                  <label for="text">Client Id</label>
                  <input type="text" class="form-control" id="rev-client"  name="rev-client">
                </div>
                <button type="submit" class="btn btn-default">Lookup</button>
                <%
                      if(request.getParameter("rev-client")!=null){
                          try{
                              out.println("<br><h3>"+QueryMaker.revenueClient(StaticConnection.getDbi(),Integer.parseInt(request.getParameter("rev-client")))+"</h3>");
                          }
                          catch(NumberFormatException e){
                              out.println("<script>alert(\"Please enter a valid client id.\");</script>");
                           
                          }
                      }
                %>

              </form>   
               </div>
           </div>
          <div class="panel panel-primary">
               <div class="panel-heading">Total Revenue by Stock</div>
               <div class="panel-body">
                    <form class="form-inline" role="form" method="post">
                <div class="form-group">
                  
                  <label for="text">Stock Symbol</label>
                  <input type="text" class="form-control" id="rev-stock"  name="rev-stock">
                </div>
                <button type="submit" class="btn btn-default">Lookup</button>
                <%
                      if(request.getParameter("rev-stock")!=null){
                         if(-1!=QueryMaker.revenueStock(StaticConnection.getDbi(),request.getParameter("rev-stock")))
                          out.println("<br><h3>"+QueryMaker.revenueStock(StaticConnection.getDbi(),request.getParameter("rev-stock"))+"</h3>");
                         else 
                             out.println("<br> Unrecognized Symbol:"+request.getParameter("rev-symbol"));
                      
                      }
                %>

              </form>   
               </div>
           </div>
           
           <div class="panel panel-primary">
               <div class="panel-heading">Total Revenue by Stock Type</div>
               <div class="panel-body">
                    <form class="form-inline" role="form" method="post">
                <div class="form-group">
                  
                  <label for="text">Stock Type</label>
                  <input type="text" class="form-control" id="rev-type"  name="rev-type">
                </div>
                <button type="submit" class="btn btn-default">Lookup</button>
                <%
                      if(request.getParameter("rev-type")!=null){
                         if(-1!=QueryMaker.revenueStockType(StaticConnection.getDbi(),request.getParameter("rev-type")))
                          out.println("<br><h3>"+QueryMaker.revenueStockType(StaticConnection.getDbi(),request.getParameter("rev-type"))+"</h3>");
                         else 
                             out.println("<br> Unrecognized Type:"+request.getParameter("rev-type"));
                      }
                %>

              </form>   
               </div>
           </div>
                
               </div>
           </div>
           
        <div class="panel panel-primary">
               <div class="panel-heading">Stocks by Number of Transactions</div>
               <div class="panel-body">
               <div style="max-height:200px; overflow-y:scroll;">
                      <% out.println("<table class=\"table\">");
                      if(true){
                      String[][] results=QueryMaker.mostTradedStocks(StaticConnection.getDbi());
                      out.println("<tr><td>StockId</td><td>Number of Transactions</td></tr>");   
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
                    }%>
                   </div> 
               </div>
           </div>   
        </div>
    </body>
</html>
