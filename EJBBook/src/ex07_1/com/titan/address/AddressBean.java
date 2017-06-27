package com.titan.address;

import javax.ejb.EntityContext;
import javax.ejb.CreateException;
import javax.naming.InitialContext;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;

public abstract class AddressBean implements javax.ejb.EntityBean {
    
    public Integer ejbCreateAddress
                         (String street, String city,
                          String state,  String zip ) throws CreateException
    {
		setId(getNextUniqueKey());
        setStreet(street);
         setCity(city);
         setState(state);
         setZip(zip);
         return null;
    }

    public void ejbPostCreateAddress
                     (String street, String city,
                      String state,  String zip) throws CreateException{
    }

    // persistent fields
	public abstract Integer getId();
	public abstract void setId(Integer id);
    public abstract String getStreet();
    public abstract void setStreet(String street);
    public abstract String getCity();
    public abstract void setCity(String city);
    public abstract String getState();
    public abstract void setState(String state);
    public abstract String getZip();
    public abstract void setZip(String zip);

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
	    ResultSet rs = null;
        Statement stmt2 = null;
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
		    aString.append("\"").append("like").append("'Address'");//.append(" for Update");
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
            System.out.println("ID fetched =="+ myId.intValue());
		    sequenceID++;
            stmt2 = conn.createStatement();
		    StringBuffer aString2 = new StringBuffer("update \"SequenceTable\" set \"CurrentValue\"="+sequenceID+" where \"SequenceName\"='Address'");
		    System.out.println(aString2);
		    stmt2.execute(aString2.toString());
		}
		catch( Exception ex)
		{
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
             ex.printStackTrace();
            }
         }
		return myId;
	}
}
