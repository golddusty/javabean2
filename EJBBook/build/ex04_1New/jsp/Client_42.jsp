
<%@ page import="com.titan.cabin.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.CreateException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!

  public static void makeCabins(CabinHomeRemote home, 
                                int fromId, int toId, 
                                int deckLevel, int shipNumber)
    throws RemoteException, CreateException {

    int bc = 3;
    for (int i = fromId; i <= toId; i++) {        
        CabinRemote cabin = home.create(new Integer(i));
        int suiteNumber = deckLevel*100+(i-fromId);
        cabin.setName("Suite "+suiteNumber);
        cabin.setDeckLevel(deckLevel);
        bc = (bc==3)?2:3;
        cabin.setBedCount(bc);
        cabin.setShipId(shipNumber);
    }
  }

  final String title = "Client_42 Example Showing Cabin EJB creation";
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
		// Obtain home interface for Cabin EJB
		Context jndiContext = getInitialContext();
		Object ref = jndiContext.lookup("CabinHome");
		CabinHomeRemote home = (CabinHomeRemote)
			PortableRemoteObject.narrow(ref,CabinHomeRemote.class);

		out.print("<H2>Creating Cabins 2-100</H2>");

		// Add 9 cabins to deck 1 of ship 1.
		makeCabins(home, 2, 10, 1, 1);
		// Add 10 cabins to deck 2 of ship 1.
		makeCabins(home, 11, 20, 2, 1);
		// Add 10 cabins to deck 3 of ship 1.
		makeCabins(home, 21, 30, 3, 1);
		
		// Add 10 cabins to deck 1 of ship 2.
		makeCabins(home, 31, 40, 1, 2);
		// Add 10 cabins to deck 2 of ship 2.
		makeCabins(home, 41, 50, 2, 2);
		// Add 10 cabins to deck 3 of ship 2.
		makeCabins(home, 51, 60, 3, 2);
		
		// Add 10 cabins to deck 1 of ship 3.
		makeCabins(home, 61, 70, 1, 3);
		// Add 10 cabins to deck 2 of ship 3.
		makeCabins(home, 71, 80, 2, 3);
		// Add 10 cabins to deck 3 of ship 3.
		makeCabins(home, 81, 90, 3, 3);
		// Add 10 cabins to deck 4 of ship 3.
		makeCabins(home, 91, 100, 4, 3);

		out.print("<H2>Finding and Displaying Cabins 1-100</H2>");

		for (int i = 1; i <= 100; i++){
			Integer pk = new Integer(i);
			CabinRemote cabin = home.findByPrimaryKey(pk);
			out.print("PK = "+i+", Ship = "+cabin.getShipId()
			  + ", Deck = "+cabin.getDeckLevel()
			  + ", BedCount = "+cabin.getBedCount()
			  + ", Name = "+cabin.getName()+"<br>");
		}

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
