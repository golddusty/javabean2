package com.titan.cabin;

import com.titan.ship.*;

public interface CabinLocal extends javax.ejb.EJBLocalObject {

    public String getName();
    public void setName(String name);
    public int getDeckLevel();
    public void setDeckLevel(int level);
  //  public ShipLocal getShip();
  //  public void setShip(ShipLocal ship);
    public int getBedCount();
    public void setBedCount(int count); 

}
