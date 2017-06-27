package com.titan.customer;

import com.titan.cruise.CruiseLocal;

import javax.ejb.CreateException;
import javax.ejb.FinderException;
import java.util.Collection;

public interface CustomerHomeLocal extends javax.ejb.EJBLocalHome {

    public CustomerLocal create(Integer id)
        throws CreateException;

    public CustomerLocal findByPrimaryKey(Integer id)
        throws FinderException;

	public CustomerLocal findByExactName(String lastName, String firstName)
		throws FinderException;

	public Collection findByName(String lastName, String firstName)
		throws FinderException;

	public Collection findByNameAndState(String lastName, String firstName, String state)
		throws FinderException;

	public Collection findByGoodCredit()
		throws FinderException;

	public Collection findByCity(String city, String state)
		throws FinderException;

    	public Collection findInHotStates()
		throws FinderException;

	public Collection findWithNoReservations()
		throws FinderException;

	public Collection findOnCruise(CruiseLocal cruise)
		throws FinderException;

	public Collection findByState(String state)
		throws FinderException;

}

