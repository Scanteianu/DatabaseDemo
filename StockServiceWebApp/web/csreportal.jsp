<%-- 
    Document   : csreportal
    Created on : May 2, 2016, 5:01:37 PM
    Author     : Dan
--%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="Data.InsufficientStockException"%>
<%@page import="Data.StaticConnection"%>
<%@page import="Data.QueryMaker"%>
<%@page import="HTMLStuff.PageComponents"%>
<%@page import="Data.SessionManager"%>
<%@page import="Data.SessionPermission"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CDPTrade: Employee Portal</title>
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
                            if(SessionManager.getPermission(cookieValue).getLevel()<SessionPermission.employee.getLevel())
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
                            if(SessionManager.getPermission(cookieValue).getLevel()==SessionPermission.employee.getLevel()){
                                out.println(PageComponents.makeCSRepNavBar(SessionManager.getUserId(cookieValue)+""));
                                out.println("<p>Logged in as "+SessionManager.getUserId(cookieValue)+" permission level " +SessionManager.getPermission(cookieValue)+".</p>");
                               
                            }
                            else{
                                out.println(PageComponents.makeManagerNavBar(SessionManager.getUserId(cookieValue)+""));
                                out.println("<p>Logged in as "+SessionManager.getUserId(cookieValue)+" permission level " +SessionManager.getPermission(cookieValue)+".</p>");
                            }
                        }
                   }
              
                   else
                       response.sendRedirect("index.htm");
            %>
            <div class="panel panel-primary">
                <div class="panel-heading">Create Transaction</div>
            <div class="panel-body">
            
              <form class="form" role="form" method="post">
                    <label class="radio-inline"><input type="radio" id="buysell" name="buysell" value="buy" checked="checked">Buy</label>
              <label class="radio-inline"><input type="radio" name = "buysell" id="buysell" value="sell">Sell</label>
               <div class="form-group">
                  <label for="text">Client Id:</label>
                  <input type="text" class="form-control" id="client-id" name="client-id">
                </div>
              <div class="form-group">
                  <label for="text">Account Number:</label>
                  <input type="text" class="form-control" id="acc-num" name="acc-num">
                </div>
                <div class="form-group">
                  <label for="text">Symbol:</label>
                  <input type="text" class="form-control" id="stock-symbol" name="stock-symbol">
                </div>
                <div class="form-group">
                  <label for="text">Number Of Stocks:</label>
                  <input type="text" class="form-control" id="num-stocks" name="num-stocks">
                  <input type="hidden" id="transaction" name="transaction" value="1">
                </div>
                <div class="form-group">
                  <label for="text">Transaction Fee:</label>
                  <input type="text" class="form-control" id="t-fee" name="t-fee" value="5">
                </div>
                <button type="submit" class="btn btn-default">Execute</button>
              </form>
            </div>
          </div>
            <%
                   if(request.getParameter("transaction")!=null){
                       try{
                           double ns=Double.parseDouble(request.getParameter("num-stocks"));
                           double tf=Double.parseDouble(request.getParameter("t-fee"));
                           int clientid=Integer.parseInt(request.getParameter("client-id"));
                           int acc = Integer.parseInt(request.getParameter("acc-num"));
                           if(request.getParameter("buysell").equals("buy")){
                               if(QueryMaker.buy(StaticConnection.getDbi(), clientid, acc, request.getParameter("stock-symbol"), ns, SessionManager.getUserId(cookieValue), tf)){
                                   out.println("<script>alert(\"Purchase Completed\");</script>");
                            
                               }
                               else
                                    out.println("<script>alert(\"Purchase Failed. Check that Stock Symbol is valid and all fields are filled out.\");</script>");
                           }
                           else{
                           try{
                               if(QueryMaker.sell(StaticConnection.getDbi(), clientid, acc, request.getParameter("stock-symbol"), ns, SessionManager.getUserId(cookieValue), tf,"mkt")){
                                   out.println("<script>alert(\"Stock Selling Completed\");</script>");
                            
                               }
                               else
                                    out.println("<script>alert(\"Stock Selling Failed. Insufficient Stock.\");</script>");
                          
                           }
                           catch(InsufficientStockException e){
                               out.println("<script>alert(\"The client doesn't have enough stock to sell.\");</script>");
                          
                           }
                           }
                       }
                       catch(NumberFormatException e){
                            out.println("<script>alert(\"Purchase Failed. Check that all fields except stock symbol are numeric.\");</script>");
                           
                       }
                   }
            %>
</script>
    <div class="panel panel-primary">
                <div class="panel-heading">Create Conditional Order</div>
            <div class="panel-body">
            
              <form class="form" role="form" method="post">
                  <div><label class="radio-inline"><input type="radio" id="priceType" name="priceType" value="sellmktonclose" onclick="hidePrice(true)">Sell on Market Closed</label></div>
                  <div><label class="radio-inline"><input type="radio" id="priceType" name="priceType" value="buymktonclose" onclick="hidePrice(true)">Buy on Market Closed</label></div>
                  <div><label class="radio-inline"><input type="radio" id="priceType" name="priceType" value="hidestop" onclick="hidePrice(false)">Hidden Stop</label></div>
                  <div><label class="radio-inline"><input type="radio" id="priceType" name="priceType" value="trailstop" onclick="hidePrice(false)">Trailing Stop</label></div>
              <div class="form-group">
                  <label for="text">Client Id:</label>
                  <input type="text" class="form-control" id="client-id" name="client-id">
                </div>
              <div class="form-group">
                  <label for="text">Account Number:</label>
                  <input type="text" class="form-control" id="acc-num" name="acc-num">
                </div>
                <div class="form-group">
                  <label for="text">Symbol:</label>
                  <input type="text" class="form-control" id="stock-symbol" name="stock-symbol">
                </div>
                <div class="form-group">
                  <label for="text">Number Of Stocks:</label>
                  <input type="text" class="form-control" id="num-stocks" name="num-stocks">
                  <input type="hidden" id="transaction" name="CO" value="1">
                </div>
                <div class="form-group" id="sellPrice">
                  <label for="text">Sell Price:</label>
                  <input type="text" class="form-control" id="sellPrice" name="sellPrice" value="0">
                  <input type="checkbox" id="percent" name="percent">Percent
                </div>
                <button type="submit" class="btn btn-default">Place Order</button>
              </form>
            </div>
          </div>
            <%     
                   if(request.getParameter("CO")!=null){
                        try{
                           //String priceType = request.getParameter("priceType");
                           int clientid=Integer.parseInt(request.getParameter("client-id"));
                           int acc= Integer.parseInt(request.getParameter("acc-num"));
                           double ns=Double.parseDouble(request.getParameter("num-stocks"));
                           double sp=Double.parseDouble(request.getParameter("sellPrice"));
                           double origPrice= QueryMaker.getPrice(StaticConnection.getDbi(), request.getParameter("stock-symbol"));
                           double target = origPrice - sp;
                           if (request.getParameter("percent") != null && request.getParameter("percent").equals("on")) {
                               sp /= 10000;
                               target = origPrice * (1 - (sp * 100));
                           }
                           QueryMaker.placeConditionalOrder(StaticConnection.getDbi(), clientid,acc, SessionManager.getUserId(cookieValue), request.getParameter("stock-symbol"), request.getParameter("priceType"), sp, ns, target);
                               
                       }
                       catch(NumberFormatException e){
                            out.println("<script>alert(\"Order Placing Failed. Check that all fields except stock symbol are numeric.\");</script>");
                           
                       }
                    }
            %>
    <div class="panel panel-primary">
               <div class="panel-heading">Manual Stock Suggestion</div>
               <div class="panel-body">
               
                    <form class="form-inline" role="form" method="post">
                <div class="form-group">
                  <label for="text">Symbol:</label>
                  <input type="text" class="form-control" id="stock-symbol" name="stock-symbol">
                </div>
                <div class="form-group">
                  <label for="price">Client Id:</label>
                  <input type="text" class="form-control" id="c-id" name="c-id">
                  <input type="hidden" id="manual" name="manual" value="1">
                </div>
                <button type="submit" class="btn btn-default">Suggest</button>
                    </form>
                   
               </div>
           </div>
            <%
                   //handle form submission immediately after form
                   if(request.getParameter("manual")!=null){
                       System.out.println("handled request for update.");
                       if(request.getParameter("c-id")!=null&&request.getParameter("stock-symbol")!=null&&!request.getParameter("stock-symbol").isEmpty()&&!request.getParameter("c-id").isEmpty()){
                           try{
                               int uid=Integer.parseInt(request.getParameter("c-id"));
                               if(QueryMaker.manualSuggestion(StaticConnection.getDbi(), uid, request.getParameter("stock-symbol")))
                                   out.println("<script>alert(\"Suggestion Completed!\");</script>");
                               else
                                   out.println("<script>alert(\"Suggestion could not be completed. It may be a duplicate or the Client/Stock Id may not exist.\");</script>");
                           }
                           catch(NumberFormatException e){
                               out.println("<script>alert(\"Please enter a valid client id.\");</script>");
                           }
                       }
                       else{
                           out.println("<script>alert(\"Make sure you enter both a stock symbol and a client id.\");</script>");
                       }
                           
                   }
                   %>
                   <div class="panel panel-primary">
            <div class="panel-heading">Look up an employee's data</div>
            <div class="panel-body" style="overflow-y: scroll;">
                <form class="form-inline" role="form" method="POST">
                    <input type="hidden" id="lookup" name="lookup" value="1">
                    <fieldset class="form-group">
                        <label for="idNum">ID # to look up:</label>
                        <input type="number" class="form-control" id="idNum" name="idNum">
                    </fieldset>
                    <button type="submit" class="btn btn-primary">Find</button>
                </form>
                <br>
                <p id="target"></p>
                <%
                    if (request.getParameter("lookup") != null) {
                        try {
                            int idNum = Integer.parseInt(request.getParameter("idNum"));
                            String[][] results = QueryMaker.searchEmployeeView(StaticConnection.getDbi(), idNum);
                            if (results.length == 0) {
                                out.println("<script>alert('ID not found.')</script>");
                            } else {
                                String[] arr = results[0];
                                String[] atts = {"ID: ", "Last Name: ", "First Name: ", "Address: ", "City: ",
                                "State: ", "Zip Code: ", "Phone Number: ", "SSN: ", "Starting Date: ", "FAIL", "Status: "};
                                String javascript = "<script>document.getElementById('target').innerHTML = '";
                                for (int i = 0; i < arr.length; i++) {
                                    String str = arr[i];
                                    Pattern p = Pattern.compile("\\.\\d\\d$");
                                    Matcher m = p.matcher(str);
                                    if (!m.find()) {
                                        javascript += atts[i] + str + "<br>";
                                    }
                                }
                                javascript += "';</script>";
                                out.println(javascript);
                            }
                            
                        } catch (NumberFormatException nfe) {
                            out.println("<script>alert('You entered an invalid number in the field.');</script>");
                        }
                    }
                %>
            </div>
            </div>
            <div class="panel panel-primary">
            <div class="panel-heading">Generate Mailing List</div>
            <div class="panel-body" style="overflow-y: scroll;">
            <form method="POST">
                <input type="hidden" id="mail" name="mail" value="1">
                <br>
                <button type="submit" class="btn btn-primary">Generate Mailing List</button>
            </form>
            <br>
            <p id="mailTarget"></p>
            <%
                if (request.getParameter("mail") != null) {
                    String javascript = "<script>document.getElementById('mailTarget').innerHTML = '";
                    String[][] results = QueryMaker.generateCustomerMailingList(StaticConnection.getDbi());
                    if (results.length == 0) {
                        out.println("<script>alert('No customers found...);");
                    } else {
                        for (int i = 0; i < results.length; i++) {
                            String str = results[i][0];
                            if (i == results.length - 1) {
                                javascript += str;
                            } else {
                                javascript += str + ",<br>";
                            }
                        }
                        javascript += "';</script>";
                        out.println(javascript);
                    }
                }
            %>
            </div>
            </div>
        </div>
    </body>
</html>
