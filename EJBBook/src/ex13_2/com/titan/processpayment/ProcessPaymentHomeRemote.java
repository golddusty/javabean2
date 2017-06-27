package com.titan.processpayment;

import java.rmi.RemoteException;
import javax.ejb.CreateException;

public interface ProcessPaymentHomeRemote extends javax.ejb.EJBHome {

    public ProcessPaymentRemote create()
        throws RemoteException, CreateException;

}
