<%-- 
    Document   : manageclients
    Created on : May 2, 2016, 4:59:25 PM
    Author     : Dan
--%>
<%@page import="Data.QueryMaker"%>
<%@page import="Data.StaticConnection"%>
<%@page import="HTMLStuff.PageComponents"%>
<%@page import="Data.SessionPermission"%>
<%@page import="Data.SessionManager"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CDPTrade: Manage Clients</title>
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
        <div class="panel panel-primary ">
            <div class="panel-heading">Add a Customer</div>
            <div class="panel-body" style="overflow-y: scroll;">
                <form role="form" method="POST">
                    <input type="hidden" id="add-user" name="add-user" value="1">
                    <fieldset class="form-group">
                        <label for="idNumi">Set ID Number to:</label>
                        <input type="number" class ="form-control" id="idNumi" name="idNumi" placeholder="Enter ID">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="firstNamei">Set First Name to:</label>
                        <input type="text" class="form-control" id="firstNamei" name="firstNamei">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="lastNamei">Set Last Name to:</label>
                        <input type="text" class="form-control" id="lastNamei" name="lastNamei">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="addressi">Set Address to:</label>
                        <input type="text" class="form-control" id="addressi" name="addressi">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="cityi">Set City to:</label>
                        <input type="text" class="form-control" id="cityi" name="cityi">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="statei">Set State to:</label>
                        <input type="text" class="form-control" id="statei" name="statei" placeholder="NY">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="zipCodei">Set Zip Code to:</label>
                        <input type="text" class="form-control" id="zipCodei" name="zipCodei" placeholder="11790">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="phonei">Set Phone Number to:</label>
                        <input type="tel" class="form-control" id="phonei" name="phonei" placeholder="##########">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="emaili">Set Email to:</label>
                        <input type="email" class="form-control" id="emaili" name="emaili" placeholder="test@example.com">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="ccNumi">Set Credit Card Number to:</label>
                        <input type="number" class="form-control" id="ccNumi" name="ccNumi" placeholder="################">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="ratingi">Set rating number:</label>
                        <input type="number" class ="form-control" id="ratingi" name="ratingi" placeholder="Rating">
                    </fieldset>
                    <button type="submit" class="btn btn-primary">Submit</button>
                </form>
                <%
                    if (request.getParameter("add-user") != null) {
                        try {
                            int idNum = Integer.parseInt(request.getParameter("idNumi"));
                            String firstName = request.getParameter("firstNamei");
                            String lastName = request.getParameter("lastNamei");
                            String address = request.getParameter("addressi");
                            String city = request.getParameter("cityi");
                            String state = request.getParameter("statei");
                            int zipCode = Integer.parseInt(request.getParameter("zipCodei"));
                            long phone = Long.parseLong(request.getParameter("phonei"));
                            String email = request.getParameter("emaili");
                            long ccNum = Long.parseLong(request.getParameter("ccNumi"));
                            int rating = Integer.parseInt(request.getParameter("ratingi"));
                            if (QueryMaker.addCustomer(StaticConnection.getDbi(), idNum, lastName, firstName, address, city, state, zipCode, phone, email, ccNum, rating)) {
                                out.println("<script>alert('User added.');</script>");
                            } else {
                                out.println("<script>alert('Add failed. Make sure the ID isn't in use already and all fields have valid info.');</script>");
                            }
                        } catch (NumberFormatException nfe) {
                            System.out.println(nfe.getMessage());
                            out.println("<script>alert('You entered an invalid number in a field.');</script>");
                        }
                    }
                %>
            </div>
        </div>
        <div class="panel panel-primary ">
            <div class="panel-heading">Update Customer Information</div>
            <div class="panel-body" style="overflow-y: scroll;">
                <form class="form-inline" role="form" method="POST">
                    <input type="hidden" id="getData" name="getData" value="1">
                    <fieldset class="form-group">
                        <label for="searchId">Get data for User #:</label>
                        <input type="number" class="form-control" id="searchId" name="searchId">
                    </fieldset>
                    <button type="submit" class="btn btn-primary">Get User Data</button>
                </form>
                <br>
                <form role="form" method="POST">
                    <input type="hidden" id="update-user" name="update-user" value="1">
                    <fieldset class="form-group">
                        <label for="idNum">ID Number to update:</label>
                        <input type="number" class ="form-control" id="idNum" name="idNum" placeholder="Enter ID">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="firstName">Set First Name to:</label>
                        <input type="text" class="form-control" id="firstName" name="firstName">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="lastName">Set Last Name to:</label>
                        <input type="text" class="form-control" id="lastName" name="lastName">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="address">Set Address to:</label>
                        <input type="text" class="form-control" id="address" name="address">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="city">Set City to:</label>
                        <input type="text" class="form-control" id="city" name="city">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="state">Set State to:</label>
                        <input type="text" class="form-control" id="state" name="state" placeholder="NY">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="zipCode">Set Zip Code to:</label>
                        <input type="text" class="form-control" id="zipCode" name="zipCode" placeholder="11790">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="phone">Set Phone Number to:</label>
                        <input type="tel" class="form-control" id="phone" name="phone" placeholder="##########">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="email">Set Email to:</label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="test@example.com">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="ccNum">Set Credit Card Number to:</label>
                        <input type="number" class="form-control" id="ccNum" name="ccNum" placeholder="################">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="rating">Set rating number:</label>
                        <input type="number" class ="form-control" id="rating" name="rating" placeholder="Rating">
                    </fieldset>
                    <button type="submit" class="btn btn-primary">Submit</button>
                </form>
            </div>
        </div>
                <%
                    if (request.getParameter("getData") != null) {
                        System.out.println("Getting data for an id...");
                        if (request.getParameter("searchId") != null) {
                            try {
                                int idNum = Integer.parseInt(request.getParameter("searchId"));
                                StaticConnection.initialize();
                                String results[][] = 
                                    QueryMaker.searchCustomerView(StaticConnection.getDbi(), idNum);
                                String elementId[] = {"lastName", "firstName", "address", "city", "state", 
                                    "zipCode", "phone", "email", "ccNum", "rating"};
                                String javascript = "<script>document.getElementById('idNum').value = '" + idNum + "';";
                                for (int i = 0; i < results[0].length - 1; i++) {
                                    javascript += "document.getElementById('"+elementId[i]+"').value = '"+results[0][i+1]+"';";
                                }
                                javascript += "</script>";
                                out.println(javascript);
                            } catch (NumberFormatException nfe) {
                                out.println("<script>alert('You entered an invalid number in the field.');</script>");
                            } catch (ArrayIndexOutOfBoundsException a) {
                                out.println("<script>alert('Couldn\\'t find that user.');</script>");
                            }
                            
                        }
                    }
                    if (request.getParameter("update-user") != null) {
                        try {
                            int idNum = Integer.parseInt(request.getParameter("idNum"));
                            String firstName = request.getParameter("firstName");
                            String lastName = request.getParameter("lastName");
                            String address = request.getParameter("address");
                            String city = request.getParameter("city");
                            String state = request.getParameter("state");
                            int zipCode = Integer.parseInt(request.getParameter("zipCode"));
                            long phone = Long.parseLong(request.getParameter("phone"));
                            String email = request.getParameter("email");
                            long ccNum = Long.parseLong(request.getParameter("ccNum"));
                            int rating = Integer.parseInt(request.getParameter("rating"));
                            if (QueryMaker.updateCustomer(StaticConnection.getDbi(), idNum, email, ccNum, rating) && 
                                QueryMaker.updatePerson(StaticConnection.getDbi(), idNum, lastName, firstName, address, city, state, zipCode, phone)) {
                                out.println("<script>alert('User updated.');</script>");
                            } else {
                                out.println("<script>alert('Update failed. Make sure the ID is correct and all fields have valid info.');</script>");
                            }
                        } catch (NumberFormatException nfe) {
                            System.out.println(nfe.getMessage());
                            out.println("<script>alert('You entered an invalid number in a field.');</script>");
                        }
                    }
                %>
            <div class="panel panel-primary ">
            <div class="panel-heading">Delete a Customer</div>
            <div class="panel-body" style="overflow-y: scroll;">
                <form class="form-inline" role="form" method="POST">
                    <input type="hidden" id="delCust" name="delCust" value="1">
                    <fieldset class="form-group">
                        <label for="delNum">ID # to delete:</label>
                        <input type="number" class="form-control" id="delNum" name="delNum">
                    </fieldset>
                    <button type="submit" class="btn btn-primary">Delete</button>
                </form>
                <%
                    if (request.getParameter("delCust") != null) {
                        try {
                            int idNum = Integer.parseInt(request.getParameter("delNum"));
                            if (QueryMaker.deleteCustomer(StaticConnection.getDbi(), idNum)) {
                                out.println("<script>alert('User deleted.');</script>");
                            } else {
                                out.println("<script>alert('Delete failed. Make sure the ID is correct.');</script>");
                            }
                        } catch (NumberFormatException nfe) {
                            out.println("<script>alert('You entered an invalid number in the field.');</script>");
                        }
                    }
                %>
                 </div></div>
            <div class="panel panel-primary ">
            <div class="panel-heading">Create A Customer Account</div>
            <div class="panel-body" style="overflow-y: scroll;">
                <form class="form-inline" role="form" method="POST">
                    <input type="hidden" id="delCust" name="mkacc" value="1">
                    <fieldset class="form-group">
                        <label for="acc-id">ID # to add account:</label>
                        <input type="number" class="form-control" id="acc-id" name="acc-id">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="acc-num">Account Number:</label>
                        <input type="number" class="form-control" id="acc-num" name="acc-num">
                    </fieldset>
                    <button type="submit" class="btn btn-primary">Create</button>
                </form>
                <%
                    if (request.getParameter("mkacc") != null) {
                        try {
                            int idNum = Integer.parseInt(request.getParameter("acc-id"));
                             int accNum = Integer.parseInt(request.getParameter("acc-num"));
                            if (QueryMaker.createAccount(StaticConnection.getDbi(), idNum, accNum)) {
                                out.println("<script>alert('Account Created.');</script>");
                            } else {
                                out.println("<script>alert('Account Creation Failed.');</script>");
                            }
                        } catch (NumberFormatException nfe) {
                            out.println("<script>alert('Either the account id or account number wasn't a number.');</script>");
                        }
                    }
                %>
            </div></div></div>
    </body>
</html>
