package com.titan.ship;

import javax.ejb.CreateException;
import javax.ejb.FinderException;

// Ship EJB's local home interface
public interface ShipHomeLocal extends javax.ejb.EJBLocalHome {

  public ShipLocal create(Integer primaryKey, String name, double tonnage)
                      throws javax.ejb.CreateException;

  public ShipLocal findByPrimaryKey(Object primaryKey)
                      throws javax.ejb.FinderException;

}
