
<%@ page import="com.titan.cruise.*,com.titan.ship.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<% response.addHeader("Cache-Control", "no-cache, must-revalidate"); %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_75 Example Showing Cruise/Ship Relationship (Fig 7-14)";
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
		// obtain ShipHome
		Context jndiContext = getInitialContext();
		Object obj = jndiContext.lookup("java:comp/env/ShipHomeLocal");
		ShipHomeLocal shiphome = (ShipHomeLocal)obj; 

		out.print("<H2>Creating Ships</H2>");

		// Create some Ship beans - manually set key
		ShipLocal shipA = shiphome.create(new Integer(1001), "Ship A", 30000.0); 
		ShipLocal shipB = shiphome.create(new Integer(1002), "Ship B", 40000.0); 

		out.print("PK="+shipA.getId()+" name="+shipA.getName()+" tonnage="+shipA.getTonnage()+"<br>");
		out.print("PK="+shipB.getId()+" name="+shipB.getName()+" tonnage="+shipB.getTonnage()+"<br>");

		out.print("<H2>Creating Cruises</H2>");

		// Create some Cruise beans - automatic key generation by CMP engine
		// Link 1-3 to Ship A, 4-6 to Ship B
		obj = jndiContext.lookup("java:comp/env/CruiseHomeLocal");
		CruiseHomeLocal cruisehome = (CruiseHomeLocal)obj; 

		CruiseLocal cruises[] = new CruiseLocal[7];
		cruises[1] = cruisehome.create("Cruise 1", shipA);
		cruises[2] = cruisehome.create("Cruise 2", shipA);
		cruises[3] = cruisehome.create("Cruise 3", shipA);
		cruises[4] = cruisehome.create("Cruise 4", shipB);
		cruises[5] = cruisehome.create("Cruise 5", shipB);
		cruises[6] = cruisehome.create("Cruise 6", shipB);

		for (int jj=1; jj<7; jj++) {
			CruiseLocal cc = cruises[jj];
			out.print(cc.getName()+" is using "+cc.getShip().getName()+"<br>");
		}

		out.print("<H2>Changing Cruise 1 to use same ship as Cruise 4</H2>");

		ShipLocal newship = cruises[4].getShip();
		cruises[1].setShip(newship);

		for (int jj=1; jj<7; jj++) {
			CruiseLocal cc = cruises[jj];
			out.print(cc.getName()+" is using "+cc.getShip().getName()+"<br>");
		}

		out.print("<H2>Contents of Tables</H2>");

		out.print("<A HREF='DeleteAllRowsAllTables.jsp'>Delete All Rows in All Workbook Tables</A><br>");

		String table = "ShipBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CruiseBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
