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
 * Books passage for a Customer on a particular Cruise in a specified Cabin
 * Uses command-line parameters:   
 *   java com.titan.clients.Client_126 <customerID> <cruiseID> <cabinID> <price>
 * 
 */

public class Client_126 {

	public static void main(String [] args) throws Exception {


		if (args.length != 4) {
			System.out.println("Usage: java com.titan.clients.Client_126 <customerID> <cruiseID> <cabinID> <price>");
			System.exit(-1);
		}

		Integer customerID = new Integer(args[0]);
		Integer cruiseID = new Integer(args[1]);
		Integer cabinID = new Integer(args[2]);
		double price = new Double(args[3]).doubleValue();

		Context jndiContext = getInitialContext();
		Object obj = jndiContext.lookup("TravelAgentHomeRemote");
		TravelAgentHomeRemote tahome = (TravelAgentHomeRemote) 
			javax.rmi.PortableRemoteObject.narrow(obj, TravelAgentHomeRemote.class);

		obj = jndiContext.lookup("CustomerHomeRemote");
		CustomerHomeRemote custhome = (CustomerHomeRemote) 
			javax.rmi.PortableRemoteObject.narrow(obj, CustomerHomeRemote.class);

		
		// Find a reference to the Customer for which to book a cruise
		System.out.println("Finding reference to Customer "+customerID);
		CustomerRemote cust = custhome.findByPrimaryKey(customerID);

		// Start the Stateful session bean
		System.out.println("Starting TravelAgent Session...");
		TravelAgentRemote tagent = tahome.create(cust);

		// Set the other bean parameters in agent bean
		System.out.println("Setting Cruise and Cabin information in TravelAgent..");
		tagent.setCruiseID(cruiseID);
		tagent.setCabinID(cabinID);

		// Create a dummy CreditCard for this.  Really should use Customer's card, but CreditCard bean is local
		// and there is no getCreditCard() function on Customer which returns a CreditCardDO object.
		Calendar expdate = Calendar.getInstance();
		expdate.set(2005,1,5);
		CreditCardDO card = new CreditCardDO("370000000000002",expdate.getTime(),"AMERICAN EXPRESS");

		// Book the passage
		System.out.println("Booking the passage on the Cruise!");
		TicketDO ticket = tagent.bookPassage(card,price);

		System.out.println("Ending TravelAgent Session...");
		tagent.remove();

		System.out.println("Result of bookPassage:");
		System.out.println(ticket.description);
					
    }
    
    public static Context getInitialContext() 
                          throws javax.naming.NamingException {
		Properties p = new Properties();
		p.put(Context.INITIAL_CONTEXT_FACTORY, "weblogic.jndi.WLInitialContextFactory");  
		p.put(Context.PROVIDER_URL, "t3://localhost:7001");
		return new InitialContext(p);
    }

}
