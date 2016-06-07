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
public enum SessionPermission {
    admin(4),
    manager(3),
    employee(2),
    client(1);
    SessionPermission(int level){
        this.level=level;
    }
    final int level;

    public int getLevel() {
        return level;
    }
}
