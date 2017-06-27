package com.titan.customer;

import java.sql.Date;

// Credit Card EJB's local interface
public interface CreditCardLocal extends javax.ejb.EJBLocalObject {

    public java.sql.Date getExpirationDate();
    public void setExpirationDate(java.sql.Date date);
    public String getNumber();
    public void setNumber(String number);
    public String getNameOnCard();
    public void setNameOnCard(String name);
    public String getCreditOrganization();
    public void setCreditOrganization(String org);

    public CustomerLocal getCustomer();
    public void setCustomer(CustomerLocal cust);

}

