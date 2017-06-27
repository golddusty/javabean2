package com.titan.cabin;

import com.titan.ship.*;
import com.titan.customer.CustomerLocal;

import javax.ejb.EntityContext;
import javax.ejb.CreateException;
import javax.ejb.FinderException;
import java.util.Set;

public abstract class CabinBean implements javax.ejb.EntityBean {

	public Integer ejbCreate(Integer id) throws CreateException{
		this.setId(id);
		return null; 
	}
	public void ejbPostCreate(Integer id) throws CreateException {
		
	}


	public abstract Set ejbSelectAllForCustomer(CustomerLocal cust)
		throws FinderException;

	// Public Home method required to test the private ejbSelectAllForCustomer method
	public Set ejbHomeSelectAllForCustomer(CustomerLocal cust)
		throws FinderException {
		return this.ejbSelectAllForCustomer(cust);
	}

	public abstract void setId(Integer id);
	public abstract Integer getId();
 
//	public abstract void setShip(ShipLocal ship);
//	public abstract ShipLocal getShip();

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
