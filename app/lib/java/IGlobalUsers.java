package mireka.login;

import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

// EXT: mireka.login.GlobalUsers
// ADDED: void removeUser(String name)

/**
 * GlobalUsers is a simple collection of GlobalUser instances, this class is
 * useful in CDI XML configuration.
 */
public class IGlobalUsers extends GlobalUsers {
    private final Set<GlobalUser> users = new HashSet<GlobalUser>();

    @Override
    public Iterator<GlobalUser> iterator() {
        return users.iterator();
    }
    
    @Override
    public void addUser(GlobalUser user) {
        if (user == null)
            throw new NullPointerException();
        if (users.contains(user))
            throw new IllegalArgumentException("User "
                    + user.getUsernameObject() + " already included");

        users.add(user);
    }
    
    @Override
    public void setUsers(List<GlobalUser> users) {
        this.users.clear();

        for (GlobalUser user : users)
            addUser(user);
    }
    
    public void removeUser(String name) {
        GlobalUser u = null;
        for (GlobalUser user : users){
            if(user.getUsernameObject().toString().equals(name)){
                u = user;
            }
        }
        if(u != null)
            users.remove(u);
        
    }

}