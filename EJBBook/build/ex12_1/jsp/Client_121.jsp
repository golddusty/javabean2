
<%@ page import="com.titan.customer.*, com.titan.customer.Name" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_121 Create a Customer and Address for use by subsequent programs";
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

		Object ref = jndiContext.lookup("java:comp/env/CustomerHomeRemote");
		CustomerHomeRemote home = (CustomerHomeRemote)
			PortableRemoteObject.narrow(ref,CustomerHomeRemote.class);

		// create a Customer
		out.print("<H2>Creating Customer 1..</H2>");
		Integer primaryKey = new Integer(1);
		CustomerRemote customer = home.create(primaryKey);

		// create an address data object
		out.print("<H2>Creating AddressDO data object..</H2>");
		AddressDO address = new AddressDO("1010 Colorado",	
									  "Austin", "TX", "78701");
		
		// set address in Customer bean
		out.print("<H2>Setting Address in Customer 1...</H2>");
		customer.setAddress(address);

   		out.print("<H2>Contents of CUSTOMER/ADDRESS tables</H2>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "AddressBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
