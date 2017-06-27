package com.titan.customer;

import java.rmi.RemoteException;

public interface CustomerRemote extends javax.ejb.EJBObject {

    public Name getName() throws RemoteException;
    public void setName(Name name) throws RemoteException;
    
	public boolean getHasGoodCredit() throws RemoteException;
	public void setHasGoodCredit(boolean flag) throws RemoteException;
}
