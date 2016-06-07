/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Data;

import java.util.HashMap;

/**
 *
 * @author Dan
 */
public class SessionManager {
    private static HashMap<Integer, Session> sessions = new HashMap();
    public static String createSession(int userId, String password){
       SessionPermission sp = QueryMaker.getPermission(StaticConnection.getDbi(),userId,password);
       if(sp==null)
           return null;
       Session s = new Session(userId, sp);
       sessions.put(s.sessionId, s);
       return s.getCookieValue();
    }
    public static boolean existsSession(int id){
        return(sessions.containsKey(id));
            
    }
    public static void removeExpiredSessions(){
        Session [] allSessions=new Session[1];//array of minimum size 1 because initialization because why not
        allSessions=sessions.values().toArray(allSessions);
        for(Session s: allSessions){
            if(s!=null && s.getExpirationTime()<System.currentTimeMillis())
                sessions.remove(s.sessionId);
        }
    }
    public static boolean checkCookie(String value){
        
        try{
            DebugPrint.println("Checking cookie:"+value);
            String id=value.substring(0,value.indexOf(","));
            String sessionId=value.substring(value.indexOf(",")+1);
           return sessions.get(Integer.parseInt(sessionId)).userId==Integer.parseInt(id)&&sessions.get(Integer.parseInt(sessionId)).getExpirationTime()>System.currentTimeMillis();
               
        }
        catch(Exception e){
            DebugPrint.println("Exception on check: "+e.getMessage());
            return false;
        }
    }
    public static SessionPermission getPermission(String value){
        String sessionId=value.substring(value.indexOf(",")+1);
          return sessions.get(Integer.parseInt(sessionId)).getPermission();
    }
    public static void refreshSession(String value){
        String sessionId=value.substring(value.indexOf(",")+1);
           sessions.get(Integer.parseInt(sessionId)).refreshSession();
    }
    
    public static void logoutSession(String value){
        try{
          String sessionId=value.substring(value.indexOf(",")+1);
          sessions.remove(Integer.parseInt(sessionId));
        }
        finally{}
    }
    public static int getUserId(String value){
        return Integer.parseInt(value.substring(0,value.indexOf(",")));
    }
}
