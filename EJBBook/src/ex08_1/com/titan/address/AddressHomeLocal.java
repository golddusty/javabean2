package com.titan.address;

import com.titan.customer.CustomerLocal;

import javax.ejb.CreateException;
import javax.ejb.FinderException;
import java.util.Collection;

// Address EJB's local home interface
public interface AddressHomeLocal extends javax.ejb.EJBLocalHome {  

  public AddressLocal createAddress(String street, String city, 
									String state,  String zip )
                      throws javax.ejb.CreateException;

  public AddressLocal findByPrimaryKey(Integer primaryKey)
                      throws javax.ejb.FinderException;

    // Home method, requires ejbHomeSelectZipCodes method in bean class
  public Collection selectZipCodes(String state)
                      throws javax.ejb.FinderException;

  // Home method, requires ejbHomeSelectCustomer method in bean class
  public CustomerLocal selectCustomer(AddressLocal addr)
                      throws javax.ejb.FinderException;

}
