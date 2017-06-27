package com.titan.reservation;

import com.titan.cruise.*;

import java.util.Date;
import java.util.Set;

// Reservation EJB's local interface
public interface ReservationLocal extends javax.ejb.EJBLocalObject {

    public Date getDate();
    public void setDate(Date date);

    public double getAmountPaid();
    public void setAmountPaid(double amount);

	public CruiseLocal getCruise();
    public void setCruise(CruiseLocal cruise);

	public Set getCabins( );
	public void setCabins(Set customers);

	public Set getCustomers( );
	public void setCustomers(Set customers);

}
