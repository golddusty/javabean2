package com.titan.customer;

import javax.ejb.EntityContext;
import javax.ejb.CreateException;

public abstract class CustomerBean implements javax.ejb.EntityBean {

	public Integer ejbCreate(Integer id) throws CreateException{
		this.setId(id);
		return null;
	}

	public void ejbPostCreate(Integer id) throws CreateException{
	}

    // business methods

    public Name getName() {
        Name name = new Name(getLastName(),getFirstName());
        return name;
    }
    public void setName(Name name) {
        setLastName(name.getLastName());
        setFirstName(name.getFirstName());
    }

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
