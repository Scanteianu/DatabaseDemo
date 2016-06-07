package Data;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */



import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;


/**
 *
 * @author Dan
 */
public class JDBCStandalone {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // example of a non-prepared statement
        DatabaseInterface dbi=new DatabaseInterface();
        // this works currently with a database called scheduledb hosted on my wamp server, username is root, password is empty string
        dbi.connect("jdbc:mysql://localhost/db305","root","");
        //try {
            //System.out.println(QueryMaker.buy(dbi, 444444444, 1, "DAN", 12, 123456789, 5));
            //System.out.println(QueryMaker.sell(dbi, 444444444, 1, "DAN", 120, 123456789, 5));
            //QueryMaker.createStock(dbi, "BS", "bullshit", "agriculture", 69, 100);
        //} catch (InsufficientStockException ex) {
         //   System.out.println("Cain't sell shit, mo'fucka");
        //}
        String results[][] =QueryMaker.listOfOrdersByStock(dbi, "DAN");
        for(int i=0; i<results.length; i++)
        {
            for(int j=0; j<results[0].length; j++)
                System.out.printf("%-25s|",results[i][j]);
            System.out.println();
        }
        //System.out.println("~~~~~~~~~~~~~Prep statements~~~~~~~~~~~~~~~~~~");
        
        
        
        /*
        // Example of a prepared statement
        try {
            //there is a table called schedule which has a column called title
            PreparedStatement ps = dbi.getConnection().prepareStatement("SELECT * FROM schedule WHERE title = ?");
            //one of the columns has this title.
            //note: sql indices start at 1
            ps.setString(1, "databases sql statements");
            results=dbi.executePreparedStatement(ps);
            for(int i=0; i<results.length; i++)
            {
                for(int j=0; j<results[0].length; j++)
                    System.out.printf("%-25s|",results[i][j]);
                System.out.println();
            }
        } catch (SQLException ex) {
            System.out.println("ERROR WITH PREP STATEMENT");
        }
    
                */
    }
}
