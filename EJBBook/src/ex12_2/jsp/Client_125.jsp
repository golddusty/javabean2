
<%@ page import="com.titan.travelagent.*,
                 java.util.Collection,
                 java.util.Iterator,
                 java.util.ArrayList,
                 com.titan.customer.CustomerHomeRemote,
                 com.titan.cabin.CabinHomeLocal,
                 com.titan.ship.ShipHomeLocal,
                 com.titan.cruise.CruiseHomeLocal,
                 com.titan.reservation.ReservationHomeLocal,
                 com.titan.customer.CustomerRemote,
                 com.titan.customer.Name,
                 com.titan.ship.ShipLocal,
                 com.titan.cabin.CabinLocal,
                 com.titan.cruise.CruiseLocal,
                 com.titan.reservation.ReservationLocal" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_125 Create Customer, Cabin, Ship, and Cruise objects for use in this exercise";
%>

<html>
<head>

<title><%= title %></title>

</head>

<body bgcolor="#ffffff" LEFTMARGIN="10" RIGHTMARGIN="10"
      link="#3366cc" vlink="#9999cc" alink="#0000cc">

<H1><%= title %></H1>

<%

	try {
		Context jndiContext = getInitialContext();
		Object obj = jndiContext.lookup("java:comp/env/TravelAgentHomeRemote");
		TravelAgentHomeRemote tahome = (TravelAgentHomeRemote) 
			javax.rmi.PortableRemoteObject.narrow(obj, TravelAgentHomeRemote.class);

		TravelAgentRemote tagent = tahome.create(null);

		out.println("<H2>Calling TravelAgentBean to create sample data..</H2>");

		Collection results = tagent.buildSampleData();
		out.println("<H2>Finished TravelAgentBean to create sample data..</H2>");
		tagent.remove();
	
		Iterator iterator = results.iterator();
		while (iterator.hasNext()) {
			String ss = (String)(iterator.next());
			out.println(ss+"<br>");
		}
	/*		System.out.println("Client_125::buildSampleData()");
            Collection results = new ArrayList();
			obj = jndiContext.lookup("java:comp/env/ejb/CustomerHomeRemote");
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
   	*/
        out.print("<H2>Contents of tables</H2>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ShipBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CabinBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CruiseBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CustomerBean_reservations_ReservationBean_customersTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBean_cabins_CabinBean_Table";
		%><%@ include file="ViewTable.jsp" %><%

        table = "ShipBean_cabins_CabinBean_shipTable";
		%><%@ include file="ViewTable.jsp" %><%

        table = "CruiseBean_ship_ShipBean_Table";
		%><%@ include file="ViewTable.jsp" %><%


%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
