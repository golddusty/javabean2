package com.titan.customer;

import javax.ejb.EntityContext;
import javax.ejb.CreateException;
import javax.naming.InitialContext;
import java.sql.Date;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;

public abstract class CreditCardBean implements javax.ejb.EntityBean {
    
    public Object ejbCreate
                         (java.sql.Date exp, String numb, String name, String org) throws CreateException
    {
		System.out.println("ejbCreate");
		setId( getNextUniqueKey() );
        setExpirationDate(exp);
        setNumber(numb);
        setNameOnCard(name);
        setCreditOrganization(org);

         return null;
    }

    public void ejbPostCreate
                     (java.sql.Date exp, String numb, String name, String org) throws CreateException
    {
		System.out.println("ejbPostCreate");
    }

	// relationship fields

    public abstract CustomerLocal getCustomer( );	
    public abstract void setCustomer(CustomerLocal cust);	

    // persistent fields


	public abstract Integer getId();
	public abstract void setId(Integer id);
    public abstract java.sql.Date getExpirationDate();
    public abstract void setExpirationDate(java.sql.Date date);
    public abstract String getNumber();
    public abstract void setNumber(String number);
    public abstract String getNameOnCard();
    public abstract void setNameOnCard(String name);
    public abstract String getCreditOrganization();
    public abstract void setCreditOrganization(String org);

    // standard call back methods
    
    public void setEntityContext(EntityContext ec){}
    public void unsetEntityContext(){}
    public void ejbLoad(){}
    public void ejbStore(){}
    public void ejbActivate(){}
    public void ejbPassivate(){}
    public void ejbRemove(){}

    private Integer getNextUniqueKey()
    {

         Connection conn = null;
         Statement stmt = null;
         Statement stmt2 = null;
         ResultSet rs = null;
         boolean rowspresent = false;
         int sequenceID = 0;
         Integer myId = null;

         try
         {
             InitialContext aContext = new InitialContext();
             javax.sql.DataSource aDatasource = (javax.sql.DataSource)aContext.lookup("jdbc/TitanUID");
             conn = aDatasource.getConnection();
             System.out.println("Obtained a database connection to Cloudscape");

             stmt = conn.createStatement();
             StringBuffer aString = new StringBuffer();
             aString.append("select ").append("\"").append("CurrentValue");
             aString.append("\"").append(" from ").append("\"").append("SequenceTable");
             aString.append("\"").append(" where").append("\"").append("SequenceName");
             aString.append("\"").append("like").append("'CreditCard'"); //.append(" for Update");
             System.out.println(aString);
             rs = stmt.executeQuery(aString.toString());
             if (rs != null)
             {
                 while (rs.next())
                 {
                     sequenceID =rs.getInt(1);
                 }
             }

             myId = new Integer(sequenceID);
             sequenceID++;
             StringBuffer aString2 = new StringBuffer("update \"SequenceTable\" set \"CurrentValue\"="+sequenceID+" where \"SequenceName\"='CreditCard'");
             stmt2 = conn.createStatement();
             System.out.println(aString2);
             stmt2.execute(aString2.toString());
         }
         catch( Exception ex)
         {
             System.out.println("In the catch clause of CreditCardBean");
             ex.printStackTrace();
         }
        finally
        {
             try
             {
                 stmt.close();
                 stmt2.close();
                 conn.close();
             }
             catch( Exception ex)
             {
                 System.out.println("In the catch clause of finally section of CreditCardBean");
                 ex.printStackTrace();
             }
        }


            return myId;
        }

}
