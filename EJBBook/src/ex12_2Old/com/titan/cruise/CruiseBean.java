package com.titan.cruise;

import javax.ejb.EntityContext;
import javax.ejb.CreateException;
import javax.naming.InitialContext;

import com.titan.ship.*;
import java.util.Collection;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;

public abstract class CruiseBean implements javax.ejb.EntityBean {
    
	public Integer ejbCreate(String name, ShipLocal ship)throws CreateException {
		System.out.println("ejbCreate");
		setName(name);
        setId(getNextUniqueKey());
		return null;
	}
	
	public void ejbPostCreate(String name, ShipLocal ship) throws CreateException
    {
		setShip(ship);
	}

    // persistent fields

	public abstract void setId(Integer id);
	public abstract Integer getId();
	public abstract void setName(String name);
	public abstract String getName( );

	public abstract void setShip(ShipLocal ship);
	public abstract ShipLocal getShip( );

	// relationship fields

	public abstract void setReservations(Collection res);
	public abstract Collection getReservations( );

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
                    aString.append("\"").append("like").append("'Cruise'"); //.append(" for Update");
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
                    StringBuffer aString2 = new StringBuffer("update \"SequenceTable\" set \"CurrentValue\"="+sequenceID+" where \"SequenceName\"='Cruise'");
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
