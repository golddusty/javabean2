package com.titan.clients;

import javax.jms.Message;
import javax.jms.TextMessage;
import javax.jms.TopicConnectionFactory;
import javax.jms.TopicConnection;
import javax.jms.TopicSession;
import javax.jms.Topic;
import javax.jms.TopicSubscriber;
import javax.jms.JMSException;
import javax.naming.Context;
import javax.naming.InitialContext;
import java.util.Properties;
import javax.jms.Session;

public class JmsClient_1 implements javax.jms.MessageListener {

    public static void main(String [] args) throws Exception {
        
        new JmsClient_1();
        
        while(true) { Thread.sleep(1000); }
        
    }
        
public JmsClient_1() throws Exception {
        
    Context jndiContext = getInitialContext();
    
    TopicConnectionFactory factory = (TopicConnectionFactory)
     //   jndiContext.lookup("java:comp/env/jms/TopicFactory");
    jndiContext.lookup("titan-TopicFactory");

   // Topic topic = (Topic) jndiContext.lookup("java:comp/env/jms/TicketTopic");
     Topic topic = (Topic) jndiContext.lookup("titan-TicketTopic");
    TopicConnection connect = factory.createTopicConnection();

    TopicSession session = 
        connect.createTopicSession(false, Session.AUTO_ACKNOWLEDGE); 

    TopicSubscriber subscriber = session.createSubscriber(topic);

    subscriber.setMessageListener(this);
    
    System.out.println("Listening for messages on titan-TicketTopic...");
    connect.start();
}
    
public void onMessage(Message message) {
    try {
        TextMessage textMsg = (TextMessage)message;
        String text = textMsg.getText();
        System.out.println("\n RESERVATION RECEIVED:\n"+text);
    } catch(JMSException jmsE) {
        jmsE.printStackTrace();
    }
}
    
    public static Context getInitialContext() 
                          throws javax.naming.NamingException {
		return new InitialContext();
    }
}
