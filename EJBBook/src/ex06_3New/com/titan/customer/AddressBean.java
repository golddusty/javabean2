package com.titan.customer;

import javax.ejb.EntityContext;
import javax.ejb.CreateException;
public abstract class AddressBean implements javax.ejb.EntityBean {		
    
    public Integer ejbCreateAddress
                         (Integer addressID,String street, String city, 
                          String state,  String zip ) throws javax.ejb.CreateException
    {
		 setId(addressID);
		 setStreet(street);
         setCity(city);
         setState(state);
         setZip(zip);
         return getId();
    }

    public void ejbPostCreateAddress
                     (Integer addressID, String street, String city,
                      String state,  String zip)throws javax.ejb.CreateException
{
    }

    // persistent fields
	public abstract Integer getId();
	public abstract void setId(Integer id);
    public abstract String getStreet();
    public abstract void setStreet(String street);
    public abstract String getCity();
    public abstract void setCity(String city);
    public abstract String getState();
    public abstract void setState(String state);
    public abstract String getZip();
    public abstract void setZip(String zip);

    // standard call back methods
    
    public void setEntityContext(EntityContext ec){}
    public void unsetEntityContext(){}
    public void ejbLoad(){}
    public void ejbStore(){}
    public void ejbActivate(){}
    public void ejbPassivate(){}
    public void ejbRemove(){}

}
