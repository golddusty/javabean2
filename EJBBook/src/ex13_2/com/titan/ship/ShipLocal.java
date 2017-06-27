package com.titan.ship;

import java.util.Set;

// Ship EJB's local interface
public interface ShipLocal extends javax.ejb.EJBLocalObject {

	public Integer getId();
	public void setId(Integer id);
    public String getName();
    public void setName(String name);
    public double getTonnage();
    public void setTonnage(double tonnage);

    public void setCabins(Set cabins);
    public Set getCabins();


}
