package com.titan.processpayment;

import java.rmi.RemoteException;
import java.util.Date;
import com.titan.customer.CustomerRemote;

public interface ProcessPaymentRemote extends javax.ejb.EJBObject {

    public boolean byCheck(CustomerRemote customer, CheckDO check, double amount)
      throws RemoteException, PaymentException;

    public boolean byCash(CustomerRemote customer, double amount)
      throws RemoteException, PaymentException;

    public boolean byCredit(CustomerRemote customer, CreditCardDO card, double amount)
      throws RemoteException, PaymentException;
}
