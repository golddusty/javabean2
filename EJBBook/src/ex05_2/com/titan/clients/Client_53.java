package com.titan.clients;					

import com.titan.travelagent.TravelAgentHomeRemote;		
import com.titan.travelagent.TravelAgentRemote;			

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.naming.NamingException;
import javax.ejb.EJBMetaData;
import javax.rmi.PortableRemoteObject;		
import java.rmi.RemoteException;
import java.util.Properties;

/**
 * Example of using EJBObject to retrieve home interface.
 * 
 */
public class Client_53 {

    public static void main(String [] args) {
		try {
			Context jndiContext = getInitialContext();  
			Object ref = jndiContext.lookup("TravelAgentHome");
			TravelAgentHomeRemote home = (TravelAgentHomeRemote)
				PortableRemoteObject.narrow(ref,TravelAgentHomeRemote.class);

			// Get a remote reference to the bean (EJB object).
			TravelAgentRemote agent = home.create();
			// Pass the remote reference to some method.
			getTheEJBHome(agent);

        } catch (java.rmi.RemoteException re){re.printStackTrace();}
          catch (Throwable t){t.printStackTrace();}
	}

	public static void getTheEJBHome(TravelAgentRemote agent)
		throws RemoteException {

		// The home interface is out of scope in this method,
		// so it must be obtained from the EJB object.
		Object ref = agent.getEJBHome();
		TravelAgentHomeRemote home = (TravelAgentHomeRemote)
			PortableRemoteObject.narrow(ref,TravelAgentHomeRemote.class);

		// Do something useful with the home interface
		EJBMetaData meta = home.getEJBMetaData();
		System.out.println(meta.getHomeInterfaceClass().getName());
		System.out.println(meta.getRemoteInterfaceClass().getName());
		System.out.println(meta.isSession());
        //System.exit(0);

	}

	static public Context getInitialContext() throws Exception {
		return new InitialContext();
	}
}

