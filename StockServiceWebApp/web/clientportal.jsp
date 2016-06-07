<%-- 
    Document   : clientportal
    Created on : May 2, 2016, 5:01:56 PM
    Author     : Dan
--%>

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
        <title>CDPTrade: Client Portal</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

<!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
   
    </head>
    <body>
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
                            if(SessionManager.getPermission(cookieValue).getLevel()!=SessionPermission.client.getLevel())
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
                            out.println(PageComponents.makeClientNavBar(SessionManager.getUserId(cookieValue)+""));
                                out.println("<p>Logged in as "+SessionManager.getUserId(cookieValue)+" permission level " +SessionManager.getPermission(cookieValue)+".</p>");
                               
                        }
                   }
              
                   else
                       response.sendRedirect("index.htm");
                   
                   /**
                    * A customer's current stock holdings
                        The share-price and trailing-stop history for a given conditional order
                        The share-price and hidden-stop history for a given conditional order
                        The share-price history of a given stock over a certain period of time (e.g., past six months)
                        OK A history of all current and past orders a customer has placed
                        Stocks available of a particular type and most-recent order info
                        Stocks available with a particular keyword or set of keywords in the stock name, and most-recent order info
                        OK Best-Seller list of stocks
                        Personalized stock suggestion list
                    */
            %>
             <div class="panel panel-primary"><div class="panel-heading">Your Stocks</div>
               <div class="panel-body">
               <div style="max-height:200px; overflow-y:scroll;">
                      <% out.println("<table class=\"table\">");
                      if(true){
                      String[][] results=QueryMaker.stockHoldings(StaticConnection.getDbi(),SessionManager.getUserId(cookieValue));
                      out.println("<tr><td>StockId</td><td>Number of Shares</td><td>Account Number</td></tr>");   
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
                   <div class="panel panel-primary">
                <div class="panel-heading">Your Current Conditional Orders</div>
            <div class="panel-body">
                <div style="max-height:200px; overflow-y:scroll;">
                      <% out.println("<table class=\"table\">");
                      if(true){
                      String[][] results=QueryMaker.listOfConditionalOrders(StaticConnection.getDbi(),SessionManager.getUserId(cookieValue));
                      out.println("<tr><td>StockId</td><td>Number of Stock</td><td>Price Type</td><td>Target</td><td>Difference</td><td>Employee Id</td><td>Order Time</td></tr>");   
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
        <div class="panel panel-primary">
                <div class="panel-heading">View History of a Conditional Order</div>
            <div class="panel-body">
            
              <form class="form-inline" role="form" method="post">
                <div>
                  <div class="form-group">
                    
                  <label for="text">Symbol:</label>
                  <input type="text" class="form-control" id="stock-symbol" name="stock-symbol">
                  <label for="text">Number of Stocks:</label>
                  <input type="text" class="form-control" id="end-date"  name="stock-num">
                  <label for="text">Account Number:</label>
                  <input type="text" class="form-control" id="acc"  name="acc">
                  <label for="text">Difference:</label>
                  <input type="text" class="form-control" id="dif"  name="dif">
                  <div>
                    <label for="text">Price Type:</label>
                    <label class="radio-inline"><input type="radio" id="priceType" name="priceType" value="hidestop" onclick="hidePrice(false)">Hidden Stop</label>
                    <label class="radio-inline"><input type="radio" id="priceType" name="priceType" value="trailstop" onclick="hidePrice(false)">Trailing Stop</label>
                  </div>
                  <input type="hidden" id="c-hist" name="c-hist" value="1">
                    <label for="text">Order Time:</label>
                    <input type="text" class="form-control" id="orderTime"  name="orderTime">
                  </div>
                    </div>
                <button type="submit" class="btn btn-default">Look Up</button>
              </form>
             
             <% /**
                      if(request.getParameter("c-hist")!=null){
                          out.println("<table class=\"table\">");
                          //int sellerID, int accountNum, int employeeID, String stockID, String priceType, double numStocks, double dif,String orderTime
                          int accountNum = Integer.parseInt(request.getParameter("acc"));
                          String stockID = request.getParameter("stock-symbol");
                          String priceType = request.getParameter("priceType");
                          double Difference = Double.parseDouble("dif");
                          int numStocks = Integer.parseInt(request.getParameter("stock-num"));
                          String orderTime = request.getParameter("orderTime");
                          //sellerId, accountNum,stockId ,numStocks,stockPrice, target,difference,priceType,orderTime,updateTime
                          String[][] results=QueryMaker.conditionalOrderHistory(StaticConnection.getDbi(), SessionManager.getUserId(cookieValue),accountNum, stockID, numStocks,Difference,priceType, orderTime);
                      out.println("<tr> <td>Stock</td> <td>Amount of Shares</td> <td>Stock Price</td> <td>Target Price</td> <td>Difference</td> <td>Price type</td> <td>Update Time</td></tr>");   
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
                    }
             */%>
            </div>
          </div>
             <div class="panel panel-primary"><div class="panel-heading">Your Transaction History</div>
               <div class="panel-body">
               <div style="max-height:200px; overflow-y:scroll;">
                      <% out.println("<table class=\"table\">");
                      if(true){
                      String[][] results=QueryMaker.transactionHistory(StaticConnection.getDbi(),SessionManager.getUserId(cookieValue));
                     out.println("<tr><td>Trans #</td><td>Account</td><td>Type</td><td>Employee Id</td><td>Stock</td><td>Timestamp</td><td>Fee</td><td>Individual Share Price</td><td># Shares</td><td>Price Type</td></tr>");   
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
               
            <div class="panel panel-primary">
               <div class="panel-heading">Best Selling Stocks</div>
               <div class="panel-body">
               <div style="max-height:200px; overflow-y:scroll;">
                      <% out.println("<table class=\"table\">");
                      if(true){
                      String[][] results=QueryMaker.bestSellingStocks(StaticConnection.getDbi());
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
           <div class="panel panel-primary">
               <div class="panel-heading">May we suggest...</div>
               <div class="panel-body">
               <div style="max-height:200px; overflow-y:scroll;">
                      <% out.println("<table class=\"table\">");
                      if(true){
                      String[][] results=QueryMaker.getSuggestions(StaticConnection.getDbi(),SessionManager.getUserId(cookieValue));
                      out.println("<tr><td>StockId</td></tr>");   
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
                   
    <div class="panel panel-primary">
                <div class="panel-heading">Stock Price History</div>
            <div class="panel-body">
            
              <form class="form-inline" role="form" method="post">
                <div class="form-group">
                  <label for="text">Symbol:</label>
                  <input type="text" class="form-control" id="stock-symbol" name="stock-symbol">
                  <label for="text">Start Date:</label>
                  <input type="date" class="form-control" id="start-date"  name="start-date">
                  <label for="text">End Date:</label>
                  <input type="date" class="form-control" id="end-date"  name="end-date">
                
                  <input type="hidden" id="p-hist" name="p-hist" value="1">
                </div>
                <button type="submit" class="btn btn-default">Look Up</button>
              </form>
             <% out.println("<table class=\"table\">");
                      if(request.getParameter("p-hist")!=null){
                      String[][] results=QueryMaker.stockPriceHistory(StaticConnection.getDbi(),request.getParameter("stock-symbol"),request.getParameter("start-date"),request.getParameter("end-date"));
                      out.println("<tr><td>Price</td><td>Date</td></tr>");   
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
    </body>
</html>
