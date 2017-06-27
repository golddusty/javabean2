package com.titan.clients;

import javax.jms.Message;
import javax.jms.MapMessage;
import javax.jms.Session;
import javax.jms.QueueConnectionFactory;
import javax.jms.QueueConnection;
import javax.jms.QueueSession;
import javax.jms.Queue;
import javax.jms.QueueSender;
import javax.jms.JMSException;
import javax.naming.Context;
import javax.naming.InitialContext;
import java.util.Properties;
import java.util.Date;

import com.titan.processpayment.*;


public class JmsClient_ReservationProducer {

    public static void main(String [] args) throws Exception {

        if (args.length != 2)
            throw new Exception("Usage: java JmsClient_ReservationProducer <CruiseID> <count>");

		Integer cruiseID = new Integer(args[0]);
		int count = new Integer(args[1]).intValue();

        Context jndiContext = getInitialContext();
        
        QueueConnectionFactory factory = (QueueConnectionFactory)jndiContext.lookup("titan-QueueFactory");
        
        Queue reservationQueue = (Queue)jndiContext.lookup("titan-ReservationQueue");
        Queue ticketQueue = (Queue)jndiContext.lookup("titan-TicketQueue");

        QueueConnection connect = factory.createQueueConnection();

        QueueSession session = connect.createQueueSession(false,Session.AUTO_ACKNOWLEDGE); 

        QueueSender sender = session.createSender(reservationQueue);
               
        for (int i = 0; i < count; i++) {

            MapMessage message = session.createMapMessage();
            
			message.setJMSReplyTo(ticketQueue);  // Used in ReservationProcessor to send Tickets back out

			message.setStringProperty("MessageFormat", "Version 3.4");

            message.setInt("CruiseID", cruiseID.intValue());
            message.setInt("CustomerID",i%2+1);  // either Customer 1 or 2, all we've got in database
            message.setInt("CabinID",i%10+100);  // cabins 100-109 only
            message.setDouble("Price", (double)1000+i);
            
            // the card expires in about 30 days
            Date expDate = new Date(System.currentTimeMillis()+43200000);
            
            message.setString("CreditCardNum", "923830283029");
            message.setLong("CreditCardExpDate", expDate.getTime());
            message.setString("CreditCardType", CreditCardDO.MASTER_CARD);
            
			System.out.println("Sending reservation message #"+i);
            sender.send(message);           
        }
        
        connect.close();
    }
    
    public static Context getInitialContext() 
                          throws javax.naming.NamingException {
		Properties p = new Properties();
		p.put(Context.INITIAL_CONTEXT_FACTORY, "weblogic.jndi.WLInitialContextFactory");  
		p.put(Context.PROVIDER_URL, "t3://localhost:7001");
		return new InitialContext(p);
    }
}
