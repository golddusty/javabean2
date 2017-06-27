package com.titan.customer;

import javax.ejb.CreateException;
import javax.ejb.FinderException;

public interface CustomerHomeLocal extends javax.ejb.EJBLocalHome {
    
    public CustomerLocal create(Integer id)
        throws CreateException;
    
    public CustomerLocal findByPrimaryKey(Integer id)
        throws FinderException;
    
}

