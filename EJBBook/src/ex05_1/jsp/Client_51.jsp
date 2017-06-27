<%@ page language="java" %>
<%@ page import="com.titan.travelagent.*,com.titan.cabin.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_51 Example Showing remove() and listCabins()";
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
	   
		// Obtain a list of all the cabins for ship 1 with bed count of 3.

		Object ref = jndiContext.lookup("TravelAgentHome");
		TravelAgentHomeRemote agentHome = (TravelAgentHomeRemote)
			PortableRemoteObject.narrow(ref,TravelAgentHomeRemote.class);

		TravelAgentRemote agent = agentHome.create();
		String list [] = agent.listCabins(1,3);  
		out.print("<h2>1st List: Before deleting cabin number 30</h2>");
		for(int i = 0; i < list.length; i++){
			out.print(list[i]+"<br>");
		}

		// Obtain the home and remove cabin 30. Rerun the same cabin list.

		ref = jndiContext.lookup("CabinHome");
		CabinHomeRemote c_home = (CabinHomeRemote)
			PortableRemoteObject.narrow(ref, CabinHomeRemote.class);

		Integer pk = new Integer(30);
		c_home.remove(pk);
		list = agent.listCabins(1,3);  
		out.print("<h2>2nd List: After deleting cabin number 30</h2>");
		for (int i = 0; i < list.length; i++) {
			out.print(list[i]+"<br>");
		}
			
%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
