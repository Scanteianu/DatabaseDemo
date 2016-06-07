package Data;


import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Dan
 */
public class DatabaseInterface {
    Connection connection;
    public DatabaseInterface(){
        
    }
    public boolean connect(String url, String username, String password){
        
        try{
            DriverManager.registerDriver((Driver)Class.forName("com.mysql.jdbc.Driver").newInstance());
            connection = DriverManager.getConnection(url+"?user="+username+"&password="+password);
            return true;
        }
        
        catch(SQLException ex){
            DebugPrint.println(ex.getMessage());
            return false;
        } catch (ClassNotFoundException ex) {
            DebugPrint.println("CNF");
            return false;
        } catch (InstantiationException ex) {
            DebugPrint.println("Inst");
            return false;
        } catch (IllegalAccessException ex) {
            DebugPrint.println("Illegal");
            return false;
        }
        
    }
    public String[][] executeStatement(String statementString){
        ResultSet results;
        try {
            Statement statement = connection.createStatement();
            results=statement.executeQuery(statementString);
            results.last();
            
            int numRows=results.getRow();
            results.first();
            String resAsString [][]= new String [numRows][results.getMetaData().getColumnCount()];
            for(int i=0; i<numRows; i++){
                for(int j =1; j<=results.getMetaData().getColumnCount(); j++)
                    resAsString[i][j-1]=results.getString(j);
                results.next();
            }
            return resAsString;
        } catch (SQLException ex) {
            DebugPrint.println(ex.getMessage());
            return null;
        }
        
    }
    
    public String[][] executePreparedStatement(PreparedStatement statement){
         ResultSet results;
        try {
           
            
            results=statement.executeQuery();
            results.last();
            
            int numRows=results.getRow();
            results.first();
            String resAsString [][]= new String [numRows][results.getMetaData().getColumnCount()];
            for(int i=0; i<numRows; i++){
                for(int j =1; j<=results.getMetaData().getColumnCount(); j++)
                    resAsString[i][j-1]=results.getString(j);
                results.next();
            }
            return resAsString;
        } catch (SQLException ex) {
            DebugPrint.println(ex.getMessage());
            return null;
        }
    }
    public int getInt(PreparedStatement statement){
         ResultSet results;
        try {
           
            
            
            results=statement.executeQuery();
             results.first();
            return results.getInt(1);
            
           
            
            
        } catch (SQLException ex) {
            DebugPrint.println(ex.getMessage());
            return -1;
        }
    }
    public double getDouble(PreparedStatement statement){
         ResultSet results;
        try {
           
            
            results=statement.executeQuery();
             results.first();
            return results.getDouble(1);
            
           
            
            
        } catch (SQLException ex) {
            DebugPrint.println(ex.getMessage());
            return -1;
        }
    }
    public boolean executePreparedUpdate(PreparedStatement statement){
         ResultSet results;
        try {
           
            
            statement.executeUpdate();
            
           return true;
        } catch (SQLException ex) {
            DebugPrint.println(ex.getMessage());
            return false;
        }
    }
    /**
     * for generating prepared statements.
     * @return the connection (make sure to initialize it)
     */
    public Connection getConnection(){
        return connection;
    }
}
