package com.titan.phone;

import javax.ejb.CreateException;
import javax.ejb.FinderException;

// Phone EJB's local home interface
public interface PhoneHomeLocal extends javax.ejb.EJBLocalHome {

  public PhoneLocal create(String number, byte type)
                      throws javax.ejb.CreateException;

  public PhoneLocal findByPrimaryKey(Object primaryKey)
                      throws javax.ejb.FinderException;

}
