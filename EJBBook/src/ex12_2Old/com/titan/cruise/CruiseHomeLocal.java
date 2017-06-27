package com.titan.cruise;

import com.titan.ship.*;
import javax.ejb.CreateException;
import javax.ejb.FinderException;

// Cruise EJB's local home interface
public interface CruiseHomeLocal extends javax.ejb.EJBLocalHome {

  public CruiseLocal create(String name, ShipLocal ship)
                      throws javax.ejb.CreateException;

  public CruiseLocal findByPrimaryKey(Object primaryKey)
                      throws javax.ejb.FinderException;

}
