
<% /* You found the bonus JSP used to test the ejbSelectCustomer method in Address!  There is a bug in
      WebLogic 6.1 when the workbook went to press which prevents this from working properly.  */ %>

<%@ page import="com.titan.customer.*,com.titan.customer.Name,com.titan.address.*" %>
<%@ page import="javax.naming.*,javax.ejb.EJBException,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_83b Example Showing Address ejbSelectCustomer()";
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

		obj = jndiContext.lookup("java:comp/env/CustomerHomeLocal");
		CustomerHomeLocal customerhome = (CustomerHomeLocal)obj;

		out.print("<H2>Finding an Address bean to use for the test</H2>");

		CustomerLocal cust80 = customerhome.findByPrimaryKey(new Integer(80));  // known key
		AddressLocal addr = cust80.getHomeAddress();

		out.print("<H2>Calling selectCustomer Home method on address</H2>");

		// use the Home method "selectCustomer" to call the private "ejbSelectCustomer" method on the bean
		CustomerLocal customer = addresshome.selectCustomer(addr);

		out.print("<H2>Displaying data for returned Customer bean</H2>");

		out.print(customer.getName().getFirstName()+" "+customer.getName().getLastName()
				+" "+addr.getStreet()+" "+addr.getCity()+", "+addr.getState()+" "+addr.getZip()+"<br>");

		out.print("<H2>Contents of Customer/Address Tables</H2>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "AddressBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		out.print("<br><A HREF='DeleteAllRowsAllTables.jsp'>Delete All Rows in All Workbook Tables</A><br>");

%>

<%@ include file="CatchBlocks.jsp" %>


</body>
</html>
