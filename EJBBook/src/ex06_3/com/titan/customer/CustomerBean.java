package com.titan.customer;

import javax.naming.InitialContext;
import javax.ejb.EntityContext;
import javax.ejb.CreateException;	
import javax.naming.NamingException;

public abstract class CustomerBean implements javax.ejb.EntityBean {
        
    

	public Integer ejbCreate(Integer id) throws CreateException
	{
		this.setId(id);
		return getId();
	}
	
	public void ejbPostCreate(Integer id) throws CreateException
	{
	}
	
	// business methods
	
	public Name getName() 
	{
		
		Name name = new Name(getLastName(),getFirstName());
		return name;
	}
	
	public void setName(Name name) {
		
		setLastName(name.getLastName());
		setFirstName(name.getFirstName());
	}
	
	public void setAddress(Integer addressID, String street, String city, String state, String zip)
		throws CreateException, NamingException
		{
		AddressLocal addr = this.getHomeAddress();

        
        if (addr == null) {
			// Customer doesn't have an address yet. Create a new one.
			InitialContext cntx = new InitialContext();
			AddressHomeLocal addrHome = 
                       (AddressHomeLocal)cntx.lookup("java:comp/env/ejb/AddressHomeLocal");		
        	addr = addrHome.createAddress(addressID,street, city, state, zip);
			this.setHomeAddress(addr);
        } else {
           // Customer already has an address. Change its fields
           addr.setStreet(street);
           addr.setCity(city);
           addr.setState(state);
           addr.setZip(zip);
           //addr.setId(addressID);
        }
        
	}

	public AddressDO getAddress(){
		
        AddressLocal addrLocal = this.getHomeAddress();		// TODO THIS SHOULD WORK BUT RETURNS NULL
        Integer addressID = addrLocal.getId();
        String street = addrLocal.getStreet();
        String city = addrLocal.getCity();
        String state = addrLocal.getState();
        String zip = addrLocal.getZip();
        AddressDO addrValue = new AddressDO(addressID,street,city,state,zip);		
        return addrValue;
    }

    public void setAddress(AddressDO addrValue) 
		throws CreateException, NamingException {		

        String street = addrValue.getStreet();
        String city = addrValue.getCity();
        String state = addrValue.getState();
        String zip = addrValue.getZip();
        Integer addressID = addrValue.getId();

		setAddress(addressID, street,city,state,zip);		
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
	
	// for cmr fields for 1-1 relationship
   //public abstract Integer getAddressId();
  // public abstract void setAddressId(Integer addressID );
	
	// standard call back methods
	
	public void setEntityContext(EntityContext ec){
	    context = ec;
	    }
	public void unsetEntityContext(){}
	public void ejbLoad(){}
	public void ejbStore(){}
	public void ejbActivate(){}
	public void ejbPassivate(){}
	public void ejbRemove(){}
	private EntityContext context;
	
}
