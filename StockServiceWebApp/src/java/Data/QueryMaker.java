/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Data;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Dan
 */
public class QueryMaker {
    /**
     * 
     * @param dbi database interface instance
     * @param stockId
     * @param name
     * @param type
     * @param priceInCents
     * @param numShares
     * @return true if successful, false otherwise
     */
    public static boolean createStock(DatabaseInterface dbi, String stockId, String name, String type, int priceInCents, float numShares){
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("INSERT INTO Stock (StockId, Name, Type, Price, NumShares) VALUES (?,?,?,?,?);");
            ps.setString(1, stockId);
            ps.setString(2, name);
            ps.setString(3,type);
            ps.setDouble(4, priceInCents/100.0);
            ps.setDouble(5, numShares);
            dbi.executePreparedUpdate(ps);
            ps=dbi.getConnection().prepareStatement("INSERT INTO Price (StockId, Timestamp, Price) VALUES (?, NOW(), ?);");
            ps.setString(1, stockId);
            ps.setDouble(2, priceInCents/100.0);
            dbi.executePreparedUpdate(ps);
            return true;
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
        
    }
     public static boolean updateStockPrice(DatabaseInterface dbi, String stockId, int priceInCents){
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("UPDATE Stock SET Price =? WHERE StockId = ?;");
            ps.setString(2, stockId);
            ps.setDouble(1, priceInCents/100.0);
            if(!dbi.executePreparedUpdate(ps))
                return false;
            ps=dbi.getConnection().prepareStatement("INSERT INTO Price (StockId, Timestamp, Price) VALUES (?, NOW(), ?);");
            ps.setString(1, stockId);
            ps.setDouble(2, priceInCents/100.0);
            if(!dbi.executePreparedUpdate(ps))
                return false;
            //Conditional Order Time baby!
            return true;
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
        
    }
      public static boolean createAccount(DatabaseInterface dbi, int uid, int accnum){
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("Insert Into Account VALUES(?,?,NOW());");
            ps.setInt(1, uid);
            ps.setInt(2, accnum);
           
            if(!dbi.executePreparedUpdate(ps))
                return false;
            return true;
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
        
    }
    public static String[][] stockHoldings(DatabaseInterface dbi, int ownerId){
         PreparedStatement ps;
        try {
            ps = dbi.getConnection().prepareStatement("SELECT StockId,NumShares,AccountNum FROM Ownership WHERE OwnerId=? ORDER BY AccountNum ASC, StockId ASC;");
            ps.setInt(1, ownerId);
            
            return dbi.executePreparedStatement(ps);
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
         
    }
    public static String[][] transactionHistory(DatabaseInterface dbi, int ownerId){
         PreparedStatement ps;
        try {
            ps = dbi.getConnection().prepareStatement("SELECT OrderId, AccountNum, TransType, EmployeeId, StockId, Timestamp, TransFee, StockPrice, NumStocks, PriceType  FROM Transaction WHERE ClientId=?;");
            ps.setInt(1, ownerId);
            return dbi.executePreparedStatement(ps);
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
         
    }
    public static String[][] stockPriceHistory(DatabaseInterface dbi, String stockId,String start,String end){
         PreparedStatement ps;
        try {
            ps = dbi.getConnection().prepareStatement("SELECT Price, Timestamp FROM Price WHERE StockId=? AND Timestamp>? AND Timestamp<? ORDER BY Timestamp DESC;");
            ps.setString(1, stockId);
            ps.setString(2,start);
            ps.setString(3, end);
            return dbi.executePreparedStatement(ps);
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
    public static String[][] listOfOrdersByStock(DatabaseInterface dbi, String stockId){
         PreparedStatement ps;
        try {
            ps = dbi.getConnection().prepareStatement("SELECT * FROM Transaction WHERE StockId=?;");
            ps.setString(1, stockId);
            return dbi.executePreparedStatement(ps);
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
         
    }
    public static String[][] listOfOrdersByClient(DatabaseInterface dbi,int clientId){
         PreparedStatement ps;
        try {
            ps = dbi.getConnection().prepareStatement("SELECT * FROM Transaction WHERE ClientId=?;");
            ps.setInt(1, clientId);
            return dbi.executePreparedStatement(ps);
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
         
    }
    public static String[][] listOfStocks(DatabaseInterface dbi){
        return dbi.executeStatement("SELECT * FROM Stock;");
        
    }
    public static String[][] mostTradedStocks(DatabaseInterface dbi){
        return dbi.executeStatement(" Select StockId, Count(stockId) from Transaction Group by stockId Order By Count(stockId) DESC;");
        
    }
    public static String[][] bestSellingStocks(DatabaseInterface dbi){
        return dbi.executeStatement("Select StockId, Count(stockId) from Transaction WHERE TransType='buy' Group by stockId Order By Count(stockId) DESC;");
        
    }
    public static String[][] salesMonth(DatabaseInterface dbi, String month){
         PreparedStatement ps;
        try {
            ps = dbi.getConnection().prepareStatement("SELECT * FROM Transaction WHERE Timestamp > DATE_ADD(? , INTERVAL -1 MONTH);");
            ps.setString(1, month);
            return dbi.executePreparedStatement(ps);
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
         
    }
    public static double revenueStock(DatabaseInterface dbi, String stockId){
         PreparedStatement ps;
        try {
            ps = dbi.getConnection().prepareStatement("SELECT SUM(TransFee) FROM Transaction WHERE StockId=?;");
            ps.setString(1, stockId);
            return dbi.getDouble(ps);
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return -1;
        }
         
    }
    public static double revenueStockType(DatabaseInterface dbi, String stockType){
         PreparedStatement ps;
        try {
            ps = dbi.getConnection().prepareStatement("SELECT SUM(T.TransFee) FROM Transaction T, Stock S WHERE T.StockId=S.StockId AND S.Type = ?;");
            ps.setString(1, stockType);
            return dbi.getDouble(ps);
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return -1;
        }
         
    }
    public static double revenueClient(DatabaseInterface dbi, int clientId){
         PreparedStatement ps;
        try {
            ps = dbi.getConnection().prepareStatement("SELECT SUM(TransFee) FROM Transaction WHERE ClientId=?;");
            ps.setInt(1, clientId);
            return dbi.getDouble(ps);
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return -1;
        }
         
    }
    public static String topEmployeeRevenue(DatabaseInterface dbi){
        try{
            return dbi.executeStatement("SELECT Id FROM (SELECT E.Id AS Id, SUM(T.TransFee) AS EmpRev FROM Employee E, Transaction T WHERE E.Id = T.EmployeeId) AS ERev ORDER BY  ERev.EmpRev DESC LIMIT 1;")[0][0];
        }
        catch(Exception e){
            return null;
        }
    }
    public static String topCustomerRevenue(DatabaseInterface dbi){
        try{
            return dbi.executeStatement("SELECT CRev.Id FROM (SELECT C.Id AS Id, SUM(T.TransFee) AS CustRev FROM Customer C, Transaction T WHERE C.Id = T.ClientId) AS CRev ORDER BY CRev.CustRev DESC LIMIT 1;")[0][0];
        }
         catch(Exception e){
            return null;
        }
    }
    public static boolean manualSuggestion(DatabaseInterface dbi, int clientId, String stockId){
         try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("INSERT INTO Suggestion VALUES (?,?);");
            ps.setString(2, stockId);
            ps.setInt(1, clientId);
            dbi.executePreparedUpdate(ps);
            return true;
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }
    public static String[][] getSuggestions(DatabaseInterface dbi, int clientId){
         PreparedStatement ps;
        try {
            ps = dbi.getConnection().prepareStatement("Select StockId from Suggestion where CustomerId=?;");
            ps.setInt(1, clientId);
           
            return dbi.executePreparedStatement(ps);
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
         
    }
    public static int numSalesMonth(DatabaseInterface dbi, String month){
         PreparedStatement ps;
        try {
            ps = dbi.getConnection().prepareStatement("SELECT COUNT(*) FROM Transaction WHERE Timestamp > DATE_ADD(? , INTERVAL -1 MONTH);");
            ps.setString(1, month);
            return dbi.getInt(ps);
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return -1;
        }
    
    }
    public static double corpRevenue(DatabaseInterface dbi, String month){
         PreparedStatement ps;
        try {
            ps = dbi.getConnection().prepareStatement("SELECT SUM(TransFee) FROM Transaction WHERE Timestamp > DATE_ADD(? , INTERVAL -1 MONTH);");
            ps.setString(1, month);
            return dbi.getDouble(ps);
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return -1;
        }
    
    }
    public static boolean buy( DatabaseInterface dbi,int ownerId, int accountNum, String stockId, double numshares, int employeeId, double transFee){
       
        PreparedStatement ps;
        try {
        ps=dbi.getConnection().prepareStatement("SELECT Count(*) FROM Ownership WHERE OwnerId = ? AND ( AccountNum =? ) AND ( StockId  =? );");
         ps.setInt(1, ownerId);
            ps.setInt(2, accountNum);
            ps.setString(3, stockId);
            DebugPrint.println("num stocks for..." +dbi.getInt(ps));
        if(dbi.getInt(ps)>0){
            ps=dbi.getConnection().prepareStatement("SELECT NumShares from Ownership WHERE OwnerId =? AND AccountNum = ? AND StockId =?;");
            ps.setInt(1, ownerId);
            ps.setInt(2, accountNum);
            ps.setString(3, stockId);
            double currentOwnings=dbi.getDouble(ps);
             ps=dbi.getConnection().prepareStatement("UPDATE Ownership Set NumShares = (?)WHERE OwnerId =? AND AccountNum = ? AND StockId =?; ");//line3
             ps.setDouble(1, numshares+currentOwnings);
            ps.setInt(2, ownerId);
            ps.setInt(3, accountNum);
            ps.setString(4, stockId);
            dbi.executePreparedUpdate(ps);
        }
        else{
        ps=dbi.getConnection().prepareStatement("INSERT INTO Ownership(OwnerId, AccountNum, StockId, NumShares) VALUES (?, ?, ?,?); ");
          //4th line
            ps.setInt(1, ownerId);
            ps.setInt(2, accountNum);
            ps.setString(3, stockId);
            ps.setDouble(4, numshares);
            dbi.executePreparedUpdate(ps);
        }
        ps=dbi.getConnection().prepareStatement("SELECT MAX(OrderId) FROM Transaction;");
        int lastTrans=dbi.getInt(ps);
        
        ps=dbi.getConnection().prepareStatement("INSERT INTO Transaction (OrderId, ClientId, AccountNum, TransType, EmployeeId, StockId, Timestamp, StockPrice, NumStocks, PriceType, Transfee) VALUES  (?, ?,?,?,?,?,NOW(),(SELECT MAX(Price) FROM Stock WHERE StockId=?), ?, 'mkt',?); ");
        
         
            
           
            //5th line
                ps.setInt(1,1+lastTrans);
           
            ps.setInt(2,ownerId);
            ps.setInt(3,accountNum);
            ps.setString(4,"buy");
            ps.setInt(5, employeeId);
            ps.setString(6,stockId);
            ps.setString(7,stockId);
            ps.setDouble(8,numshares);
            ps.setFloat(9,(float)transFee);
            ps.executeUpdate();
           
            return true;
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            DebugPrint.println(ex.getMessage());
            return false;
        }
    }
     public static boolean sell( DatabaseInterface dbi,int ownerId, int accountNum, String stockId, double numshares, int employeeId, double transFee, String priceType)throws InsufficientStockException{
       
        PreparedStatement ps;
        try {
        ps=dbi.getConnection().prepareStatement("SELECT Count(*) FROM Ownership WHERE OwnerId = ? AND ( AccountNum =? ) AND ( StockId  =? );");
         ps.setInt(1, ownerId);
            ps.setInt(2, accountNum);
            ps.setString(3, stockId);
            DebugPrint.println("num stocks for..." +dbi.getInt(ps));
        if(dbi.getInt(ps)>0){
            ps=dbi.getConnection().prepareStatement("SELECT NumShares from Ownership WHERE OwnerId =? AND AccountNum = ? AND StockId =?;");
            ps.setInt(1, ownerId);
            ps.setInt(2, accountNum);
            ps.setString(3, stockId);
            double currentOwnings=dbi.getDouble(ps);
            if(currentOwnings<numshares)
                throw new InsufficientStockException();
             ps=dbi.getConnection().prepareStatement("UPDATE Ownership Set NumShares = (?)WHERE OwnerId =? AND AccountNum = ? AND StockId =?; ");//line3
             ps.setDouble(1, -1*numshares+currentOwnings);
            ps.setInt(2, ownerId);
            ps.setInt(3, accountNum);
            ps.setString(4, stockId);
            dbi.executePreparedUpdate(ps);
        }
        else{
        throw new InsufficientStockException();
        }
        ps=dbi.getConnection().prepareStatement("SELECT MAX(OrderId) FROM Transaction;");
        int lastTrans=dbi.getInt(ps);
        
        ps=dbi.getConnection().prepareStatement("INSERT INTO Transaction (OrderId, ClientId, AccountNum, TransType, EmployeeId, StockId, Timestamp, StockPrice, NumStocks, PriceType, Transfee) VALUES  (?, ?,?,?,?,?,NOW(),(SELECT MAX(Price) FROM Stock WHERE StockId=?), ?, ?,?); ");
        
         
            
           
            //5th line
                ps.setInt(1,1+lastTrans);
           
            ps.setInt(2,ownerId);
            ps.setInt(3,accountNum);
            ps.setString(4,"sell");
            ps.setInt(5, employeeId);
            ps.setString(6,stockId);
            ps.setString(7,stockId);
            ps.setDouble(8,numshares);
            ps.setString(9, priceType);
            ps.setFloat(10,(float)transFee);
            ps.executeUpdate();
           
            return true;
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            DebugPrint.println(ex.getMessage());
            return false;
        }
     }
        public static SessionPermission getPermission(DatabaseInterface dbi,int userId, String password){
        try {
            PreparedStatement ps= dbi.getConnection().prepareStatement("SELECT Count(*) from Login where UserId=? AND Password = ?;");
            ps.setInt(1, userId);
            ps.setString(2, password);
            if(dbi.getInt(ps)==1){
                 ps= dbi.getConnection().prepareStatement("SELECT Count(*) from Employee where Id=? AND Status='MGR';");
                ps.setInt(1, userId);
                if(dbi.getInt(ps)==1)
                    return SessionPermission.manager;
                 ps= dbi.getConnection().prepareStatement("SELECT Count(*) from Employee where Id=? AND Status='CSRep';");
                ps.setInt(1, userId);
                if(dbi.getInt(ps)==1)
                    return SessionPermission.employee;
                 ps= dbi.getConnection().prepareStatement("SELECT Count(*) from Customer where Id=?;");
                ps.setInt(1, userId);
                if(dbi.getInt(ps)==1)
                    return SessionPermission.client;
                return null;
                
            }
            return null;
        } catch (SQLException ex) {
            DebugPrint.println(ex.getMessage()+" ~ on login authentication");
            return null;
        }
        
    }
            public static boolean placeConditionalOrder(DatabaseInterface dbi, int sellerID,int accountNum, int employeeID, String StockID, String PriceType, double diff, double NumStocks, double target){
        try{
            PreparedStatement ps = dbi.getConnection().prepareStatement("INSERT INTO ConditionalOrder(" +
                "SellerId,AccountNum,EmployeeId,StockID,PriceType,Difference,NumStocks,OrderTime,Target)" +
                "VALUES (?,?,?,?,?,?,?,NOW(),?)");
            ps.setInt(1, sellerID);
            ps.setInt(2, accountNum);
            ps.setInt(3, employeeID);
            ps.setString(4, StockID);
            ps.setString(5, PriceType);
            ps.setDouble(6, diff);
            ps.setDouble(7, NumStocks);
            dbi.executePreparedUpdate(ps);
            double price = getPrice(dbi, StockID);
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date();
            String now = dateFormat.format(date);
            
/*            addToCOHist(dbi,sellerID, accountNum, StockID, NumStocks, price, (price - diff),diff, PriceType, now); */
            return true;
        } catch (SQLException ex) {
            //Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }
    
    public static String [][] conditionalOrderHistory (DatabaseInterface dbi, int sellerID, int accountNum, int employeeID, String stockID, String priceType, double numStocks, double dif,String orderTime){
        try{
            PreparedStatement ps = dbi.getConnection().prepareStatement("SELECT StockID,NumStocks,StockPrice,Target,Difference, PriceType, UpdateTime "
                                                                        + "FROM ConditionalHistory "
                                                                        + "WHERE sellerId = ? AND accountNum = ? AND StockID = ? AND NumStocks = ? AND priceType = ? AND"
                                                                            + "Difference = ? AND OrderTime = ?");
            ps.setInt(1, sellerID);
            ps.setInt(2, accountNum);
            ps.setString(3, stockID);
            ps.setDouble(4, numStocks);
            ps.setString(5, priceType);
            ps.setDouble(6, dif);
            
            Date utilDate;
            try {
                utilDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(orderTime);
                java.sql.Timestamp sqlDate = new java.sql.Timestamp(utilDate.getTime());
                ps.setTimestamp(9,sqlDate);
            } catch (ParseException ex) {
                Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            }
             
         
            
            return dbi.executePreparedStatement(ps);
        }catch (SQLException ex){
           return null;
        }
    }
    public static String[][] listOfConditionalOrders(DatabaseInterface dbi,int sellerID){
        try{
           PreparedStatement ps = dbi.getConnection().prepareStatement("SELECT StockId,NumStocks, PriceType,Target,Difference,EmployeeId,OrderTime FROM ConditionalOrder WHERE SellerID =? GROUP BY ConditionalOrder.OrderTime ");
           ps.setInt(1, sellerID);
           return dbi.executePreparedStatement(ps);
        }catch(SQLException ex){
            return null;
        }
    }
    private static boolean addPerson(DatabaseInterface dbi, int id, String lastName, String firstName, String address, String city, String state, int zip, long phone) {
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("INSERT INTO Person (Id, LastName, FirstName, Address, City, State, ZipCode, Phone) VALUES (?, ?, ?, ?, ?, ?, ?, ?);");
            ps.setInt(1, id);
            ps.setString(2, lastName);
            ps.setString(3, firstName);
            ps.setString(4, address);
            ps.setString(5, city);
            ps.setString(6, state);
            ps.setInt(7, zip);
            ps.setLong(8, phone);
            dbi.executePreparedUpdate(ps);
            return true;
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on insert into Person");
            return false;
        } 
    }
    
    public static boolean updatePerson(DatabaseInterface dbi, int id, String lastName, String firstName, String address, String city, String state, int zip, long phone) {
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("UPDATE Person SET LastName=?, FirstName=?, Address=?, City=?, State=?, ZipCode=?, Phone=? WHERE Id=?;");
            ps.setString(1, lastName);
            ps.setString(2, firstName);
            ps.setString(3, address);
            ps.setString(4, city);
            ps.setString(5, state);
            ps.setInt(6, zip);
            ps.setLong(7, phone);
            ps.setInt(8, id);
            dbi.executePreparedUpdate(ps);
            return true;
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on update of Person");
            return false;
        }
    }
    
    
    private static boolean deletePerson(DatabaseInterface dbi, int id) {
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("DELETE FROM Person WHERE Id=?;");
            ps.setInt(1, id);
            dbi.executePreparedUpdate(ps);
            return true;
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on delete of Person");
            return false;
        }
    }
    
    public static boolean addEmployee(DatabaseInterface dbi, int id, String lastName, String firstName, String address, String city, String state, int zip, long phone, int ssn, String date, double payRate, String status) {
        try {
            boolean insertPerson = addPerson(dbi, id, lastName, firstName, address, city, state, zip, phone);
            if (!insertPerson) {
                return false;
            }
            PreparedStatement ps = dbi.getConnection().prepareStatement("INSERT INTO Employee (Id, SSN, StartDate, PayRate, Status) VALUES (?, ?, ?, ?, ?);");
            ps.setInt(1, id);
            ps.setInt(2, ssn);
            Date utilDate = new SimpleDateFormat("yyyy-MM-dd").parse(date);
            java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
            ps.setDate(3, sqlDate);
            ps.setBigDecimal(4, new BigDecimal(payRate));
            ps.setString(5, status);
            dbi.executePreparedUpdate(ps);
            return true;
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on insert into Employee");
            return false;
        } catch (ParseException p) {
            DebugPrint.println("Date couldn't be pared on insert into Employee.");
            return false;
        }
    }
    
    public static boolean updateEmployee(DatabaseInterface dbi, int id, int ssn, String date, double payRate, String status) {
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("UPDATE Employee SET SSN = ?, StartDate = ?, PayRate = ?, Status = ? WHERE Id = ?;");
            ps.setInt(1, ssn);
            Date utilDate = new SimpleDateFormat("yyyy-MM-dd").parse(date);
            java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
            ps.setDate(2, sqlDate);
            ps.setBigDecimal(3, new BigDecimal(payRate));
            ps.setString(4, status);
            ps.setInt(5, id);
            dbi.executePreparedUpdate(ps);
            return true;
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on update of Employee");
            return false;
        } catch (ParseException p) {
            DebugPrint.println("Date couldn't be parsed on update of Employee.");
            return false;
        }
    }
    
    public static boolean deleteEmployee(DatabaseInterface dbi, int id) {
        try {
            PreparedStatement ps1 = dbi.getConnection().prepareStatement("UPDATE Transaction SET EmployeeId = 0 WHERE EmployeeId = ?;");
            ps1.setInt(1, id);
            dbi.executePreparedUpdate(ps1);
            PreparedStatement ps2 = dbi.getConnection().prepareStatement("UPDATE ConditionalOrder SET EmployeeId = 0 WHERE EmployeeId = ?;");
            ps2.setInt(1, id);
            dbi.executePreparedUpdate(ps2);
            PreparedStatement ps3 = dbi.getConnection().prepareStatement("DELETE FROM Employee WHERE Id = ?;");
            ps3.setInt(1, id);
            dbi.executePreparedUpdate(ps3);
            deletePerson(dbi, id);
            return true;
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on deletion of Employee");
            return false;
        }
    }
    
    public static boolean addCustomer(DatabaseInterface dbi, int id, String lastName, String firstName, String address, String city, String state, int zip, long phone, String email, long ccNum, int rating) {
        try {
            boolean insertPerson = addPerson(dbi, id, lastName, firstName, address, city, state, zip, phone);
            if (!insertPerson) {
                return false;
            }
            PreparedStatement ps = dbi.getConnection().prepareStatement("INSERT INTO Customer (Id, Email, CreditCardNum, Rating) VALUES (?, ?, ?, ?);");
            ps.setInt(1, id);
            ps.setString(2, email);
            ps.setLong(3, ccNum);
            ps.setInt(4, rating);
            dbi.executePreparedUpdate(ps);
            return true;
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on insert into Customer");
            return false;
        }
    }
    
    public static boolean updateCustomer(DatabaseInterface dbi, int id, String email, long ccNum, int rating) {
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("UPDATE Customer SET Email = ?, CreditCardNum = ?, rating = ? WHERE Id = ?;");
            ps.setString(1, email);
            ps.setLong(2, ccNum);
            ps.setInt(3, rating);
            ps.setInt(4, id);
            dbi.executePreparedUpdate(ps);
            return true;
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on update of Customer");
            return false;
        }
    }
    
    public static boolean deleteCustomer(DatabaseInterface dbi, int id) {
        try {
            PreparedStatement ps1 = dbi.getConnection().prepareStatement("UPDATE Transaction SET ClientId = 0 WHERE ClientId = ?;");
            ps1.setInt(1, id);
            PreparedStatement ps2 = dbi.getConnection().prepareStatement("UPDATE Account SET CustomerId = 0 WHERE CustomerId = ?;");
            ps2.setInt(1, id);
            PreparedStatement ps3 = dbi.getConnection().prepareStatement("UPDATE ConditionalOrder SET SellerId = 0 WHERE SellerId = ?;");
            ps3.setInt(1, id);
            PreparedStatement ps4 = dbi.getConnection().prepareStatement("DELETE FROM Customer WHERE Id = ?;");
            ps4.setInt(1, id);
            dbi.executePreparedUpdate(ps1);
            dbi.executePreparedUpdate(ps2);
            dbi.executePreparedUpdate(ps3);
            dbi.executePreparedUpdate(ps4);
            deletePerson(dbi, id);
            return true;
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on delete of Customer");
            return false;
        }
    }

    public static String[][] generateCustomerMailingList(DatabaseInterface dbi) {
        try {
        PreparedStatement ps = dbi.getConnection().prepareStatement("SELECT Email FROM CustomerView;");
        return dbi.executePreparedStatement(ps);
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on customer mailing list generation");
            return null;
        }
    }
    
    public static String[][] searchStocksByType(DatabaseInterface dbi, String type) {
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("SELECT S.Name, S.NumShares, S.Price, T.Timestamp, T.TransType, T.StockPrice, T.NumStocks FROM Stock S, Transaction T WHERE S.StockId = T.StockId AND S.Type = ? ORDER BY T.Timestamp DESC;");
            ps.setString(1, type);
            return dbi.executePreparedStatement(ps);
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on search by type");
            return null;
        }
    }
    
    public static String[][] searchStocksByKeyword(DatabaseInterface dbi, String[] keywords) {
        try {
            String keys = "";
            for (String word : keywords) {
                keys += word + ", ";
            }
            keys = keys.substring(0, keys.length() - 2);
            PreparedStatement ps = dbi.getConnection().prepareStatement("SELECT S.Name, S.NumShares, S.Price, T.TransType, T.StockPrice, T.NumStocks FROM Stock S, Transaction T WHERE S.StockId = T.StockId AND S.StockId IN (?);");
            ps.setString(1, keys);
            return dbi.executePreparedStatement(ps);
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on search by keyword");
            return null;
        }
    }
    
    private static String[][] suggestionInnerPart(DatabaseInterface dbi, int id) {
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("SELECT S.Type FROM Stock S, Ownership O WHERE S.StockId = O.StockId AND O.OwnerId = ?;");
            ps.setInt(1, id);
            return dbi.executePreparedStatement(ps);
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on inner suggestion generation");
            return null;
        }
    }
    
    public static String[][] searchCustomerView(DatabaseInterface dbi, int id) {
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("SELECT * FROM CustomerView WHERE Id = ?;");
            ps.setInt(1, id);
            return dbi.executePreparedStatement(ps);
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on search of CustomerView for ID " + id);
            return null;
        }
    }
    
    public static String[][] searchEmployeeView(DatabaseInterface dbi, int id) {
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("SELECT * FROM EmployeeView WHERE Id = ?;");
            ps.setInt(1, id);
            return dbi.executePreparedStatement(ps);
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() + 
                " occurred on search of EmployeeView for ID " + id);
            return null;
        }
    }
    
    public static boolean addAccount(DatabaseInterface dbi, int id, String pw) {
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("INSERT INTO Login (UserId, Password) VALUES (?, ?);");
            ps.setInt(1, id);
            ps.setString(2, pw);
            dbi.executePreparedUpdate(ps);
            return true;
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() +
                " occurred on insert into Login table");
            return false;
        }
    }
    
    public static boolean updateAccount(DatabaseInterface dbi, int id, String pw) {
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("UPDATE Login SET Password=? WHERE UserId=?;");
            ps.setInt(2, id);
            ps.setString(1, pw);
            dbi.executePreparedUpdate(ps);
            return true;
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() +
                " occurred on insert into Login table");
            return false;
        }
    }
    
    public static boolean deleteAccount(DatabaseInterface dbi, int id) {
        try {
            PreparedStatement ps = dbi.getConnection().prepareStatement("DELETE FROM Login WHERE UserId=?;");
            ps.setInt(1, id);
            dbi.executePreparedUpdate(ps);
            return true;
        } catch (SQLException s) {
            DebugPrint.println(s.getMessage() +
                " occurred on insert into Login table");
            return false;
        }
    }
    public static double getPrice(DatabaseInterface dbi, String StockId){
        try{
            PreparedStatement ps = dbi.getConnection().prepareStatement("SELECT Price FROM STOCK WHERE StockId=?");
            ps.setString(1, StockId);
            return dbi.getDouble(ps);
        }catch(SQLException s){
            return 0.0;
        }
    }
    
    public static boolean sellConditionalOrders(DatabaseInterface dbi,String stockId, double price){
        try{
            PreparedStatement ps = dbi.getConnection().prepareStatement("SELECT SellerId, AccountNum,NumStocks,employeeId,Target,Difference,PriceType,OrderTime FROM ConditionalOrder WHERE StockId =? AND (Target >= ?)");
            ps.setString(1, stockId);
            ps.setDouble(2, price);
            double transfee = price/10;
            transfee = transfee/10;
            String [][] conditionalOrders = dbi.executePreparedStatement(ps);
            DebugPrint.println("Execute");
            for(int i=0; i<conditionalOrders.length; i++){
                            int sellerId = Integer.parseInt(conditionalOrders[i][0]);
                            int accNum = Integer.parseInt(conditionalOrders[i][1]);
                            //StockId
                            double numShares = Double.parseDouble(conditionalOrders[i][2]);
                            int employeeId = Integer.parseInt(conditionalOrders[i][3]);
                            double target = Double.parseDouble(conditionalOrders[i][4]);
                            double diff = Double.parseDouble(conditionalOrders[i][5]);
                            String priceType = conditionalOrders[i][6];
                            String orderTime = conditionalOrders[i][7];
                            DebugPrint.println("Loop");
                            try {
                                /*addToCOHist(dbi,sellerId,accNum,stockId,numShares,price,target,diff,priceType,orderTime);*/
                                sell(dbi,sellerId,accNum,stockId,numShares,employeeId,transfee,priceType);
                            } catch (InsufficientStockException ex) {
                            Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
                            }
            }
            //delete from onditional order table
            DebugPrint.println(stockId + " " + price);
            //Add to COHist
            PreparedStatement ps2 = dbi.getConnection().prepareStatement("DELETE FROM ConditionalOrder WHERE StockId =? AND (Target >= ?)");
            ps2.setString(1, stockId);
            ps2.setDouble(2, price);
            dbi.executePreparedUpdate(ps2);
            return true;
        }catch(SQLException s){
            DebugPrint.println("Exception occurred in sell cond order.");
            return false;
        }
    }
    public static boolean updateConditionalOrders(DatabaseInterface dbi, String stockId, double difference, double target){
        try{
           PreparedStatement ps = dbi.getConnection().prepareStatement("UPDATE ConditionalOrder SET ConditionalOrder.target = ? WHERE StockId =? AND PriceType='trailstop' AND difference=? ;");
            ps.setString(2, stockId);
            ps.setDouble(1, target);
            ps.setDouble(3, difference);
            dbi.executePreparedUpdate(ps);
            PreparedStatement ps2 = dbi.getConnection().prepareStatement("SELECT sellerId, accountNum, numStocks, OrderTime FROM ConditionalOrder WHERE StockId =? AND PriceType='trailstop' AND difference=?");
            ps.setString(2, stockId);//int sellerId, int accountNum,String stockId,double numStocks, double stockPrice,double target, double difference,String priceType
            ps.setDouble(1, target);
            String [][] results = dbi.executePreparedStatement(ps2);
                    for (String[] arr : results) {
                        int sellerId = Integer.parseInt(arr[0]);
                        int accountNum = Integer.parseInt(arr[1]);
                        double numStocks = Double.parseDouble(arr[2]);
                        String orderTime = arr[3];
/*                        addToCOHist(dbi, sellerId, accountNum, stockId, numStocks, (target + difference), target, difference, "trailstop", orderTime); */
                    }
            return true;
        }catch(SQLException s){
            return false;
        }
    }
    
    public static String[][] getCondOrder(DatabaseInterface dbi, String stockId) {
        try{
           PreparedStatement ps = dbi.getConnection().prepareStatement("SELECT Difference, Target FROM ConditionalOrder WHERE StockId = ?;");
           ps.setString(1, stockId);
            return dbi.executePreparedStatement(ps);
        }catch(SQLException s){
            return null;
        }
    }
    /*
    public static boolean addToCOHist(DatabaseInterface dbi, int sellerId, int accountNum,String stockId,double numStocks, double stockPrice,double target, double difference,String priceType, String orderTime){
        try{
        PreparedStatement ps = dbi.getConnection().prepareStatement("INSERT INTO ConditionalHistory (sellerId, accountNum,stockId ,numStocks,stockPrice, target,difference,priceType,orderTime,updateTime) VALUES (?,?,?,?,?,?,?,?,?,NOW())");
        ps.setInt(1, sellerId);
        ps.setInt(2, accountNum);
        ps.setString(3, stockId);
        ps.setDouble(4, numStocks);
        ps.setDouble(5, stockPrice);
        ps.setDouble(6, target);
        ps.setDouble(7, difference);
        ps.setString(8, priceType);
        
        
        Date utilDate;
            try {
                utilDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(orderTime);
                java.sql.Timestamp sqlDate = new java.sql.Timestamp(utilDate.getTime());
                ps.setTimestamp(9,sqlDate);
            } catch (ParseException ex) {
                DebugPrint.println("ParseException");
                Logger.getLogger(QueryMaker.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        
        
        ps.setString(9, orderTime);
        dbi.executePreparedUpdate(ps);
        return true;
        }catch(SQLException s){
            return false;
        }
    }
    */
//    public static String[][] generateSuggestionList(DatabaseInterface dbi, int id) {
//        String[][] types = suggestionInnerPart(dbi, id);
//        try {
//            PreparedStatement ps = dbi.getConnection().prepareStatement("SELECT Name, NumShares, Price FROM Stock S WHERE Type = ? AND NOT EXISTS (SELECT * FROM Ownership O WHERE S.StockId = O.StockId AND O.OwnerId = ?);");
//            ps.set
//        } catch (SQLException s) {
//            DebugPrint.println(s.getMessage() + 
//                " occurred on generation of suggestion list (outer)");
//            return null;
//        }
//    }
}
