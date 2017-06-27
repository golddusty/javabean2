package com.titan.cabin;

import com.titan.customer.CustomerLocal;

import javax.ejb.CreateException;
import javax.ejb.FinderException;
import java.util.Collection;
import java.util.Set;

public interface CabinHomeLocal extends javax.ejb.EJBLocalHome {

    public CabinLocal create(Integer id)
        throws CreateException;

    public CabinLocal findByPrimaryKey(Integer pk)
        throws FinderException;

    public abstract Collection findAllOnDeckLevel(Integer level)
		throws FinderException;

    // Home method, requires ejbHomeSelectAllForCustomer method in bean class
    public Set selectAllForCustomer(CustomerLocal cust)
        throws FinderException;

}
