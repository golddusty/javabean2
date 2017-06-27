package com.titan.cabin;

import javax.ejb.EntityContext;
import javax.ejb.CreateException;
import java.sql.*;
import java.util.*;
import javax.naming.*;

public abstract class CabinBean 
implements javax.ejb.EntityBean {

	public Integer ejbCreate(Integer id) throws CreateException {
	     Connection conn = null;
	    Statement stmt = null;
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
		    javax.sql.DataSource aDatasource = (javax.sql.DataSource)aContext.lookup("jdbc/Titan");
		    conn = aDatasource.getConnection();
		    System.out.println("Obtained a database connection to Cloudscape");
    		
		    stmt = conn.createStatement();
		    StringBuffer aString = new StringBuffer();
		    aString.append("select ").append("\"").append("CurrentValue");
		    aString.append("\"").append(" from ").append("\"").append("SequenceTable");
		    aString.append("\"").append(" where").append("\"").append("SequenceName");
		    aString.append("\"").append("like").append("'Cabin'").append(" for Update");
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
		    StringBuffer aString2 = new StringBuffer("update \"SequenceTable\" set \"CurrentValue\"="+sequenceID+" where \"SequenceName\"='Cabin'");
		    System.out.println(aString2);
		    stmt.execute(aString2.toString());
		}
		catch( Exception ex)
		{
		    ex.printStackTrace();
		}
		this.setId(myId);
		return myId;
	}
	public void ejbPostCreate(Integer id) throws CreateException {
		
	}
	public abstract void setId(Integer id);
	public abstract Integer getId();
 
	public abstract void setShipId(int ship);
	public abstract int getShipId( );

	public abstract void setName(String name);
	public abstract String getName( );

	public abstract void setBedCount(int count);
	public abstract int getBedCount( );

	public abstract void setDeckLevel(int level);
	public abstract int getDeckLevel( );

    public void setEntityContext(EntityContext ctx) {
         // Not implemented.
    }
    public void unsetEntityContext() {
         // Not implemented.
    }
    public void ejbActivate() {
        // Not implemented.
    }
    public void ejbPassivate() {
        // Not implemented.
    }
    public void ejbLoad() {
        // Not implemented.
    }
    public void ejbStore() {
        // Not implemented.
    }
    public void ejbRemove() {
        // Not implemented.
    }
}
