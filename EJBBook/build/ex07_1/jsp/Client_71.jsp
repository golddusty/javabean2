
<%@ page import="com.titan.customer.*,java.util.Calendar,
                 com.titan.customer.Name" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<% response.addHeader("Cache-Control", "no-cache, must-revalidate"); %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_71 Example Showing Customer/CreditCard Relationship";
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
		CustomerHomeLocal customerhome = (CustomerHomeLocal)obj; 

		obj = jndiContext.lookup("java:comp/env/CreditCardHomeLocal");
		CreditCardHomeLocal cardhome = (CreditCardHomeLocal)obj; 

		out.print("<H2>Creating Customer 71</H2>");

		Integer primaryKey = new Integer(71);
		CustomerLocal customer = customerhome.create(primaryKey);
		customer.setName( new Name("Smith","John") );
 
		out.print("<H2>Creating CreditCard</H2>");

        // set Credit Card info
		Calendar now = Calendar.getInstance();
        java.sql.Date aDate = new java.sql.Date(System.currentTimeMillis());
		//CreditCardLocal card = cardhome.create(now.getTime(), "370000000000001", "John Smith", "O'Reilly");
        CreditCardLocal card = cardhome.create(aDate , "370000000000001", "John Smith", "O'Reilly");
		out.print("<H2>Linking CreditCard and Customer</H2>");

		customer.setCreditCard(card);
 
 		out.print("<H2>Testing both directions on relationship</H2>");

		String cardname = customer.getCreditCard().getNameOnCard();
		out.print("customer.getCreditCard().getNameOnCard()="+cardname+"<br>");

		Name name = card.getCustomer().getName();
		String custfullname = name.getFirstName()+" "+name.getLastName();
		out.print("card.getCustomer().getName()="+custfullname+"<br>");

		out.print("<H2>Contents of Tables</H2>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%
		table = "CreditCardBeanTable";
		%><%@ include file="ViewTable.jsp" %><%
 		out.print("<H2>Unlink the beans using CreditCard, test Customer side</H2>");

		card.setCustomer(null);

		CreditCardLocal newcardref = customer.getCreditCard();
		if (newcardref == null) {
			out.print("Card is properly unlinked from customer bean<br>");
		} else {
			out.print("Whoops, customer still thinks it has a card!<br>");
		}
		table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%
		table = "CreditCardBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
