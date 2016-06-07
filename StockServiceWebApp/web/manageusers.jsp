<%-- 
    Document   : manageusers
    Created on : Apr 28, 2016, 1:29:45 AM
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
        <title>CDPTrade: User Management</title>
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
            <div class="panel panel-primary">
            <div class="panel-heading">Add a User</div>
            <div class="panel-body" style="overflow-y: scroll;">
                <form role="form" method="POST">
                    <input type="hidden" id="add-account" name="add-account" value="1">
                    <fieldset class="form-group">
                        <label for="idNum">Create Account for ID Number:</label>
                        <input type="number" class ="form-control" id="idNum" name="idNum" placeholder="Enter ID">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="pw">Password for account:</label>
                        <input type="password" class="form-control" id="pw" name="pw" placeholder="********">
                    </fieldset>
                    <button type="submit" class="btn btn-primary">Submit</button>
                </form>
                <%
                    if (request.getParameter("add-account") != null) {
                        try {
                            int idNum = Integer.parseInt(request.getParameter("idNum"));
                            String pw = request.getParameter("pw");
                            if (QueryMaker.addAccount(StaticConnection.getDbi(), idNum, pw)) {
                                out.println("<script>alert('Account added');</script>");
                            } else {
                                out.println("<script>alert('Failed to add account, maybe one already exists for that ID?</script>");
                            }
                        } catch (NumberFormatException nfe) {
                            out.println("<script>alert('You entered an invalid number in the ID field.');</script>");
                        }
                    }
                %>
            </div>
            </div>
            <div class="panel panel-primary">
            <div class="panel-heading">Update a User</div>
            <div class="panel-body" style="overflow-y: scroll;">
                <form role="form" method="POST">
                    <input type="hidden" id="update-account" name="update-account" value="1">
                    <fieldset class="form-group">
                        <label for="idNum">Update Password for ID Number:</label>
                        <input type="number" class ="form-control" id="idNum" name="idNum" placeholder="Enter ID">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="pw">New Password:</label>
                        <input type="password" class="form-control" id="pw" name="pw" placeholder="********">
                    </fieldset>
                    <button type="submit" class="btn btn-primary">Submit</button>
                </form>
                <%
                    if (request.getParameter("update-account") != null) {
                        try {
                            int idNum = Integer.parseInt(request.getParameter("idNum"));
                            String pw = request.getParameter("pw");
                            if (QueryMaker.updateAccount(StaticConnection.getDbi(), idNum, pw)) {
                                out.println("<script>alert('Account updated.');</script>");
                            } else {
                                out.println("<script>alert('Failed to update account, maybe one doesn't exist for that ID?</script>");
                            }
                        } catch (NumberFormatException nfe) {
                            out.println("<script>alert('You entered an invalid number in the ID field.');</script>");
                        }
                    }
                %>
            </div>
            </div>
            <div class="panel panel-primary">
            <div class="panel-heading">Delete a User</div>
            <div class="panel-body" style="overflow-y: scroll;">
                <form class="inline-form" role="form" method="POST">
                    <input type="hidden" id="delete-account" name="delete-account" value="1">
                    <fieldset class="form-group">
                        <label for="idNum">Delete Account of ID Number:</label>
                        <input type="number" class ="form-control" id="idNum" name="idNum" placeholder="Enter ID">
                    </fieldset>
                    <button type="submit" class="btn btn-primary">Submit</button>
                </form>
                <%
                    if (request.getParameter("delete-account") != null) {
                        try {
                            int idNum = Integer.parseInt(request.getParameter("idNum"));
                            if (QueryMaker.deleteAccount(StaticConnection.getDbi(), idNum)) {
                                out.println("<script>alert('Account deleted.');</script>");
                            } else {
                                out.println("<script>alert('Failed to delete account, maybe one doesn't exist for that ID?</script>");
                            }
                        } catch (NumberFormatException nfe) {
                            out.println("<script>alert('You entered an invalid number in the ID field.');</script>");
                        }
                    }
                %>
            </div>
            </div>
            <div class="panel panel-primary">
            <div class="panel-heading">Add an Employee</div>
            <div class="panel-body" style="overflow-y: scroll;">
                <form id="add-empl" role="form" method="POST">
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
                        <label for="ssni">Set SSN to:</label>
                        <input type="number" class="form-control" id="ssni" name="ssni" placeholder="#########">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="startDatei">Set Start Date to:</label>
                        <input type="date" class="form-control" id="startDatei" name="startDatei">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="payRatei">Set hourly pay rate to:</label>
                        <input type="number" step="0.01" class ="form-control" id="payRatei" name="payRatei" placeholder="10.00">
                    </fieldset>
                    <select name="statusi" form="add-empl">Set status to:
                        <option value="INACTIVE">Inactive</option>
                        <option value="CSRep">Customer Service Rep</option>
                        <option value="Mgr">Manager</option>
                    </select>
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
                            int ssn = Integer.parseInt(request.getParameter("ssni"));
                            String date = request.getParameter("startDatei");
                            double payRate = Double.parseDouble(request.getParameter("payRatei"));
                            String status = request.getParameter("statusi");
                            if (QueryMaker.addEmployee(StaticConnection.getDbi(), idNum, lastName, firstName, address, city, state, zipCode, phone, ssn, date, payRate, status)) {
                                out.println("<script>alert('Employee added.');</script>");
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
            <div class="panel-heading">Update Employee Information</div>
            <div class="panel-body" style="overflow-y: scroll;">
                <form class="form-inline" role="form" method="POST">
                    <input type="hidden" id="getData" name="getData" value="1">
                    <fieldset class="form-group">
                        <label for="searchId">Get data for Employee #:</label>
                        <input type="number" class="form-control" id="searchId" name="searchId">
                    </fieldset>
                    <button type="submit" class="btn btn-primary">Get Data</button>
                </form>
                <br>
                <form id="update" role="form" method="POST">
                    <input type="hidden" id="update-empl" name="update-empl" value="1">
                    <fieldset class="form-group">
                        <label for="idNumb">ID Number to update:</label>
                        <input type="number" class ="form-control" id="idNumb" name="idNumb" placeholder="Enter ID">
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
                        <label for="ssn">Set SSN to:</label>
                        <input type="number" class="form-control" id="ssn" name="ssn" placeholder="#########">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="startDate">Set Start Date to:</label>
                        <input type="date" class="form-control" id="startDate" name="startDate">
                    </fieldset>
                    <fieldset class="form-group">
                        <label for="payRate">Set hourly pay rate to:</label>
                        <input type="number" step="0.01" class ="form-control" id="payRate" name="payRate" placeholder="10.00">
                    </fieldset>
                    <select id="status" name="status" form="update">Set status to:
                        <option value="INACTIVE">Inactive</option>
                        <option value="CSRep">Customer Service Rep</option>
                        <option value="MGR">Manager</option>
                    </select>
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
                                    QueryMaker.searchEmployeeView(StaticConnection.getDbi(), idNum);
                                String elementId[] = {"lastName", "firstName", "address", "city", "state", 
                                    "zipCode", "phone", "ssn", "startDate", "payRate", "status"};
                                String javascript = "<script>document.getElementById('idNumb').value = '" + idNum + "';";
                                for (int i = 0; i < results[0].length - 1; i++) {
                                    javascript += "document.getElementById('"+elementId[i]+"').value = '"+results[0][i+1]+"';";
                                }
                                javascript += "</script>";
                                out.println(javascript);
                            } catch (NumberFormatException nfe) {
                                out.println("<script>alert('You entered an invalid number in the field.');</script>");
                            } catch (ArrayIndexOutOfBoundsException a) {
                                out.println("<script>alert('Couldn\\'t find that employee.');</script>");
                            }
                            
                        }
                    }
                    if (request.getParameter("update-empl") != null) {
                        try {
                            int idNum = Integer.parseInt(request.getParameter("idNum"));
                            String firstName = request.getParameter("firstName");
                            String lastName = request.getParameter("lastName");
                            String address = request.getParameter("address");
                            String city = request.getParameter("city");
                            String state = request.getParameter("state");
                            int zipCode = Integer.parseInt(request.getParameter("zipCode"));
                            long phone = Long.parseLong(request.getParameter("phone"));
                            int ssn = Integer.parseInt(request.getParameter("ssn"));
                            String date = request.getParameter("startDate");
                            double payRate = Double.parseDouble(request.getParameter("payRate"));
                            String status = request.getParameter("status");
                            if (QueryMaker.updateEmployee(StaticConnection.getDbi(), idNum, ssn, date, payRate, status) && 
                                QueryMaker.updatePerson(StaticConnection.getDbi(), idNum, lastName, firstName, address, city, state, zipCode, phone)) {
                                out.println("<script>alert('Employee updated.');</script>");
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
            <div class="panel-heading">Delete an Employee</div>
            <div class="panel-body" style="overflow-y: scroll;">
                <form class="form-inline" role="form" method="POST">
                    <input type="hidden" id="delEmpl" name="delEmpl" value="1">
                    <fieldset class="form-group">
                        <label for="delNum">ID # to delete:</label>
                        <input type="number" class="form-control" id="delNum" name="delNum">
                    </fieldset>
                    <button type="submit" class="btn btn-primary">Delete</button>
                </form>
                <%
                    if (request.getParameter("delEmpl") != null) {
                        try {
                            int idNum = Integer.parseInt(request.getParameter("delNum"));
                            if (QueryMaker.deleteEmployee(StaticConnection.getDbi(), idNum)) {
                                out.println("<script>alert('Employee deleted.');</script>");
                            } else {
                                out.println("<script>alert('Delete failed. Make sure the ID is correct.');</script>");
                            }
                        } catch (NumberFormatException nfe) {
                            out.println("<script>alert('You entered an invalid number in the field.');</script>");
                        }
                    }
                %>
            </div>
        </div>
    </div>
    </body>
</html>
