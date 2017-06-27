package com.titan.customer;

import javax.ejb.CreateException;
import javax.ejb.FinderException;
import java.util.Date;

// CreditCard EJB's local home interface
public interface CreditCardHomeLocal extends javax.ejb.EJBLocalHome {

  public CreditCardLocal create(Date exp, String numb, String name, String org)
                      throws javax.ejb.CreateException;

  public CreditCardLocal findByPrimaryKey(Object primaryKey)
                      throws javax.ejb.FinderException;

}
