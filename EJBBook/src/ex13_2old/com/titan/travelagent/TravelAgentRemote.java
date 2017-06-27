package com.titan.travelagent;

import java.rmi.RemoteException;
import javax.ejb.FinderException;
import javax.ejb.CreateException;
import com.titan.cruise.CruiseLocal;
import com.titan.customer.CustomerRemote;
import com.titan.processpayment.CreditCardDO;
import java.util.*;

public interface TravelAgentRemote extends javax.ejb.EJBObject {

	public void setCruiseID(Integer cruise) 
		throws RemoteException, FinderException;

	public void setCabinID(Integer cabin) 
		throws RemoteException, FinderException;

	public TicketDO bookPassage(CreditCardDO card, double price)
		throws RemoteException, IncompleteConversationalState;   

    public String [] listAvailableCabins(int bedCount)
        throws RemoteException, IncompleteConversationalState;

	// Mechanism for building local beans for example programs.  Returns Collection of String messages.
	public Collection buildSampleData() throws RemoteException;

}
