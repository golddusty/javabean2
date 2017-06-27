package com.titan.travelagent;

import com.titan.cruise.CruiseLocal;
import com.titan.cabin.CabinLocal;
import com.titan.customer.CustomerRemote;
import com.titan.customer.Name;

import java.rmi.RemoteException;

public class TicketDO implements java.io.Serializable {

	public Integer customerID;
	public Integer cruiseID;
	public Integer cabinID;
	public double price;
	public String description;
	
	public TicketDO(CustomerRemote customer, 
					CruiseLocal cruise, CabinLocal cabin, 
					double amount)
	throws javax.ejb.FinderException, java.rmi.RemoteException,  
		   javax.naming.NamingException {
		
		Name custname = customer.getName();
		description = custname.getFirstName()+
		   " " + custname.getLastName() + 
		   " has been booked for the "
		   + cruise.getName() + 
		   " cruise on ship " + 
			 cruise.getShip().getName() + ".\n" +  
		   " Your accommodations include " + 
			 cabin.getName() + 
		   " a " + cabin.getBedCount() + 
		   " bed cabin on deck level " + cabin.getDeckLevel() + 
		   ".\n Total charge = " + amount;
		customerID = (Integer)customer.getPrimaryKey();
		cruiseID = (Integer)cruise.getPrimaryKey();
		cabinID = (Integer)cabin.getPrimaryKey();
		price = amount;
	}
		
	public String toString() {
		return description;
	}
}
