
<%@ page import="com.titan.address.*,com.titan.customer.*,com.titan.cruise.*,com.titan.ship.*,com.titan.customer.*,
                 com.titan.reservation.*,com.titan.cabin.*,
                 com.titan.customer.Name,
                 java.util.Calendar,
                 java.util.Iterator,
                 java.util.Set,
                 java.util.Vector" %>
<%@ page import="java.text.*,javax.naming.*,javax.transaction.*,javax.rmi.*" %>

<% response.addHeader("Cache-Control", "no-cache, must-revalidate"); %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_78 Example Showing Cascade Delete for Customer EJB";
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
        out.print("<H2>Obtained Customer Reference</H2>");

		obj = jndiContext.lookup("java:comp/env/AddressHomeLocal");
		AddressHomeLocal addresshome = (AddressHomeLocal)obj;
        out.print("<H2>obtained Address Reference</H2>");
		obj = jndiContext.lookup("java:comp/env/CreditCardHomeLocal");
		CreditCardHomeLocal cardhome = (CreditCardHomeLocal)obj; 
        out.print("<H2>Obtained CreditCard Reference</H2>");


		out.print("<H2>Creating Customer 10078, Addresses, Credit Card, Phones</H2>");

		CustomerLocal customer = customerhome.create(new Integer(10078)); 
		customer.setName( new Name("Star","Ringo") );
 
		out.print("<H2>Creating CreditCard</H2>");

        // set Credit Card info
		Calendar now = Calendar.getInstance();

        java.sql.Date aDate = new java.sql.Date(System.currentTimeMillis());
		CreditCardLocal card = cardhome.create(aDate, "370000000000001", "Ringo Star", "Beatles");

		customer.setCreditCard(card);
 
		out.print("customer.getCreditCard().getName()="+customer.getCreditCard().getNameOnCard()+"<br>");

		out.print("<H2>Creating Address</H2>");

		AddressLocal addr = addresshome.createAddress("780 Main Street","Beverly Hills","CA","90210");

		customer.setHomeAddress(addr);

		out.print("Address Info: "+addr.getStreet()+" "+addr.getCity()+", "+addr.getState()+" "+addr.getZip()+"<br>");

		out.print("<H2>Creating Phones</H2>");
				
				
		out.print("Adding a new type 1 phone number..<br>");
		customer.addPhoneNumber("612-555-1212",(byte)1);
		out.print("Adding a new type 2 phone number..<br>");
		customer.addPhoneNumber("888-555-1212",(byte)2);

		out.print("New contents of phone list:<br>");
		Vector vv = customer.getPhoneList();
		for (int jj=0; jj<vv.size(); jj++) {
			String ss = (String)(vv.get(jj));
			out.print(ss+"<br>");
		}

		out.print("<H2>Contents of Tables Before Remove</H2>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "AddressBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CreditCardBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "PhoneBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		out.print("<H2>Removing Customer EJB only</H2>");

		customer.remove();

		out.print("<H2>Contents of Tables After Remove</H2>");

		table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "AddressBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CreditCardBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "PhoneBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
