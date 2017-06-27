package com.titan.cabin;

import javax.ejb.EJBException;

public interface CabinLocal extends javax.ejb.EJBLocalObject {

    public String getName();
    public void setName(String str);
    public int getDeckLevel();
    public void setDeckLevel(int level);
    public int getShipId();
    public void setShipId(int sp);
    public int getBedCount();
    public void setBedCount(int bc); 

}
