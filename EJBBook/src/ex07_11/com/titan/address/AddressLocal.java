package com.titan.address;

// Address EJB's local interface
public interface AddressLocal extends javax.ejb.EJBLocalObject {
  public String getStreet();
  public void setStreet(String street);
  public String getCity();
  public void setCity(String city);
  public String getState();
  public void setState(String state);
  public String getZip();
  public void setZip(String zip);
}
