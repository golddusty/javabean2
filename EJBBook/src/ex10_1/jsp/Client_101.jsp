
<%@ page import="com.titan.ship.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_101 Example Showing Ship EJB creation";
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
		Object ref = jndiContext.lookup("ShipHomeRemote");
		ShipHomeRemote home = (ShipHomeRemote)
			PortableRemoteObject.narrow(ref,ShipHomeRemote.class);
		
		out.print("<H2>Creating Ship 101..</H2>");
		ShipRemote ship1 = home.create(new Integer(101),"Edmund Fitzgerald");

		String table = "Ship";
		%><%@ include file="ViewTable.jsp" %><%		

		out.print("<H2>Setting Tonnage/Capacity on Ship 101..</H2>");
		ship1.setTonnage(50000.0);
		ship1.setCapacity(300);

   		table = "Ship";
		%><%@ include file="ViewTable.jsp" %><%		

		Integer pk = new Integer(101);

		out.print("<H2>Finding Ship 101 again..</H2>");
		ShipRemote ship2 = home.findByPrimaryKey(pk);
		out.println(ship2.getName()+"<br>");
		out.println(ship2.getTonnage()+"<br>");
		out.println(ship2.getCapacity()+"<br>");

		out.print("<H2>Removing Ship 101..</H2>");
		ship2.remove();

		table = "Ship";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
