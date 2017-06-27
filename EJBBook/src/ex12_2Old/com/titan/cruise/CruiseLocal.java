package com.titan.cruise;

import com.titan.ship.*;
import java.util.Collection;

// Cruise EJB's local interface
public interface CruiseLocal extends javax.ejb.EJBLocalObject {

    public Integer getId();

    public String getName();
    public void setName(String name);

	public ShipLocal getShip();
	public void setShip(ShipLocal ship);

	public void setReservations(Collection res);
	public Collection getReservations( );

}
