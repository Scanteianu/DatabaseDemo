/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package HTMLStuff;

/**
 *
 * @author Dan
 */
public class PageComponents {
    public static String makeGenericNavBar(){
        return "<nav class=\"navbar navbar-default\">\n" +
            "  <div class=\"container-fluid\">\n" +
            "    <!-- Brand and toggle get grouped for better mobile display -->\n" +
            "    <div class=\"navbar-header\">\n" +
            "      <button type=\"button\" class=\"navbar-toggle collapsed\" data-toggle=\"collapse\" data-target=\"#bs-example-navbar-collapse-1\" aria-expanded=\"false\">\n" +
            "        <span class=\"sr-only\">Toggle navigation</span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "      </button>\n" +
            "      <a class=\"navbar-brand\" href=\"#\">CDPTrade</a>\n" +
            "    </div>\n" +
            "\n" +
            "    <!-- Collect the nav links, forms, and other content for toggling -->\n" +
            "    <div class=\"collapse navbar-collapse\" id=\"bs-example-navbar-collapse-1\">\n" +
            "      <ul class=\"nav navbar-nav\">\n" +
            "        <li class=\"active\"><a href=\"#\">Link <span class=\"sr-only\">(current)</span></a></li>\n" +
            "        <li><a href=\"#\">Link</a></li>\n" +
            "        <li class=\"dropdown\">\n" +
            "          <a href=\"#\" class=\"dropdown-toggle\" data-toggle=\"dropdown\" role=\"button\" aria-haspopup=\"true\" aria-expanded=\"false\">Dropdown <span class=\"caret\"></span></a>\n" +
            "          <ul class=\"dropdown-menu\">\n" +
            "            <li><a href=\"#\">Action</a></li>\n" +
            "            <li><a href=\"#\">Another action</a></li>\n" +
            "            <li><a href=\"#\">Something else here</a></li>\n" +
            "            <li role=\"separator\" class=\"divider\"></li>\n" +
            "            <li><a href=\"#\">Separated link</a></li>\n" +
            "            <li role=\"separator\" class=\"divider\"></li>\n" +
            "            <li><a href=\"#\">One more separated link</a></li>\n" +
            "          </ul>\n" +
            "        </li>\n" +
            "      </ul>\n" +
            "      <form class=\"navbar-form navbar-left\" role=\"search\">\n" +
            "        <div class=\"form-group\">\n" +
            "          <input type=\"text\" class=\"form-control\" placeholder=\"Search\">\n" +
            "        </div>\n" +
            "        <button type=\"submit\" class=\"btn btn-default\">Submit</button>\n" +
            "      </form>\n" +
            "      <ul class=\"nav navbar-nav navbar-right\">\n" +
            "        <li><a href=\"#\">Link</a></li>\n" +
            "        <li class=\"dropdown\">\n" +
            "          <a href=\"#\" class=\"dropdown-toggle\" data-toggle=\"dropdown\" role=\"button\" aria-haspopup=\"true\" aria-expanded=\"false\">Dropdown <span class=\"caret\"></span></a>\n" +
            "          <ul class=\"dropdown-menu\">\n" +
            "            <li><a href=\"#\">Action</a></li>\n" +
            "            <li><a href=\"#\">Another action</a></li>\n" +
            "            <li><a href=\"#\">Something else here</a></li>\n" +
            "            <li role=\"separator\" class=\"divider\"></li>\n" +
            "            <li><a href=\"#\">Separated link</a></li>\n" +
            "          </ul>\n" +
            "        </li>\n" +
            "      </ul>\n" +
            "    </div><!-- /.navbar-collapse -->\n" +
            "  </div><!-- /.container-fluid -->\n" +
            "</nav>";
    }
     public static String makeLoginNavBar(){
        return "<nav class=\"navbar navbar-default\">\n" +
            "  <div class=\"container-fluid\">\n" +
            "    <!-- Brand and toggle get grouped for better mobile display -->\n" +
            "    <div class=\"navbar-header\">\n" +
            "      <button type=\"button\" class=\"navbar-toggle collapsed\" data-toggle=\"collapse\" data-target=\"#bs-example-navbar-collapse-1\" aria-expanded=\"false\">\n" +
            "        <span class=\"sr-only\">Toggle navigation</span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "      </button>\n" +
            "      <a class=\"navbar-brand\" href=\"#\">CDPTrade</a>\n" +
            "    </div>\n" +
           
            "</nav>";
    }
     public static String makeUserNavBar(String userName){
        return "<nav class=\"navbar navbar-default\">\n" +
            "  <div class=\"container-fluid\">\n" +
            "    <!-- Brand and toggle get grouped for better mobile display -->\n" +
            "    <div class=\"navbar-header\">\n" +
            "      <button type=\"button\" class=\"navbar-toggle collapsed\" data-toggle=\"collapse\" data-target=\"#bs-example-navbar-collapse-1\" aria-expanded=\"false\">\n" +
            "        <span class=\"sr-only\">Toggle navigation</span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "      </button>\n" +
            "      <a class=\"navbar-brand\" href=\"dashboard.jsp\">CDPTrade</a>\n" +
                
            "    </div>\n" +
                   "<div class=\"collapse navbar-collapse\" id=\"bs-example-navbar-collapse-1\">"+
             "<ul class=\"nav navbar-nav navbar-right\">"+  
            "<li><a href=\"dashboard.jsp\">Dashboard</a></li>"+
            "</ul>"+
            "<ul class=\"nav navbar-nav\">"+
            "<li><a href=\"#\">Logged in as:" + userName+".</a></li>"+
            "<li><a href=\"dashboard.jsp?logout=1\">Logout</a></li>"+
            "</ul>"+
          
            "</div>"+
           "</div>"+
           
            "</nav>";
    }
     public static String makeManagerNavBar(String userName){
        return "<nav class=\"navbar navbar-default\">\n" +
            "  <div class=\"container-fluid\">\n" +
            "    <!-- Brand and toggle get grouped for better mobile display -->\n" +
            "    <div class=\"navbar-header\">\n" +
            "      <button type=\"button\" class=\"navbar-toggle collapsed\" data-toggle=\"collapse\" data-target=\"#bs-example-navbar-collapse-1\" aria-expanded=\"false\">\n" +
            "        <span class=\"sr-only\">Toggle navigation</span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "      </button>\n" +
            "      <a class=\"navbar-brand\" href=\"dashboard.jsp\">CDPTrade</a>\n" +
                
            "    </div>\n" +
                   "<div class=\"collapse navbar-collapse\" id=\"bs-example-navbar-collapse-1\">"+
             "<ul class=\"nav navbar-nav\">"+  
            "<li><a href=\"dashboard.jsp\">Dashboard</a></li>"+
                "<li><a href=\"managerportal.jsp\">Manager Portal</a></li>"+
                 "<li><a href=\"manageusers.jsp\">Manage Users</a></li>"+
                 "<li><a href=\"csreportal.jsp\">CSRep Portal</a></li>"+
                 "<li><a href=\"manageclients.jsp\">Edit Client Information</a></li>"+
                "<li><a href=\"help.jsp\">Help</a></li>"+
            "</ul>"+
            "<ul class=\"nav navbar-nav navbar-right\">"+
            "<li><a href=\"#\">Logged in as:" + userName+".</a></li>"+
            "<li><a href=\"dashboard.jsp?logout=1\">Logout</a></li>"+
            "</ul>"+
          
            "</div>"+
           "</div>"+
           
            "</nav>";
    }
     public static String makeCSRepNavBar(String userName){
        return "<nav class=\"navbar navbar-default\">\n" +
            "  <div class=\"container-fluid\">\n" +
            "    <!-- Brand and toggle get grouped for better mobile display -->\n" +
            "    <div class=\"navbar-header\">\n" +
            "      <button type=\"button\" class=\"navbar-toggle collapsed\" data-toggle=\"collapse\" data-target=\"#bs-example-navbar-collapse-1\" aria-expanded=\"false\">\n" +
            "        <span class=\"sr-only\">Toggle navigation</span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "      </button>\n" +
            "      <a class=\"navbar-brand\" href=\"dashboard.jsp\">CDPTrade</a>\n" +
                
            "    </div>\n" +
                   "<div class=\"collapse navbar-collapse\" id=\"bs-example-navbar-collapse-1\">"+
             "<ul class=\"nav navbar-nav\">"+  
            "<li><a href=\"dashboard.jsp\">Dashboard</a></li>"+
                 "<li><a href=\"csreportal.jsp\">CSRep Portal</a></li>"+
                 "<li><a href=\"manageclients.jsp\">Edit Client Information</a></li>"+
                "<li><a href=\"help.jsp\">Help</a></li>"+
            "</ul>"+
            "<ul class=\"nav navbar-nav navbar-right\">"+
            "<li><a href=\"#\">Logged in as:" + userName+".</a></li>"+
            "<li><a href=\"dashboard.jsp?logout=1\">Logout</a></li>"+
            "</ul>"+
          
            "</div>"+
           "</div>"+
           
            "</nav>";
    }
     public static String makeClientNavBar(String userName){
        return "<nav class=\"navbar navbar-default\">\n" +
            "  <div class=\"container-fluid\">\n" +
            "    <!-- Brand and toggle get grouped for better mobile display -->\n" +
            "    <div class=\"navbar-header\">\n" +
            "      <button type=\"button\" class=\"navbar-toggle collapsed\" data-toggle=\"collapse\" data-target=\"#bs-example-navbar-collapse-1\" aria-expanded=\"false\">\n" +
            "        <span class=\"sr-only\">Toggle navigation</span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "        <span class=\"icon-bar\"></span>\n" +
            "      </button>\n" +
            "      <a class=\"navbar-brand\" href=\"dashboard.jsp\">CDPTrade</a>\n" +
                
            "    </div>\n" +
                   "<div class=\"collapse navbar-collapse\" id=\"bs-example-navbar-collapse-1\">"+
             "<ul class=\"nav navbar-nav\">"+  
            "<li><a href=\"dashboard.jsp\">Dashboard</a></li>"+
                 "<li><a href=\"clientportal.jsp\">Client Portal</a></li>"+
                  "<li><a href=\"help.jsp\">Help</a></li>"+
            "</ul>"+
            "<ul class=\"nav navbar-nav navbar-right\">"+
            "<li><a href=\"#\">Logged in as:" + userName+".</a></li>"+
            "<li><a href=\"dashboard.jsp?logout=1\">Logout</a></li>"+
            "</ul>"+
          
            "</div>"+
           "</div>"+
           
            "</nav>";
    }
}
