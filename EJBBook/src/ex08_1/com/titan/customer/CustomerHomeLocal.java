package com.titan.customer;

import javax.ejb.CreateException;
import javax.ejb.FinderException;
import java.util.Collection;

public interface CustomerHomeLocal extends javax.ejb.EJBLocalHome {

    public CustomerLocal create(Integer id)
        throws CreateException;

    public CustomerLocal findByPrimaryKey(Integer id)
        throws FinderException;

	public CustomerLocal findByName(String lastName, String firstName)
		throws FinderException;

	public Collection findByGoodCredit()
		throws FinderException;

	public Collection findByCity(String city, String state)
		throws FinderException;

}

