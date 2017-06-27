package com.titan.reservation;

import com.titan.cruise.*;
import com.titan.cabin.CabinLocal;
import com.titan.customer.CustomerRemote;

import java.util.Collection;
import javax.ejb.CreateException;
import javax.ejb.FinderException;

// Reservation EJB's local home interface
public interface ReservationHomeLocal extends javax.ejb.EJBLocalHome {

  public ReservationLocal create(CruiseLocal cruise, Collection customers)
                      throws javax.ejb.CreateException;

  public ReservationLocal findByPrimaryKey(Integer primaryKey)
                      throws javax.ejb.FinderException;

  	public ReservationLocal create(CustomerRemote customer, CruiseLocal cruise,
                             CabinLocal cabin, double price, java.sql.Date dateBooked)
		throws javax.ejb.CreateException;

}
