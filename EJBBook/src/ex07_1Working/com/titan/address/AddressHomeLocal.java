package com.titan.address;

import javax.ejb.CreateException;
import javax.ejb.FinderException;

// Address EJB's local home interface
public interface AddressHomeLocal extends javax.ejb.EJBLocalHome {  

  public AddressLocal createAddress(Integer id,String street, String city,
									String state,  String zip )
                      throws javax.ejb.CreateException;

  public AddressLocal findByPrimaryKey(Integer primaryKey)
                      throws javax.ejb.FinderException;
  
}
