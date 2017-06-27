package com.titan.customer;

import com.titan.address.*;

import javax.naming.InitialContext;
import javax.ejb.EJBException;
import javax.ejb.EntityContext;
import javax.ejb.CreateException;	
import javax.naming.NamingException;

public abstract class CustomerBean implements javax.ejb.EntityBean {

	public Integer ejbCreate(Integer id)throws CreateException {
		this.setId(id);
		return null;
	}
	
	public void ejbPostCreate(Integer id) throws CreateException {	}
	
	// business methods
	
	public Name getName() {
		
		Name name = new Name(getLastName(),getFirstName());
		return name;
	}
	
	public void setName(Name name) {
		
		setLastName(name.getLastName());
		setFirstName(name.getFirstName());
	}
	
	public void setAddress(String street, String city, String state, String zip)
		throws EJBException {
		
		AddressLocal addr = this.getHomeAddress( );

		try {

			if (addr == null) {
				// Customer doesn't have an address yet. Create a new one.
				InitialContext cntx = new InitialContext( );
				AddressHomeLocal addrHome = 
							  (AddressHomeLocal)cntx.lookup("java:comp/env/ejb/AddressHomeLocal");
				addr = addrHome.createAddress(street, city, state, zip);
				this.setHomeAddress(addr);
			} else {
			   // Customer already has an address. Change its fields
			   addr.setStreet(street);
			   addr.setCity(city);
			   addr.setState(state);
			   addr.setZip(zip);
			}
		} catch (NamingException ne) {
			throw new EJBException(ne);
		} catch (CreateException ce) {
			throw new EJBException(ce);
		}
	}

	public AddressDO getAddress() {
		
        AddressLocal addrLocal = this.getHomeAddress();
		if (addrLocal == null) return null;
        String street = addrLocal.getStreet();
        String city = addrLocal.getCity();
        String state = addrLocal.getState();
        String zip = addrLocal.getZip();
        AddressDO addrValue = new AddressDO(street,city,state,zip);		
        return addrValue;
    }

    public void setAddress(AddressDO addrValue) 
		throws CreateException, NamingException {		

        String street = addrValue.getStreet();
        String city = addrValue.getCity();
        String state = addrValue.getState();
        String zip = addrValue.getZip();

		setAddress(street,city,state,zip);		
	}

    // persistent relationships

    public abstract AddressLocal getHomeAddress();
    public abstract void setHomeAddress(AddressLocal address);
	
	// abstract accessor methods
	
	public abstract Integer getId();
	public abstract void setId(Integer id);
	
	public abstract String getLastName();
	public abstract void setLastName(String lname);
	
	public abstract String getFirstName();
	public abstract void setFirstName(String fname);
	
	public abstract boolean getHasGoodCredit();
	public abstract void setHasGoodCredit(boolean flag);
	
	// standard call back methods
	
	public void setEntityContext(EntityContext ec){}
	public void unsetEntityContext(){}
	public void ejbLoad(){}
	public void ejbStore(){}
	public void ejbActivate(){}
	public void ejbPassivate(){}
	public void ejbRemove(){}
	
}
