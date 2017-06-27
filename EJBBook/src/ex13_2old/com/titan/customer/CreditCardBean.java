package com.titan.customer;

import javax.ejb.EntityContext;
import java.util.Date;

public abstract class CreditCardBean implements javax.ejb.EntityBean {
    
    public Object ejbCreate
                         (Date exp, String numb, String name, String org)
    {
		System.out.println("ejbCreate");
		 setExpirationDate(exp);
         setNumber(numb);
         setNameOnCard(name);
         setCreditOrganization(org);
         return null;
    }

    public void ejbPostCreate
                     (Date exp, String numb, String name, String org) {
		System.out.println("ejbPostCreate");
    }

	// relationship fields

    public abstract CustomerLocal getCustomer( );	
    public abstract void setCustomer(CustomerLocal cust);	

    // persistent fields


	public abstract Integer getId();
	public abstract void setId(Integer id);
    public abstract Date getExpirationDate();
    public abstract void setExpirationDate(Date date);
    public abstract String getNumber();
    public abstract void setNumber(String number);
    public abstract String getNameOnCard();
    public abstract void setNameOnCard(String name);
    public abstract String getCreditOrganization();
    public abstract void setCreditOrganization(String org);

    // standard call back methods
    
    public void setEntityContext(EntityContext ec){}
    public void unsetEntityContext(){}
    public void ejbLoad(){}
    public void ejbStore(){}
    public void ejbActivate(){}
    public void ejbPassivate(){}
    public void ejbRemove(){}

}
