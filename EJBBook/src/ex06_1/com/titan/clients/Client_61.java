package com.titan.clients;					

import com.titan.customer.CustomerHomeRemote;		
import com.titan.customer.CustomerRemote;			

import javax.naming.InitialContext;
import javax.rmi.PortableRemoteObject;
import javax.naming.Context;
import javax.naming.NamingException;
import java.util.Properties;

/**
 * Example which creates and removes CustomerEJB beans
 * 
 */
public class Client_61 {

    public static void main(String [] args) {

		try {

			if (args.length<3 || args.length%3!=0) {
				System.out.println("Usage: java com.titan.clients.Client_61 <pk1> <fname1> <lname1> ...");
				System.exit(-1);
			}

            // obtain CustomerHome
            Context jndiContext = getInitialContext();
            Object obj = jndiContext.lookup("CustomerHomeRemote");
            CustomerHomeRemote home = (CustomerHomeRemote) 
				PortableRemoteObject.narrow(obj, CustomerHomeRemote.class);
            
            // create Customers
            for(int i = 0; i < args.length; i++) {
                Integer primaryKey = new Integer(args[i]);
                String firstName = args[++i];
                String lastName = args[++i];
                CustomerRemote customer = home.create(primaryKey);
                customer.setFirstName(firstName);
                customer.setLastName(lastName);
                customer.setHasGoodCredit(true);
            }

            // find and remove Customers
            for(int i = 0; i < args.length; i+=3) {	
                Integer primaryKey = new Integer(args[i]);
                CustomerRemote customer = home.findByPrimaryKey(primaryKey);
                String lastName = customer.getLastName( );
                String firstName = customer.getFirstName( );
                System.out.print(primaryKey+" = ");
                System.out.println(firstName+" "+lastName);

                // remove Customer
                customer.remove();
            }
            

        } catch (java.rmi.RemoteException re){re.printStackTrace();}
          catch (Throwable t){t.printStackTrace();}
          System.exit(0);
          
   }
    
    public static Context getInitialContext() 
                          throws javax.naming.NamingException {
		return new InitialContext();
    }
}

