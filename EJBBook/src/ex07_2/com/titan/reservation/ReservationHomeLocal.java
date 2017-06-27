package com.titan.reservation;

import com.titan.cruise.*;

import java.util.Collection;
import javax.ejb.CreateException;
import javax.ejb.FinderException;

// Reservation EJB's local home interface
public interface ReservationHomeLocal extends javax.ejb.EJBLocalHome {

  public ReservationLocal create(CruiseLocal cruise, Collection customers)
                      throws javax.ejb.CreateException;

  public ReservationLocal findByPrimaryKey(Integer primaryKey)
                      throws javax.ejb.FinderException;

}
