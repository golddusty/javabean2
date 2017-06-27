package com.titan.travelagent;

import com.titan.cabin.CabinRemote;
import com.titan.cabin.CabinHomeRemote;
import java.rmi.RemoteException;
import javax.naming.InitialContext;
import javax.naming.Context;
import javax.ejb.EJBException;
import java.util.Properties;
import java.util.Vector;
import javax.ejb.CreateException;

public class TravelAgentBean implements javax.ejb.SessionBean {

   public void ejbCreate()throws CreateException {
   // Do nothing.
   }
   public String [] listCabins(int shipID, int bedCount) {

        try {
            Properties p = new Properties();
           // p.put(Context.INITIAL_CONTEXT_FACTORY, "weblogic.jndi.WLInitialContextFactory"); 
          //  p.put(Context.PROVIDER_URL, "t3://localhost:7001");
           javax.naming.Context jndiContext = new InitialContext();
            Object obj = 
                   jndiContext.lookup("java:comp/env/ejb/CabinHome");


            CabinHomeRemote home = (CabinHomeRemote)
            javax.rmi.PortableRemoteObject.narrow(obj,CabinHomeRemote.class);
    
            Vector vect = new Vector();
            for (int i = 1; ; i++) {
              Integer pk = new Integer(i);
              CabinRemote cabin = null;
              try {
                  cabin = home.findByPrimaryKey(pk);
                } catch(javax.ejb.FinderException fe) {
                    System.out.println("Caught exception: "+fe.getMessage()+" for pk="+i); 

                    break;
                }
                // Check to see if the bed count and ship ID match.
                if (cabin != null &&
                    cabin.getShipId() == shipID && 
                    cabin.getBedCount() == bedCount) {
                  String details = 

                    i+","+cabin.getName()+","+cabin.getDeckLevel();
                  vect.addElement(details);
                }
            }
        
            String [] list = new String[vect.size()];
            vect.copyInto(list);
            return list;
       
       } catch(Exception e) {throw new EJBException(e);}    
   }

   private javax.naming.Context getInitialContext() 
   throws javax.naming.NamingException {
      //Properties p = new Properties();
      // ... Specify the JNDI properties specific to the vendor.
      return new javax.naming.InitialContext();
   }

   public void ejbRemove(){}
   public void ejbActivate(){}
   public void ejbPassivate(){}
   public void setSessionContext(javax.ejb.SessionContext cntx){}
}
