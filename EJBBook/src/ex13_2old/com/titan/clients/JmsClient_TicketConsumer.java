package com.titan.clients;

import javax.jms.Message;
import javax.jms.ObjectMessage;
import javax.jms.QueueConnectionFactory;
import javax.jms.QueueConnection;
import javax.jms.Session;
import javax.jms.QueueSession;
import javax.jms.Queue;
import javax.jms.QueueReceiver;
import javax.jms.QueueSender;
import javax.jms.JMSException;
import javax.naming.Context;
import javax.naming.InitialContext;
import java.util.Properties;

import com.titan.travelagent.TicketDO;

public class JmsClient_TicketConsumer implements javax.jms.MessageListener{

    public static void main(String [] args) throws Exception {
        
        new JmsClient_TicketConsumer();
        
        while(true) { Thread.sleep(10000); }
        
    }
        
    public JmsClient_TicketConsumer() throws Exception {
            
        Context jndiContext = getInitialContext();
        
        QueueConnectionFactory factory = (QueueConnectionFactory)
			jndiContext.lookup("titan-QueueFactory");
        
        Queue ticketQueue = (Queue)
			jndiContext.lookup("titan-TicketQueue");

        QueueConnection connect = factory.createQueueConnection();

        QueueSession session = 
			connect.createQueueSession(false,Session.AUTO_ACKNOWLEDGE); 
        
        QueueReceiver receiver = session.createReceiver(ticketQueue);

        receiver.setMessageListener(this);
        
		System.out.println("Listening for messages on titan-TicketQueue...");
        connect.start();
    }
    
    public void onMessage(Message message) {

        try {
        
			ObjectMessage objMsg = (ObjectMessage)message;
			TicketDO ticket = (TicketDO)objMsg.getObject();
			System.out.println("********************************");
			System.out.println(ticket);
			System.out.println("********************************");
        
        } catch (JMSException jmsE) {
            jmsE.printStackTrace();
        }
    }

    public static Context getInitialContext() 
                          throws javax.naming.NamingException {
		Properties p = new Properties();
		p.put(Context.INITIAL_CONTEXT_FACTORY, "weblogic.jndi.WLInitialContextFactory");  
		p.put(Context.PROVIDER_URL, "t3://localhost:7001");
		return new InitialContext(p);
    }
}
