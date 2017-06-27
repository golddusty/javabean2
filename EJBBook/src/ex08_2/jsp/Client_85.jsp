
<%@ page import="com.titan.customer.*,com.titan.customer.Name,
                 java.util.Collection,
                 java.util.Iterator" %>
<%@ page import="com.titan.ship.*,com.titan.cruise.*,com.titan.reservation.*,com.titan.cabin.*" %>
<%@ page import="javax.naming.*,javax.ejb.EJBException,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_85 Example Using Ship findByTonnage variants";
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
		Object obj = jndiContext.lookup("java:comp/env/ShipHomeLocal");
		ShipHomeLocal shiphome = (ShipHomeLocal)obj;

		out.print("<H2>Creating Ship Beans with Various Tonnage Values</H2>");

		for (int jj=1; jj<=10; jj++) {
			ShipLocal ship = shiphome.create(new Integer(jj), "Ship "+jj, 30000.0+(10000.0*jj));
			out.print("pk="+ship.getId()+" Name="+ship.getName()+" tonnage="+ship.getTonnage()+"<br>");
		}

		out.print("<H2>Finding Ships with Exactly 100K Tonnage</H2>");

		Collection ships100k = shiphome.findByTonnage(new Double(100000.0));

		Iterator iterator = ships100k.iterator();
		while (iterator.hasNext()) {
			ShipLocal ship = (ShipLocal)(iterator.next());
			out.print("pk="+ship.getId()+" Name="+ship.getName()+" tonnage="+ship.getTonnage()+"<br>");
		}

		out.print("<H2>Finding Ships with Tonnage between 50K and 110K</H2>");

		Collection ships50110k = shiphome.findByTonnage(new Double(50000.0), new Double(110000.0));

		iterator = ships50110k.iterator();
		while (iterator.hasNext()) {
			ShipLocal ship = (ShipLocal)(iterator.next());
			out.print("pk="+ship.getId()+" Name="+ship.getName()+" tonnage="+ship.getTonnage()+"<br>");
		}



		out.print("<H2>Contents of Tables</H2>");

		out.print("<A HREF='DeleteAllRowsAllTables.jsp'>Delete All Rows in All Workbook Tables</A><br>");

		String table = "ShipBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>


</body>
</html>
