/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Data;

/**
 *
 * @author Dan
 */
public class StaticConnection {
    private static DatabaseInterface dbi;

    public static DatabaseInterface getDbi() {
        initialize();
        return dbi;
    }

    private static boolean initialized=false;
    public  static void initialize(){
        if(!initialized){
          dbi=new DatabaseInterface();
        // this works currently with a database called scheduledb hosted on my wamp server, username is root, password is empty string
            dbi.connect("jdbc:mysql://localhost/db305","root","");
            initialized=true;
            DebugPrint.println("Initialized!");
        }   
    }
   
}
