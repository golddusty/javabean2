<%@ page language="java" %>
<%@ page import="com.titan.travelagent.*,com.titan.cabin.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.CreateException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  public static void makeCabin(CabinHomeRemote home, 
                                int Id, int deckLevel, int shipNumber, int bc, int suiteNumber)
    throws RemoteException, CreateException {

        CabinRemote cabin = home.create(new Integer(Id));
        cabin.setName("Suite "+suiteNumber);
        cabin.setDeckLevel(deckLevel);
        cabin.setBedCount(bc);
        cabin.setShipId(shipNumber);
  }

  final String title = "Client_51_undo Re-create Cabin 30 to undo Client_51 change";
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
	   
		Object ref = jndiContext.lookup("TravelAgentHome");
		TravelAgentHomeRemote agentHome = (TravelAgentHomeRemote)
			PortableRemoteObject.narrow(ref,TravelAgentHomeRemote.class);

		TravelAgentRemote agent = agentHome.create();
		String list [] = agent.listCabins(1,3);  
		out.print("<h2>1st List: Before re-creating cabin number 30</h2>");
		for(int i = 0; i < list.length; i++){
			out.print(list[i]+"<br>");
		}

		// Obtain the home and re-create cabin 30. Rerun the same cabin list.

		ref = jndiContext.lookup("CabinHome");
		CabinHomeRemote c_home = (CabinHomeRemote)
			PortableRemoteObject.narrow(ref, CabinHomeRemote.class);

		// re-create the single cabin (#30) we deleted with Client_4 example
		makeCabin(c_home, 30, 3, 1, 3, 309);

		list = agent.listCabins(1,3);  
		out.print("<h2>2nd List: After re-creating cabin number 30</h2>");
		for (int i = 0; i < list.length; i++) {
			out.print(list[i]+"<br>");
		}
			
%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
