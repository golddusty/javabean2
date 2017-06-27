package com.titan.travelagent;

import com.titan.reservation.*;
import com.titan.processpayment.*;
import com.titan.customer.*;
import com.titan.cruise.*;
import com.titan.cabin.*;
import com.titan.ship.*;

import java.util.Date;
import java.sql.*;
import java.sql.Connection;
import java.util.*;
import javax.sql.DataSource;
import java.rmi.RemoteException;
import javax.naming.NamingException;
import javax.ejb.EJBException;
import javax.rmi.PortableRemoteObject;
import javax.ejb.CreateException;
import javax.jms.*;

public class TravelAgentBean implements javax.ejb.SessionBean {

    public CustomerRemote customer;
	public CruiseLocal cruise;
	public CabinLocal cabin;

	public javax.ejb.SessionContext ejbContext;

	public javax.naming.Context jndiContext;

	public void ejbCreate(CustomerRemote cust) {
		System.out.println("TravelAgentBean::ejbCreate");
		customer = cust;
	}

	public void setCabinID(Integer cabinID)
		throws javax.ejb.FinderException {

		try {
			CabinHomeLocal home = (CabinHomeLocal)
				jndiContext.lookup("java:comp/env/ejb/CabinHomeLocal");
			cabin = home.findByPrimaryKey(cabinID);
		} catch (NamingException ne) {
			throw new EJBException(ne);
		}
	}

	public void setCruiseID(Integer cruiseID)
		throws javax.ejb.FinderException {

		try {
			CruiseHomeLocal home = (CruiseHomeLocal)
			jndiContext.lookup("java:comp/env/ejb/CruiseHomeLocal");
			cruise = home.findByPrimaryKey(cruiseID);
		} catch (NamingException ne) {
			throw new EJBException(ne);
		}

	}
    /*
	public TicketDO bookPassage(CreditCardDO card, double price)
		throws IncompleteConversationalState {

		if (customer == null || cruise == null || cabin == null)
		{
			throw new IncompleteConversationalState();
		}
		try {
			ReservationHomeLocal reshome =
				(ReservationHomeLocal)jndiContext.lookup("java:comp/env/ejb/ReservationHomeLocal");

			ReservationLocal reservation =
				reshome.create(customer, cruise, cabin, price, new java.sql.Date(System.currentTimeMillis()));

			Object ref = jndiContext.lookup("ejb/ProcessPaymentHomeRemote");

			ProcessPaymentHomeRemote ppHome = (ProcessPaymentHomeRemote)
				PortableRemoteObject.narrow(ref, ProcessPaymentHomeRemote.class);

			ProcessPaymentRemote process = ppHome.create();
			process.byCredit(customer, card, price);
			process.remove();

			TicketDO ticket = new TicketDO(customer,cruise,cabin,price);
			return ticket;
		} catch (Exception e) {
			throw new EJBException(e);
		}
	} */
    public TicketDO bookPassage(CreditCardDO card, double price)
		throws IncompleteConversationalState {

		TopicConnection connect = null;
        if (customer == null || cruise == null || cabin == null)
		{
			throw new IncompleteConversationalState();
		}
		try {
            System.out.println("Obtaining reference to Reservation EJB");
			ReservationHomeLocal reshome =
				(ReservationHomeLocal)jndiContext.lookup("java:comp/env/ejb/ReservationHomeLocal");

			ReservationLocal reservation =
				reshome.create(customer, cruise, cabin, price,new java.sql.Date(System.currentTimeMillis()));
            System.out.println("Obtaining reference to ProcessPayment EJB");
			Object ref = jndiContext.lookup("ProcessPaymentHomeRemote");

			ProcessPaymentHomeRemote ppHome = (ProcessPaymentHomeRemote)
				PortableRemoteObject.narrow(ref, ProcessPaymentHomeRemote.class);

			ProcessPaymentRemote process = ppHome.create();
			process.byCredit(customer, card, price);
             System.out.println("Successfully processed the byCredit method.");
			process.remove();
            System.out.println("Successfully removed the Process EJB");
			TicketDO ticket = new TicketDO(customer,cruise,cabin,price);

			String ticketDescription = ticket.toString();
            System.out.println("Obtaining reference to jms topic factory EJB");
			TopicConnectionFactory factory = (TopicConnectionFactory)
				jndiContext.lookup("java:comp/env/jms/TopicFactory");
             System.out.println("Obtaining reference to jms TicketTopic ");
			Topic topic = (Topic)
				jndiContext.lookup("java:comp/env/jms/TicketTopic");

			connect = factory.createTopicConnection();
			TopicSession session = connect.createTopicSession(false,Session.AUTO_ACKNOWLEDGE);
			TopicPublisher publisher = session.createPublisher(topic);

			TextMessage textMsg = session.createTextMessage();
			textMsg.setText(ticketDescription);

			System.out.println("Sending text message to jms/TicketTopic..");
			publisher.publish(textMsg);

			return ticket;
		} catch (Exception e) {
			throw new EJBException(e);
		}
        finally {
            if (connect != null) {
                try {
                    connect.close();
                } catch (JMSException e) {}
            }
        }
	}

	public String [] listAvailableCabins(int bedCount)
		throws IncompleteConversationalState {

		if (cruise == null)
			throw new IncompleteConversationalState();

		Connection con = null;
		PreparedStatement ps = null;;
		ResultSet result = null;
		try {
			Integer cruiseID = (Integer)cruise.getPrimaryKey();
			Integer shipID = (Integer)cruise.getShip().getPrimaryKey();
			con = getConnection();
			ps = con.prepareStatement(
                "select \"cabin\".\"id\", \"cabin\".\"name\", \"cabin\".\"deckLevel\" from \"CabinBeanTable\" \"cabin\" , \"ShipBean_cabins_CabinBean_shipTable\" \"ship_cabin\" "+
				"where \"ship_cabin\".\"_ShipBean_id\" = ? and \"cabin\".\"bedCount\" = ?  and \"ship_cabin\".\"_CabinBean_id\" = \"cabin\".\"id\" and \"cabin\".\"id\"  NOT IN " +
				"(SELECT \"RCL\".\"_CabinBean_id\"  FROM  \"ReservationBean_cabins_CabinBean_Table\" AS \"RCL\" , \"ReservationBeanTable\"  AS \"R\", \"CruiseBean_reservations_ReservationBean_cruiseTable\" AS \"CR\" " +
				" WHERE \"RCL\".\"_ReservationBean_id\"  = \"R\".\"id\" AND \"R\".\"id\" = \"CR\".\"_ReservationBean_id\"  AND \"CR\".\"_CruiseBean_id\" = ?)");

			ps.setInt(1,shipID.intValue());
			ps.setInt(2,bedCount);
			ps.setInt(3,cruiseID.intValue());
			result = ps.executeQuery();
			Vector vect = new Vector();
			while(result.next()) {
				StringBuffer buf = new StringBuffer();
				buf.append(result.getString(1));
				buf.append(',');
				buf.append(result.getString(2));
				buf.append(',');
				buf.append(result.getString(3));
				vect.addElement(buf.toString());
			}
			String [] returnArray = new String[vect.size()];
			vect.copyInto(returnArray);
			return returnArray;
		}
		catch (Exception e) {
			throw new EJBException(e);
		}
		finally {
			try {
			if (result != null) result.close();
			if (ps != null) ps.close();
			if (con!= null) con.close();
			} catch(SQLException se) {
				se.printStackTrace();
			}
		}
	}

	private Connection getConnection() throws SQLException {
		try {
		   DataSource ds =
			   (DataSource)jndiContext.lookup("java:comp/env/jdbc/Titan");
		   return ds.getConnection();
		} catch(NamingException ne) { throw new EJBException(ne); }
	}


	// mechanism for building local beans for workbook example programs

	public Collection buildSampleData() {

		Collection results = new ArrayList();

		try {
			System.out.println("TravelAgentBean::buildSampleData()");

			Object obj = jndiContext.lookup("java:comp/env/ejb/CustomerHomeRemote");
			CustomerHomeRemote custhome = (CustomerHomeRemote)
				javax.rmi.PortableRemoteObject.narrow(obj, CustomerHomeRemote.class);

			CabinHomeLocal cabinhome =
					(CabinHomeLocal)jndiContext.lookup("java:comp/env/ejb/CabinHomeLocal");
			ShipHomeLocal shiphome =
					(ShipHomeLocal)jndiContext.lookup("java:comp/env/ejb/ShipHomeLocal");
			CruiseHomeLocal cruisehome =
					(CruiseHomeLocal)jndiContext.lookup("java:comp/env/ejb/CruiseHomeLocal");
			ReservationHomeLocal reshome =
					(ReservationHomeLocal)jndiContext.lookup("java:comp/env/ejb/ReservationHomeLocal");

			System.out.println("Creating Customers 1 and 2..");

			CustomerRemote customer1 = custhome.create(new Integer(1));
			customer1.setName( new Name("Smith","Bob") );
			CustomerRemote customer2 = custhome.create(new Integer(2));
			customer2.setName( new Name("Stalin","Joseph") );
			results.add("Created customers with IDs 1 and 2..");

			System.out.println("Creating Ships A and B..");

			ShipLocal shipA = shiphome.create(new Integer(101), "Nordic Prince", 50000.0);
			ShipLocal shipB = shiphome.create(new Integer(102), "Bohemian Rhapsody", 70000.0);
			results.add("Created ships with IDs 101 and 102..");

			System.out.println("Creating Cabins on the Ships");

			ArrayList cabinsA = new ArrayList();
			ArrayList cabinsB = new ArrayList();
			for (int jj=0; jj<10; jj++) {
				CabinLocal cabinA = cabinhome.create(new Integer(100+jj),shipA,"Suite 10"+jj,1,1);
				cabinsA.add(cabinA);
				CabinLocal cabinB = cabinhome.create(new Integer(200+jj),shipB,"Suite 20"+jj,2,1);
				cabinsB.add(cabinB);
			}
			results.add("Created cabins on Ship A with IDs 100-109");
			results.add("Created cabins on Ship B with IDs 200-209");

			System.out.println("Creating three cruises for each ship");

			CruiseLocal cruiseA1 = cruisehome.create("Alaska Cruise", shipA);
			CruiseLocal cruiseA2 = cruisehome.create("Norwegian Fjords", shipA);
			CruiseLocal cruiseA3 = cruisehome.create("Bermuda or Bust", shipA);
			results.add("Created cruises on ShipA with IDs "+cruiseA1.getId()+", "+cruiseA2.getId()+", "+cruiseA3.getId());

			CruiseLocal cruiseB1 = cruisehome.create("Indian Sea Cruise", shipB);
			CruiseLocal cruiseB2 = cruisehome.create("Australian Highlights", shipB);
			CruiseLocal cruiseB3 = cruisehome.create("Three-Hour Cruise", shipB);
			results.add("Created cruises on ShipB with IDs "+cruiseB1.getId()+", "+cruiseB2.getId()+", "+cruiseB3.getId());

			System.out.println("Making a few reservations...");

			ReservationLocal res =
				  reshome.create(customer1, cruiseA1, (CabinLocal)(cabinsA.get(3)), 1000.0, new java.sql.Date(System.currentTimeMillis()));
			res = reshome.create(customer1, cruiseB3, (CabinLocal)(cabinsB.get(8)), 2000.0, new java.sql.Date(System.currentTimeMillis()));
			res = reshome.create(customer2, cruiseA2, (CabinLocal)(cabinsA.get(5)), 2000.0, new java.sql.Date(System.currentTimeMillis()));
			res = reshome.create(customer2, cruiseB3, (CabinLocal)(cabinsB.get(2)), 2000.0, new java.sql.Date(System.currentTimeMillis()));

			results.add("Made reservation for Customer 1 on Cruise "+cruiseA1.getId()+" for Cabin 103");
			results.add("Made reservation for Customer 1 on Cruise "+cruiseB3.getId()+" for Cabin 208");
			results.add("Made reservation for Customer 2 on Cruise "+cruiseA2.getId()+" for Cabin 105");
			results.add("Made reservation for Customer 2 on Cruise "+cruiseB3.getId()+" for Cabin 202");
            System.out.println("Created Reservations");


		} catch (Exception e) {
			e.printStackTrace();
			throw new EJBException(e);
		}

		return results;
	}

	public void ejbRemove() {}
	public void ejbActivate() {}
	public void ejbPassivate() {}

	public void setSessionContext(javax.ejb.SessionContext cntx)
	{
		ejbContext = cntx;
		try {
			jndiContext = new javax.naming.InitialContext();
		} catch(NamingException ne) {
			throw new EJBException(ne);
		}
	}
}
