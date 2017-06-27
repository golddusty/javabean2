package com.titan.clients;					

import com.titan.customer.CustomerHomeRemote;		
import com.titan.customer.CustomerRemote;			
import com.titan.customer.Name;			
import com.titan.customer.AddressDO;			

import javax.naming.InitialContext;
import javax.rmi.PortableRemoteObject;
import javax.naming.Context;
import javax.naming.NamingException;
import java.util.Properties;

/**
 * Create a Customer and Address for use by subsequent programs in this exercise
 * 
 */

public class Client_121 {

	public static void main(String [] args) throws Exception {

		// obtain CustomerHome
		Context jndiContext = getInitialContext();
		Object obj = jndiContext.lookup("java:/comp/env/ejb/CustomerHomeRemote");
		CustomerHomeRemote home = (CustomerHomeRemote) 
			javax.rmi.PortableRemoteObject.narrow(obj, CustomerHomeRemote.class);

		System.out.println("Creating Customer 1..");
		// create a Customer
		Integer primaryKey = new Integer(1);
		CustomerRemote customer = home.create(primaryKey);
		 
		// create an address data object
		System.out.println("Creating AddressDO data object..");
		AddressDO address = new AddressDO("1010 Colorado",	
									  "Austin", "TX", "78701");
		
		// set address in Customer bean
		System.out.println("Setting Address in Customer 1...");
		customer.setAddress(address);
	   
		System.out.println("Acquiring Address data object from Customer 1...");
		address = customer.getAddress();

		System.out.println("Customer 1 Address data: ");
		System.out.println(address.getStreet( ));
		System.out.println(address.getCity( )+","+
						   address.getState()+" "+
						   address.getZip());
											
							
    }
    
    public static Context getInitialContext() 
                          throws javax.naming.NamingException {
		return new InitialContext();
    }

}
