
<%@ page import="com.titan.travelagent.*, com.titan.customer.*, com.titan.processpayment.CreditCardDO,
                 java.util.Calendar" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_126_action Results of bookPassage call";
%>

<html>
<head>

<title><%= title %></title>

</head>

<body bgcolor="#ffffff" LEFTMARGIN="10" RIGHTMARGIN="10"
      link="#3366cc" vlink="#9999cc" alink="#0000cc">

<H1><%= title %></H1>

<A HREF="Client_126.jsp">Return to Client_126.jsp</A><br><br>

<%

	try {

		out.print("Customer ID = "+request.getParameter("customerID")+"<br>");
		out.print("Cruise ID = "+request.getParameter("cruiseID")+"<br>");
		out.print("Cabin ID = "+request.getParameter("cabinID")+"<br>");
		out.print("Price = "+request.getParameter("price")+"<br>");

		Integer customerID = new Integer(request.getParameter("customerID"));
		Integer cruiseID = new Integer(request.getParameter("cruiseID"));
		Integer cabinID = new Integer(request.getParameter("cabinID"));
		double price = new Double(request.getParameter("price")).doubleValue();

		Context jndiContext = getInitialContext();
		Object obj = jndiContext.lookup("java:comp/env/TravelAgentHomeRemote");
		TravelAgentHomeRemote tahome = (TravelAgentHomeRemote) 
			javax.rmi.PortableRemoteObject.narrow(obj, TravelAgentHomeRemote.class);

		obj = jndiContext.lookup("java:comp/env/CustomerHomeRemote");
		CustomerHomeRemote custhome = (CustomerHomeRemote) 
			javax.rmi.PortableRemoteObject.narrow(obj, CustomerHomeRemote.class);

		// Find a reference to the Customer for which to book a cruise
		out.println("<H2>Finding reference to Customer "+customerID+"</H2>");
		CustomerRemote cust = custhome.findByPrimaryKey(customerID);

		// Start the Stateful session bean
		out.println("<H2>Starting TravelAgent Session...</H2>");
		TravelAgentRemote tagent = tahome.create(cust);

		// Set the other bean parameters in agent bean
		out.println("<H2>Setting Cruise and Cabin information in TravelAgent..</H2>");
		tagent.setCruiseID(cruiseID);
		tagent.setCabinID(cabinID);

		// Create a dummy CreditCard for this.  Really should use Customer's card, but CreditCard bean is local
		// and there is no getCreditCard() function on Customer which returns a CreditCardDO object.
		Calendar expdate = Calendar.getInstance();
		expdate.set(2005,1,5);
		CreditCardDO card = new CreditCardDO("370000000000002",expdate.getTime(),"AMERICAN EXPRESS");

		// Book the passage
		out.println("<H2>Booking the passage on the Cruise!</H2>");
		TicketDO ticket = tagent.bookPassage(card,price);

		tagent.remove();

		out.println("<H2>Result of bookPassage:</H2>");
		out.println(ticket.description);
				
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

		table = "ReservationBean_cabins_CabinBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
