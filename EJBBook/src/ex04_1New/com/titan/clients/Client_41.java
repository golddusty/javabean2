package com.titan.clients;

import com.titan.cabin.CabinHomeRemote;	
import com.titan.cabin.CabinRemote;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.naming.NamingException;
import javax.rmi.PortableRemoteObject;
import java.rmi.RemoteException;
import java.util.Properties;


public class Client_41 {
    public static void main(String [] args) {
        try {
            Context jndiContext = getInitialContext();
            Object ref = jndiContext.lookup("CabinHomeRemote");
            CabinHomeRemote home = (CabinHomeRemote)
				PortableRemoteObject.narrow(ref,CabinHomeRemote.class);   
           
            if ( ref != null )
            {
                System.out.println(" Found Cabin Home");
            }
            CabinRemote cabin_1 = home.create(new Integer(1));
            cabin_1.setName("Master Suite");
            cabin_1.setDeckLevel(1);
            cabin_1.setShipId(1);
            cabin_1.setBedCount(3);

                
            Integer pk = new Integer(1);
            
            CabinRemote cabin_2 = home.findByPrimaryKey(pk);
            System.out.println(cabin_2.getName());
            System.out.println(cabin_2.getDeckLevel());
            System.out.println(cabin_2.getShipId());
            System.out.println(cabin_2.getBedCount());

        } catch (java.rmi.RemoteException re){re.printStackTrace();}
          catch (javax.naming.NamingException ne){ne.printStackTrace();}
          catch (javax.ejb.CreateException ce){ce.printStackTrace();}
          catch (javax.ejb.FinderException fe){fe.printStackTrace();}
          
          System.exit(0);
    }

    public static Context getInitialContext() 
        throws javax.naming.NamingException {

       // Properties p = new Properties();
	//	p.put(Context.INITIAL_CONTEXT_FACTORY, "weblogic.jndi.WLInitialContextFactory");  
	//	p.put(Context.PROVIDER_URL, "t3://localhost:7001");
       // return new javax.naming.InitialContext(p);
            return new InitialContext();
    }
}

