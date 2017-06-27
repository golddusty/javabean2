
<%@ page import="com.titan.customer.*,com.titan.customer.Name,com.titan.address.*,
                 java.util.Collection,
                 java.util.Iterator" %>
<%@ page import="javax.naming.*,javax.ejb.EJBException,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_83 Example Showing Address ejbSelectZipCodes()";
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
		Object obj = jndiContext.lookup("java:comp/env/AddressHomeLocal");
		AddressHomeLocal addresshome = (AddressHomeLocal)obj;

		out.print("<H2>Finding zip codes in MN</H2>");

		// use the Home method "selectZipCodes" to call the private "ejbSelectZipCodes" method on the bean
		Collection mnzips = addresshome.selectZipCodes("MN");

		Iterator iterator = mnzips.iterator();
		while (iterator.hasNext()) {
			String zip = (String)(iterator.next());
			out.print(zip+"<br>");
		}

		out.print("<H2>Contents of Address Table</H2>");

		String table = "AddressBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		out.print("<br><A HREF='DeleteAllRowsAllTables.jsp'>Delete All Rows in All Workbook Tables</A><br>");

%>

<%@ include file="CatchBlocks.jsp" %>


</body>
</html>
