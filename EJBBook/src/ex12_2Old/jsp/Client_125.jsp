
<%@ page import="com.titan.travelagent.*,
                 java.util.Collection,
                 java.util.Iterator" %>
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
		
		tagent.remove();
	
		Iterator iterator = results.iterator();
		while (iterator.hasNext()) {
			String ss = (String)(iterator.next());
			out.println(ss+"<br>");
		}

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

		table = "RESERVATION_CUSTOMER_LINK";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "RESERVATION_CABIN_LINK";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
