package com.titan.customer;

import java.rmi.RemoteException;
import javax.ejb.CreateException;
import javax.ejb.FinderException;

public interface CustomerHomeRemote extends javax.ejb.EJBHome {
    
    public CustomerRemote create(Integer id)
    throws CreateException, RemoteException;
    
    public CustomerRemote findByPrimaryKey(Integer id)
    throws FinderException, RemoteException;
    

}

