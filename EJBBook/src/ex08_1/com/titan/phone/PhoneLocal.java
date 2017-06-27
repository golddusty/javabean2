package com.titan.phone;

// Phone EJB's local interface
public interface PhoneLocal extends javax.ejb.EJBLocalObject {

    public String getNumber();
    public void setNumber(String number);
    public byte getType();
    public void setType(byte type);

}
