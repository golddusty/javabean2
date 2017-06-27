
<%@ page import="com.titan.customer.*,com.titan.customer.Name" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,java.util.Vector" %>

<% response.addHeader("Cache-Control", "no-cache, must-revalidate"); %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_73 Example Showing Customer/Phone Relationship";
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
		// obtain CustomerHome
		Context jndiContext = getInitialContext();
		Object obj = jndiContext.lookup("java:comp/env/CustomerHomeLocal");
		CustomerHomeLocal home = (CustomerHomeLocal)obj; 

		// Find Customer 71
		Integer primaryKey = new Integer(71);
		CustomerLocal customer = home.findByPrimaryKey(primaryKey);
		 
		// Display current phone numbers and types
		out.print("Starting contents of phone list:<br>");
		Vector vv = customer.getPhoneList();
		for (int jj=0; jj<vv.size(); jj++) {
			String ss = (String)(vv.get(jj));
			out.print(ss+"<br>");
		}

		// add a new phone number
		out.print("Adding a new type 1 phone number..<br>");
		customer.addPhoneNumber("612-555-1212",(byte)1);

		out.print("New contents of phone list:<br>");
		vv = customer.getPhoneList();
		for (int jj=0; jj<vv.size(); jj++) {
			String ss = (String)(vv.get(jj));
			out.print(ss+"<br>");
		}

		// add a new phone number
		out.print("Adding a new type 2 phone number..<br>");
		customer.addPhoneNumber("800-333-3333",(byte)2);

		out.print("New contents of phone list:<br>");
		vv = customer.getPhoneList();
		for (int jj=0; jj<vv.size(); jj++) {
			String ss = (String)(vv.get(jj));
			out.print(ss+"<br>");
		}

		// update a phone number
		out.print("Updating type 1 phone numbers..<br>");
		customer.updatePhoneNumber("763-555-1212",(byte)1);

		out.print("New contents of phone list:<br>");
		vv = customer.getPhoneList();
		for (int jj=0; jj<vv.size(); jj++) {
			String ss = (String)(vv.get(jj));
			out.print(ss+"<br>");
		}

		// delete a phone number
		out.print("Removing type 1 phone numbers from this Customer..<br>");
		customer.removePhoneNumber((byte)1);

		out.print("Final contents of phone list:<br>");
		vv = customer.getPhoneList();
		for (int jj=0; jj<vv.size(); jj++) {
			String ss = (String)(vv.get(jj));
			out.print(ss+"<br>");
		}

		// Note that the phone is still in the database, but it is no longer related to this customer bean

		out.print("<H2>Contents of Tables</H2>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "PhoneBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
