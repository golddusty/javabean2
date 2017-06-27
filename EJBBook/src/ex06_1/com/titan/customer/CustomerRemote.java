package com.titan.customer;

import java.rmi.RemoteException;

public interface CustomerRemote extends javax.ejb.EJBObject {

    public String getLastName() throws RemoteException;
    public void setLastName(String lname) throws RemoteException;
    
    public String getFirstName() throws RemoteException;
    public void setFirstName(String fname) throws RemoteException;

	public boolean getHasGoodCredit() throws RemoteException;
	public void setHasGoodCredit(boolean flag) throws RemoteException;
}
