
<%@ page import="java.sql.*,javax.naming.InitialContext,javax.naming.Context,
javax.naming.NamingException,javax.rmi.PortableRemoteObject,
java.rmi.RemoteException,java.util.*" %>

<%!

  final String title = "View and Delete Data in Database";

%>

<html>
<head>

<title><%= title %></title>

</head>

<body bgcolor="#ffffff" LEFTMARGIN="10" RIGHTMARGIN="10"
      link="#3366cc" vlink="#9999cc" alink="#0000cc">

<H1><%= title %></H1>

<A HREF="DeleteAllRowsAllTables.jsp">Delete All Rows in All Workbook Tables</A><br>

<%

		String table = "CabinBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ShipBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "AddressBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CreditCardBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "PhoneBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CruiseBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "RESERVATION_CABIN_LINK";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "RESERVATION_CUSTOMER_LINK";
		%><%@ include file="ViewTable.jsp" %><%		

%>

</body>
</html>
