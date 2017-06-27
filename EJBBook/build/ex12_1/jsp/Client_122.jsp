
<%@ page import="com.titan.customer.*, com.titan.customer.Name, com.titan.processpayment.*,
                 java.util.Calendar" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_122 Example Demonstrating use of ProcessPayment EJB";
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

	   out.println("<H2>Looking up home interfaces..</H2>");

	   Object ref = jndiContext.lookup("ProcessPaymentHomeRemote");			
		   
	   ProcessPaymentHomeRemote procpayhome = (ProcessPaymentHomeRemote)
		   PortableRemoteObject.narrow(ref,ProcessPaymentHomeRemote.class);	

	   ref = jndiContext.lookup("CustomerHomeRemote");			
		   
	   CustomerHomeRemote custhome = (CustomerHomeRemote)
		   PortableRemoteObject.narrow(ref,CustomerHomeRemote.class);	
	
	   ProcessPaymentRemote procpay = procpayhome.create();

	   CustomerRemote cust = custhome.findByPrimaryKey(new Integer(1));
	   
	   out.println("<H2>Making a payment using byCash()..</H2>");
	   procpay.byCash(cust,1000.0);

	   out.println("<H2>Making a payment using byCheck()..</H2>");
	   CheckDO check = new CheckDO("010010101101010100011", 3001);
	   procpay.byCheck(cust,check,2000.0);

	   out.println("<H2>Making a payment using byCredit()..</H2>");
	   Calendar expdate = Calendar.getInstance();
	   expdate.set(2005,1,28); // month=1 is February
	   CreditCardDO credit = new CreditCardDO("370000000000002",expdate.getTime(),"AMERICAN_EXPRESS");
	   procpay.byCredit(cust,credit,3000.0);

	   out.println("<H2>Making a payment using byCheck() with a low check number..</H2>");
	   CheckDO check2 = new CheckDO("111000100111010110101", 1001);
	   try {
		   procpay.byCheck(cust,check2,9000.0);	   	
	   }
	   catch (PaymentException pe) {
			out.println("Caught PaymentException: "+pe.getMessage()+"<br>");
	   }

   		out.print("<H2>Contents of tables</H2>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "AddressBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "PaymentBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
