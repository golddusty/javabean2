package com.titan.reservation;

import com.titan.cruise.*;
import com.titan.customer.*;
import com.titan.cabin.*;

import java.rmi.RemoteException;
import javax.ejb.EntityContext;
import javax.ejb.CreateException;
import javax.ejb.FinderException;
import java.sql.Date;
import java.util.*;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.Context;
import javax.naming.NamingException;

public abstract class ReservationBean implements javax.ejb.EntityBean {
    
    public Object ejbCreate(CruiseLocal cruise, Collection customers)  throws CreateException
    {
		System.out.println("ReservationBean::ejbCreate");
         setId(getNextUniqueKey());
        return null;
    }

    public void ejbPostCreate(CruiseLocal cruise, Collection customers)   throws CreateException
	{
		System.out.println("ReservationBean::ejbPostCreate");
		setCruise(cruise);
 		Collection myCustomers = this.getCustomers();
        if ( ( myCustomers != null) && (customers != null ))
		{
            myCustomers.addAll(customers);
        }
        else if ( (myCustomers == null ) && ( customers != null ))
        {
            setCustomers((Set)customers);
        }
    }

    public Integer ejbCreate(CustomerRemote customer, 
                             CruiseLocal cruise,
                             CabinLocal cabin, double price, java.sql.Date dateBooked)
	{
		System.out.println("ReservationBean::ejbCreate");
        setAmountPaid(price);
		setDate(dateBooked);
		return null;
    }

    public void ejbPostCreate(CustomerRemote customer, 
                              CruiseLocal cruise,
                              CabinLocal cabin, double price, java.sql.Date dateBooked)
		throws javax.ejb.CreateException
	{
        
 		System.out.println("ReservationBean::ejbPostCreate");
        setCruise(cruise);
		// Our bean has many cabins, use the cmr set method here..
		Set cabins = new HashSet();
		cabins.add(cabin);
		this.setCabins(cabins);
        try {
            Integer primKey = (Integer)customer.getPrimaryKey();
            javax.naming.Context jndiContext = new InitialContext();
            CustomerHomeLocal home = (CustomerHomeLocal)
                jndiContext.lookup("java:comp/env/ejb/CustomerHomeLocal");  // get local interface
            CustomerLocal custL = home.findByPrimaryKey(primKey);
			// Our bean has many customers, use the cmr set method here..
			Set customers = new HashSet();
			customers.add(custL);
			this.setCustomers(customers);
        } catch (RemoteException re) {
            throw new CreateException("Invalid Customer - Bad Remote Reference");
        } catch (FinderException fe) {
            throw new CreateException("Invalid Customer - Unable to Find Local Reference");
        } catch (NamingException ne) {
            throw new CreateException("Invalid Customer - Unable to find CustomerHomeLocal Reference");
        }
    }

	// relationship fields

	public abstract CruiseLocal getCruise();
    public abstract void setCruise(CruiseLocal cruise);

	public abstract Set getCabins( );
	public abstract void setCabins(Set cabins);

	public abstract Set getCustomers( );
	public abstract void setCustomers(Set customers);

    // persistent fields

	public abstract Integer getId();
	public abstract void setId(Integer id);
    public abstract java.sql.Date getDate();
    public abstract void setDate(java.sql.Date date);
    public abstract double getAmountPaid();
    public abstract void setAmountPaid(double amount);

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
                String jdbcClass = "COM.cloudscape.core.RmiJdbcDriver";
                String jdbcURL	 = "jdbc:cloudscape:rmi:TitanDB";
                String user		 = "scott";
                String password	 = "tiger";
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
                    aString.append("\"").append("like").append("'Reservation'"); //.append(" for Update");
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
                    stmt2 = conn.createStatement();
                    StringBuffer aString2 = new StringBuffer("update \"SequenceTable\" set \"CurrentValue\"="+sequenceID+" where \"SequenceName\"='Reservation'");
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
                     catch( SQLException ex)
                    {
                     ex.printStackTrace();
                    }
                }
                return myId;
            }


}
