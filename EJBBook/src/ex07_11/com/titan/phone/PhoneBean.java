package com.titan.phone;

import javax.ejb.EntityContext;
import java.util.Date;

public abstract class PhoneBean implements javax.ejb.EntityBean {
    
    public Object ejbCreate(String number, byte type)
    {
		System.out.println("ejbCreate");
         setNumber(number);
         setType(type);
         return null;
    }

    public void ejbPostCreate(String number, byte type) {
		System.out.println("ejbPostCreate");
    }

    // persistent fields

	public abstract Integer getId();
	public abstract void setId(Integer id);
    public abstract String getNumber();
    public abstract void setNumber(String number);
    public abstract byte getType();
    public abstract void setType(byte type);

    // standard call back methods
    
    public void setEntityContext(EntityContext ec){}
    public void unsetEntityContext(){}
    public void ejbLoad(){}
    public void ejbStore(){}
    public void ejbActivate(){}
    public void ejbPassivate(){}
    public void ejbRemove(){}

}
