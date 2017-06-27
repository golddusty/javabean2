package com.titan.clients;	

import com.titan.cabin.CabinHomeRemote;
import com.titan.cabin.CabinRemote;
import com.titan.travelagent.TravelAgentHomeRemote;
import com.titan.travelagent.TravelAgentRemote;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.naming.NamingException;
import javax.ejb.CreateException;

import javax.rmi.PortableRemoteObject;
import java.rmi.RemoteException;
import java.util.Properties;

/**

 * Utility client class to undo the effects of Client_51 example by adding back cabin #30.
 * 
 */
public class Client_51_undo {

    public static void main(String [] args) {
        try {
           Context jndiContext = getInitialContext();

		   // Obtain a list of all the cabins for ship 1 with bed count of 3.

			Object ref = jndiContext.lookup("java:comp/env/ejb/TravelAgentHome");
			TravelAgentHomeRemote agentHome = (TravelAgentHomeRemote)
				PortableRemoteObject.narrow(ref,TravelAgentHomeRemote.class);

			TravelAgentRemote agent = agentHome.create();
			String list [] = agent.listCabins(1,3);  
			System.out.println("1st List: Before re-creating cabin number 30");
			for(int i = 0; i < list.length; i++){
				System.out.println(list[i]);
			}

			// Obtain the home and re-create cabin 30. Rerun the same cabin list.

			ref = jndiContext.lookup("java:comp/env/ejb/CabinHome");
			CabinHomeRemote c_home = (CabinHomeRemote)
				PortableRemoteObject.narrow(ref, CabinHomeRemote.class);

			// re-create the single cabin (#30) we deleted with Client_4 example
            makeCabin(c_home, 30, 3, 1, 3, 309);

			list = agent.listCabins(1,3);  
			System.out.println("2nd List: After re-creating cabin number 30");
			for (int i = 0; i < list.length; i++) {
				System.out.println(list[i]);
			}
        
        } catch(java.rmi.RemoteException re){re.printStackTrace();}
          catch(Throwable t){t.printStackTrace();}
          System.exit(0);
  }

/**
 * Version of makeCabin taking a single set of values for Id, deck level, ship id, bed count, and suite number
 * 
 */
  public static void makeCabin(CabinHomeRemote home, 
                                int Id, int deckLevel, int shipNumber, int bc, int suiteNumber)
    throws RemoteException, CreateException {

        CabinRemote cabin = home.create(new Integer(Id));
        cabin.setName("Suite "+suiteNumber);
        cabin.setDeckLevel(deckLevel);
        cabin.setBedCount(bc);
        cabin.setShipId(shipNumber);
  }


  static public Context getInitialContext() throws Exception {
    Properties p = new Properties();
    return new InitialContext();
  }

}

