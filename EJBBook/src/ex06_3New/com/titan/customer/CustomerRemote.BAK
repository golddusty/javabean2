package com.titan.customer;

import java.rmi.RemoteException;
import javax.ejb.CreateException;	
import javax.naming.NamingException;	

public interface CustomerRemote extends javax.ejb.EJBObject {

	public void setAddress(String street, String city,
                           String state, String zip) 
		throws RemoteException, CreateException, NamingException;		


	public void setAddress(AddressDO address) 
		throws RemoteException, CreateException, NamingException;		


	public AddressDO getAddress() throws RemoteException;	

    public Name getName() throws RemoteException;
    public void setName(Name name) throws RemoteException;

	public boolean getHasGoodCredit() throws RemoteException;
	public void setHasGoodCredit(boolean flag) throws RemoteException;
	
}
