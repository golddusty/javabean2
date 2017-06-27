package com.titan.reservation;

import com.titan.cruise.*;

import javax.ejb.EntityContext;
import javax.ejb.CreateException;
import javax.naming.InitialContext;
import java.sql.Date;
import java.util.Set;
import java.util.Collection;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;

public abstract class ReservationBean implements javax.ejb.EntityBean {
    
    public Object ejbCreate(CruiseLocal cruise, Collection customers)throws CreateException
    {
		System.out.println("ejbCreate");
        setId(getNextUniqueKey());
        return null;
    }

    public void ejbPostCreate(CruiseLocal cruise, Collection customers)throws CreateException {
		System.out.println("ejbPostCreate");
		setCruise(cruise);
        Collection myCustomers = this.getCustomers();
        if ( ( myCustomers != null) && (customers != null ))
		{
            myCustomers.addAll(customers);
        }
   }

	// relationship fields

	public abstract CruiseLocal getCruise();
    public abstract void setCruise(CruiseLocal cruise);

	public abstract Set getCabins();
	public abstract void setCabins(Set cabins);

	public abstract Set getCustomers();
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
