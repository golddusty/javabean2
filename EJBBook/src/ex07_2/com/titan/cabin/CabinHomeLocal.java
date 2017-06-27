package com.titan.cabin;

import javax.ejb.CreateException;
import javax.ejb.FinderException;

public interface CabinHomeLocal extends javax.ejb.EJBLocalHome {

    public CabinLocal create(Integer id)
        throws CreateException;

    public CabinLocal findByPrimaryKey(Integer pk)
        throws FinderException;

}
