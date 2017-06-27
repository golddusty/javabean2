
<%@ page import="com.titan.customer.*,com.titan.customer.Name,
                 java.util.Collection,
                 java.util.Iterator" %>
<%@ page import="com.titan.ship.*,com.titan.cruise.*,com.titan.reservation.*,com.titan.cabin.*" %>
<%@ page import="javax.naming.*,javax.ejb.EJBException,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_84c Example Demonstrating EJB-QL IN Operations";
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

		obj = jndiContext.lookup("java:comp/env/CruiseHomeLocal");
		CruiseHomeLocal cruisehome = (CruiseHomeLocal)obj;

		obj = jndiContext.lookup("java:comp/env/ReservationHomeLocal");
		ReservationHomeLocal reservationhome = (ReservationHomeLocal)obj;

		obj = jndiContext.lookup("java:comp/env/CustomerHomeLocal");
		CustomerHomeLocal customerhome = (CustomerHomeLocal)obj;

		obj = jndiContext.lookup("java:comp/env/CabinHomeLocal");
		CabinHomeLocal cabinhome = (CabinHomeLocal)obj;

		out.print("<H2>Retrieve a collection of all cabins for Customer 1</H2>");

		CustomerLocal customer1 = customerhome.findByPrimaryKey(new Integer(1));

		// use the Home method "selectAllForCustomer" to call the private "ejbSelectAllForCustomer" method on the bean
		Collection cabins_for_1 = cabinhome.selectAllForCustomer(customer1);
		
		Iterator iter = cabins_for_1.iterator();
		while (iter.hasNext()) {
			CabinLocal cabin = (CabinLocal)(iter.next());
			out.print(cabin.getName()+" on deck "+cabin.getDeckLevel()+"<br>");
		}

		out.print("<H2>Contents of Tables</H2>");

		out.print("<A HREF='DeleteAllRowsAllTables.jsp'>Delete All Rows in All Workbook Tables</A><br>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "RESERVATION_CUSTOMER_LINK";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "RESERVATION_CABIN_LINK";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CabinBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>


</body>
</html>
