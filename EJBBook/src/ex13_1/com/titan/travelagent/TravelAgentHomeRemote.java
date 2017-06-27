package com.titan.travelagent;

import java.rmi.RemoteException;
import javax.ejb.CreateException;
import com.titan.customer.CustomerRemote;

public interface TravelAgentHomeRemote extends javax.ejb.EJBHome {

    public TravelAgentRemote create(CustomerRemote cust)
        throws RemoteException, CreateException;

}
