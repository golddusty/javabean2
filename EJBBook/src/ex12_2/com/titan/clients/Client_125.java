package com.titan.clients;					

import com.titan.travelagent.*;

import javax.naming.InitialContext;
import javax.rmi.PortableRemoteObject;
import javax.naming.Context;
import javax.naming.NamingException;
import java.util.Properties;
import java.util.*;

/**
 * Creates Customer, Cabin, Ship, and Cruise objects for use in this exercise and the following exercises
 * 
 */

public class Client_125 {

	public static void main(String [] args) throws Exception {

		Context jndiContext = getInitialContext();
		Object obj = jndiContext.lookup("TravelAgentHomeRemote");
		TravelAgentHomeRemote tahome = (TravelAgentHomeRemote) 
			javax.rmi.PortableRemoteObject.narrow(obj, TravelAgentHomeRemote.class);

		TravelAgentRemote tagent = tahome.create(null);

		System.out.println("Calling TravelAgentBean to create sample data..");

		Collection results = tagent.buildSampleData();									
		
		tagent.remove();
	
		Iterator iterator = results.iterator();
		while (iterator.hasNext()) {
			String ss = (String)(iterator.next());
			System.out.println(ss);
		}
    }
    
    public static Context getInitialContext() 
                          throws javax.naming.NamingException {
		Properties p = new Properties();
		p.put(Context.INITIAL_CONTEXT_FACTORY, "weblogic.jndi.WLInitialContextFactory");  
		p.put(Context.PROVIDER_URL, "t3://localhost:7001");
		return new InitialContext(p);
    }

}
