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
public class Session {
    final int sessionId;
    final int userId;

    public Session(int userId, SessionPermission permission) {
        int tempId=-1;
        do{
            tempId=(int)(Math.random()*Integer.MAX_VALUE);
            
        }while( SessionManager.existsSession(tempId));
        this.sessionId = tempId;
        this.userId = userId;
        this.permission = permission;
        this.expirationTime = System.currentTimeMillis()+this.sessionTimeMilliSeconds;
    }
    public String getCookieValue(){
        return userId+","+sessionId;
    }
    
  
    public void refreshSession(){
          this.expirationTime = System.currentTimeMillis()+this.sessionTimeMilliSeconds;
    }
    public final long sessionTimeMilliSeconds = 600000;
    private SessionPermission permission;
    private long expirationTime;

    public SessionPermission getPermission() {
        return permission;
    }

    public long getExpirationTime() {
        return expirationTime;
    }
    
}
