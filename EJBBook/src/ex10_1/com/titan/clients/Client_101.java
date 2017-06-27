package com.titan.clients;

import com.titan.ship.*;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.naming.NamingException;
import javax.rmi.PortableRemoteObject;
import java.rmi.RemoteException;
import java.util.Properties;

public class Client_101 {

    public static void main(String [] args) {

        try {
            Context jndiContext = getInitialContext();
            Object ref = jndiContext.lookup("ShipHomeRemote");
            ShipHomeRemote home = (ShipHomeRemote)
				PortableRemoteObject.narrow(ref,ShipHomeRemote.class);
            System.out.println("Creating Ship 101..");

            ShipRemote ship1 = home.create(new Integer(101),"Edmund Fitzgerald");

			ship1.setTonnage(50000.0);
			ship1.setCapacity(300);
               
            Integer pk = new Integer(101);

           System.out.println("Finding Ship 101 again..");
           ShipRemote ship2 = home.findByPrimaryKey(pk);
           System.out.println(ship2.getName());
           System.out.println(ship2.getTonnage());
           System.out.println(ship2.getCapacity());

          System.out.println("Removing Ship 101..");
          ship2.remove();

        }
        catch (java.rmi.RemoteException re){re.printStackTrace();}
        catch (javax.naming.NamingException ne){ne.printStackTrace();}
        catch (javax.ejb.CreateException ce){ce.printStackTrace();}
        catch (javax.ejb.FinderException fe){fe.printStackTrace();}
        catch (javax.ejb.RemoveException re){re.printStackTrace();}
       finally
       {
            System.exit(0);
       }
    }

    public static Context getInitialContext() 
        throws javax.naming.NamingException
    {

                   return new InitialContext();
    }
}
