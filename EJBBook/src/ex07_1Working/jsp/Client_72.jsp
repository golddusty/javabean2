
<%@ page import="com.titan.customer.*,com.titan.address.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<% response.addHeader("Cache-Control", "no-cache, must-revalidate"); %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_72 Example Showing Customer/Address Relationship";
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

		obj = jndiContext.lookup("java:comp/env/AddressHomeLocal");
		AddressHomeLocal addresshome = (AddressHomeLocal)obj; 

		out.print("<H2>Finding Customer 71</H2>");

		// Find Customer 71
		Integer primaryKey = new Integer(71);
		CustomerLocal customer = home.findByPrimaryKey(primaryKey);
		 
		AddressLocal addr = customer.getHomeAddress();

		if (addr==null) {
			out.print("Address reference is NULL, Creating one and setting in Customer..<br>");
			addr = addresshome.createAddress(new Integer(11), "333 North Washington","Minneapolis","MN","55401");
			customer.setHomeAddress(addr);
		}
		
		out.print("Address Info: "+addr.getStreet()+" "+addr.getCity()+", "+addr.getState()+" "+addr.getZip()+"<br>");

		out.print("<H2>Modifying Address through address reference</H2>");

		addr.setStreet("445 East Lake Street");
		addr.setCity("Wayzata");
		addr.setState("MN");
		addr.setZip("55432");

		out.print("Address Info: "+addr.getStreet()+" "+addr.getCity()+", "+addr.getState()+" "+addr.getZip()+"<br>");

		out.print("<H2>Creating New Address and calling setHomeAddress</H2>");
		
		addr = addresshome.createAddress(new Integer(12),"700 Main Street","St. Paul","MN","55302");
		out.print("Address Info: "+addr.getStreet()+" "+addr.getCity()+", "+addr.getState()+" "+addr.getZip()+"<br>");
		customer.setHomeAddress(addr);

		// Note: Original Address remains in database, orphaned by setHomeAddress call..

		out.print("<H2>Retrieving Address reference from Customer via getHomeAddress</H2>");

		addr = customer.getHomeAddress();
		out.print("Address Info: "+addr.getStreet()+" "+addr.getCity()+", "+addr.getState()+" "+addr.getZip()+"<br>");

		out.print("<H2>Contents of Tables</H2>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "AddressBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
