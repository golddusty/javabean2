package com.titan.customer;

import java.rmi.RemoteException;
import javax.ejb.CreateException;   
import javax.naming.NamingException;    
import java.util.Vector;

public interface CustomerRemote extends javax.ejb.EJBObject {

    public void setAddress(String street, String city,
                           String state, String zip) 
        throws RemoteException, CreateException, NamingException;       

    public void setAddress(AddressDO address) 
        throws RemoteException, CreateException, NamingException;       

    public AddressDO getAddress() throws RemoteException;   

    public Name getName() throws RemoteException;
    public void setName(Name name) throws RemoteException;

    public void addPhoneNumber(String number, byte type)
        throws NamingException, CreateException, RemoteException;
    public void removePhoneNumber(byte typeToRemove)
        throws RemoteException;
    public void updatePhoneNumber(String number, byte typeToUpdate)
        throws RemoteException;
	public Vector getPhoneList() throws RemoteException;

    public boolean getHasGoodCredit() throws RemoteException;
    public void setHasGoodCredit(boolean flag) throws RemoteException;

}
