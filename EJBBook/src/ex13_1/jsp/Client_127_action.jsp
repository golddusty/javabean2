
<%@ page import="com.titan.travelagent.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_127_action Results of listAvailableCabins call";
%>

<html>
<head>

<title><%= title %></title>

</head>

<body bgcolor="#ffffff" LEFTMARGIN="10" RIGHTMARGIN="10"
      link="#3366cc" vlink="#9999cc" alink="#0000cc">

<H1><%= title %></H1>

<A HREF="Client_127.jsp">Return to Client_127.jsp</A><br><br>

<%

	try {

		out.print("Cruise ID = "+request.getParameter("cruiseID")+"<br>");
		out.print("Bed Count = "+request.getParameter("bedCount")+"<br>");

		Integer cruiseID = new Integer(request.getParameter("cruiseID"));
		int bedCount = new Integer(request.getParameter("bedCount")).intValue();

		Context jndiContext = getInitialContext();
		Object obj = jndiContext.lookup("java:comp/env/TravelAgentHomeRemote");
		TravelAgentHomeRemote tahome = (TravelAgentHomeRemote) 
			javax.rmi.PortableRemoteObject.narrow(obj, TravelAgentHomeRemote.class);

		// Start the Stateful session bean
		out.println("<H2>Starting TravelAgent Session...</H2>");
		TravelAgentRemote tagent = tahome.create(null);

		// Set the other bean parameters in agent bean
		out.println("<H2>Setting Cruise information in TravelAgent..</H2>");
		tagent.setCruiseID(cruiseID);

		out.println("<H2>Calling listAvailableCabins()..</H2>");
		String[] results = tagent.listAvailableCabins(bedCount);

		tagent.remove();

		out.println("<H2>Result of listAvailableCabins:</H2>");
		for (int kk=0; kk<results.length; kk++) {
			out.println(results[kk]+"<br>");
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

		table = "CustomerBean_reservations_ReservationBean_customersTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBean_cabins_CabinBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
