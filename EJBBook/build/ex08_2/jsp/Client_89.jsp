
<%@ page import="com.titan.customer.*,com.titan.customer.Name,com.titan.address.*,
                 java.util.Collection,
                 java.util.Iterator" %>
<%@ page import="javax.naming.*,javax.ejb.EJBException,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_89 Example Using Customer findByState() with ORDERBY clause";
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
		// obtain Home interfaces
		Context jndiContext = getInitialContext();
		Object obj = jndiContext.lookup("java:comp/env/CustomerHomeLocal");
		CustomerHomeLocal customerhome = (CustomerHomeLocal)obj;

		obj = jndiContext.lookup("java:comp/env/AddressHomeLocal");
		AddressHomeLocal addresshome = (AddressHomeLocal)obj;

		out.print("<H2>Finding Customers In MN using findByState() with ORDERBY clause</H2>");

		Collection mncustomers = customerhome.findByState("MN");

		Iterator iterator = mncustomers.iterator();
		while (iterator.hasNext()) {
			CustomerLocal customer = (CustomerLocal)(iterator.next());
			AddressLocal addr = customer.getHomeAddress();
			out.print(customer.getName().getFirstName()+" "+customer.getName().getLastName()
				+" "+addr.getStreet()+" "+addr.getCity()+", "+addr.getState()+" "+addr.getZip()+"<br>");
		}

		out.print("<H2>Contents of Tables</H2>");

		out.print("<A HREF='DeleteAllRowsAllTables.jsp'>Delete All Rows in All Workbook Tables</A><br>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>


</body>
</html>
