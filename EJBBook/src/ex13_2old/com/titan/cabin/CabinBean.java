package com.titan.cabin;

import com.titan.ship.*;

import javax.ejb.EntityContext;

public abstract class CabinBean implements javax.ejb.EntityBean {

	public Integer ejbCreate(Integer id) {
		this.setId(id);
		return null; 
	}

	public void ejbPostCreate(Integer id) {
		
	}

	public Integer ejbCreate(Integer id, ShipLocal ship, String name, int count, int level) {
		this.setId(id);
		this.setName(name);
		this.setBedCount(count);
		this.setDeckLevel(level);
		return null; 
	}

	public void ejbPostCreate(Integer id, ShipLocal ship, String name, int count, int level) {
		this.setShip(ship);		
	}

	public abstract void setId(Integer id);
	public abstract Integer getId();
 
	public abstract void setShip(ShipLocal ship);
	public abstract ShipLocal getShip( );

	public abstract void setName(String name);
	public abstract String getName( );

	public abstract void setBedCount(int count);
	public abstract int getBedCount( );

	public abstract void setDeckLevel(int level);
	public abstract int getDeckLevel( );

    public void setEntityContext(EntityContext ctx) {
         // Not implemented.
    }
    public void unsetEntityContext() {
         // Not implemented.
    }
    public void ejbActivate() {
        // Not implemented.
    }
    public void ejbPassivate() {
        // Not implemented.
    }
    public void ejbLoad() {
        // Not implemented.
    }
    public void ejbStore() {
        // Not implemented.
    }
    public void ejbRemove() {
        // Not implemented.
    }
}
