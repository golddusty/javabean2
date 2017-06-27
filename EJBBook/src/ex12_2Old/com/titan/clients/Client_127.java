package com.titan.clients;					

import com.titan.travelagent.*;
import com.titan.processpayment.*;
import com.titan.customer.*;

import javax.naming.InitialContext;
import javax.rmi.PortableRemoteObject;
import javax.naming.Context;
import javax.naming.NamingException;
import java.util.*;

/**
 * Lists available cabins for a specific Cruise having a desired number of beds
 * Uses command-line parameters:   
 *   java com.titan.clients.Client_127 <cruiseID> <bedCount>
 * 
 */

public class Client_127 {

	public static void main(String [] args) throws Exception {


		if (args.length != 2) {
			System.out.println("Usage: java com.titan.clients.Client_127 <cruiseID> <bedCount>");
			System.exit(-1);
		}

		Integer cruiseID = new Integer(args[0]);
		int bedCount = new Integer(args[1]).intValue();

		Context jndiContext = getInitialContext();
		Object obj = jndiContext.lookup("TravelAgentHomeRemote");
		TravelAgentHomeRemote tahome = (TravelAgentHomeRemote) 
			javax.rmi.PortableRemoteObject.narrow(obj, TravelAgentHomeRemote.class);

		// Start the Stateful session bean
		System.out.println("Starting TravelAgent Session...");
		TravelAgentRemote tagent = tahome.create(null);

		// Set the other bean parameters in agent bean
		System.out.println("Setting Cruise information in TravelAgent..");
		tagent.setCruiseID(cruiseID);

		String[] results = tagent.listAvailableCabins(bedCount);

		System.out.println("Ending TravelAgent Session...");
		tagent.remove();

		System.out.println("Result of listAvailableCabins:");
		for (int kk=0; kk<results.length; kk++) {
			System.out.println(results[kk]);
		}
					
    }
    
    public static Context getInitialContext() 
                          throws javax.naming.NamingException {
		Properties p = new Properties();
		return new InitialContext(p);
    }

}
