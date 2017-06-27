package com.titan.ship;

import javax.ejb.EntityContext;
import javax.ejb.CreateException;
import java.util.Set;

public abstract class ShipBean implements javax.ejb.EntityBean {
    
	public Integer ejbCreate(Integer primaryKey, String name, double tonnage) throws CreateException{
		System.out.println("ejbCreate");
		setId(primaryKey);
		setName(name);
		setTonnage(tonnage);
		return null;
	}
	
	public void ejbPostCreate(Integer primaryKey, String name, double tonnage) throws CreateException{
	}

    // persistent fields

	public abstract void setId(Integer id);
	public abstract Integer getId();
	public abstract void setName(String name);
	public abstract String getName( );
	public abstract void setTonnage(double tonnage);
	public abstract double getTonnage( );

    public abstract Set getCabins();
    public abstract void setCabins(Set cabins);

    // standard call back methods
    
    public void setEntityContext(EntityContext ec){}
    public void unsetEntityContext(){}
    public void ejbLoad(){}
    public void ejbStore(){}
    public void ejbActivate(){}
    public void ejbPassivate(){}
    public void ejbRemove(){}

}
