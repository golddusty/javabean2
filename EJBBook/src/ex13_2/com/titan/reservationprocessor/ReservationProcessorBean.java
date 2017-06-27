package com.titan.reservationprocessor;

import com.titan.customer.*;
import com.titan.cruise.*;
import com.titan.cabin.*;
import com.titan.reservation.*;
import com.titan.processpayment.*;

import com.titan.travelagent.*;
import java.util.Date;
import java.rmi.RemoteException;
import javax.jms.*;
import javax.naming.InitialContext;
import javax.naming.Context;
import javax.naming.NamingException;
import javax.ejb.EJBException;
import javax.ejb.FinderException;
import javax.ejb.ObjectNotFoundException;
import javax.ejb.MessageDrivenContext;
import javax.ejb.MessageDrivenBean;
import javax.rmi.PortableRemoteObject;

public class ReservationProcessorBean 
implements javax.ejb.MessageDrivenBean, javax.jms.MessageListener {

    MessageDrivenContext ejbContext;
    Context jndiContext;

    public void setMessageDrivenContext(MessageDrivenContext mdc){
        ejbContext = mdc;
        try {
           jndiContext = new InitialContext();
        } catch(NamingException ne) {
           throw new EJBException(ne);
        }
    }

    public void ejbCreate(){}

    public void onMessage(Message message) {
        try {

			System.out.println("ReservationProcessor::onMessage() called..");
            MapMessage reservationMsg = (MapMessage)message;
                
            Integer customerPk = (Integer)
                    reservationMsg.getObject("CustomerID");
            Integer cruisePk =   (Integer)
                    reservationMsg.getObject("CruiseID");
            Integer cabinPk =    (Integer)
                    reservationMsg.getObject("CabinID");

            double price = reservationMsg.getDouble("Price");

			String creditCardNum = reservationMsg.getString("CreditCardNum");
			Date creditCardExpDate = new Date( reservationMsg.getLong("CreditCardExpDate") );
			String creditCardType = reservationMsg.getString("CreditCardType");

            CreditCardDO card = new CreditCardDO(creditCardNum,creditCardExpDate,creditCardType);
                
            System.out.println("Customer ID = "+customerPk+", Cruise ID = "+cruisePk+", Cabin ID = "+cabinPk+", Price = "+price);
			
            CustomerRemote customer = getCustomer(customerPk);
            CruiseLocal cruise = getCruise(cruisePk);
            CabinLocal cabin = getCabin(cabinPk);

            ReservationHomeLocal resHome = (ReservationHomeLocal)
                jndiContext.lookup("java:comp/env/ejb/ReservationHomeLocal");
                
            ReservationLocal reservation =
                resHome.create(customer, cruise, cabin, price, new java.sql.Date(System.currentTimeMillis()));
                    
            Object ref = jndiContext.lookup("java:comp/env/ejb/ProcessPaymentHomeRemote");

            ProcessPaymentHomeRemote ppHome = (ProcessPaymentHomeRemote)
				PortableRemoteObject.narrow(ref, ProcessPaymentHomeRemote.class);
                
            ProcessPaymentRemote process = ppHome.create();
            process.byCredit(customer, card, price);

            TicketDO ticket = new TicketDO(customer,cruise,cabin,price);
            System.out.println("Created Ticket and Delivering ticket");
            deliverTicket(reservationMsg, ticket);

        } catch(Exception e) {
            e.printStackTrace();
            throw new EJBException(e);
        }
    }
    
	public void deliverTicket(MapMessage reservationMsg, TicketDO ticket)
	throws NamingException, JMSException {

        // create a ticket and send it to the proper destination
		System.out.println("ReservationProcessor::deliverTicket()..");

		Queue queue = (Queue)reservationMsg.getJMSReplyTo();
        System.out.println(queue.getQueueName());
		QueueConnectionFactory factory = (QueueConnectionFactory)
			jndiContext.lookup("java:comp/env/jms/QueueFactory");
		QueueConnection connect = factory.createQueueConnection();
		QueueSession session = connect.createQueueSession(false,0);
		QueueSender sender = session.createSender(queue);
		ObjectMessage message = session.createObjectMessage();
		message.setObject(ticket);
		
		System.out.println("Sending message back to sender..");
		sender.send(message);
			
		connect.close();
	}
        
    public CustomerRemote getCustomer(Integer key)
    throws NamingException, ObjectNotFoundException, FinderException, RemoteException {
        // get a remote reference to the Customer EJB
        Object ref = jndiContext.lookup("java:comp/env/ejb/CustomerHomeRemote");
        CustomerHomeRemote home = (CustomerHomeRemote)
            PortableRemoteObject.narrow(ref, CustomerHomeRemote.class);
        CustomerRemote customer = (CustomerRemote)home.findByPrimaryKey(key);
		return customer;
    }

    public CruiseLocal getCruise(Integer key)
    throws NamingException, ObjectNotFoundException, FinderException {
        // get a local reference to the Cruise EJB
		CruiseHomeLocal home = (CruiseHomeLocal)
			jndiContext.lookup("java:comp/env/ejb/CruiseHomeLocal");
		CruiseLocal cruise = home.findByPrimaryKey(key);
		return cruise;
    }

    public CabinLocal getCabin(Integer key)
    throws NamingException, ObjectNotFoundException, FinderException {
        // get a local reference to the Cabin EJB
		CabinHomeLocal home = (CabinHomeLocal)
			jndiContext.lookup("java:comp/env/ejb/CabinHomeLocal");
		CabinLocal cruise = home.findByPrimaryKey(key);
		return cruise;
    }

    public void ejbRemove(){
        try {
           jndiContext.close();
           ejbContext = null;
        } catch(NamingException ne) { /* do nothing */ }
    }
}
