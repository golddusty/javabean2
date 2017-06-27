
<%@ page import="com.titan.travelagent.*, com.titan.customer.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_126 Books passage for a Customer on a particular Cruise in a specified Cabin";
%>

<html>
<head>

<title><%= title %></title>

</head>

<body bgcolor="#ffffff" LEFTMARGIN="10" RIGHTMARGIN="10"
      link="#3366cc" vlink="#9999cc" alink="#0000cc">

<H1><%= title %></H1>

<FORM METHOD=POST ACTION="Client_126_action.jsp">

	<H3>Enter the desired parameters for the call to bookPassage()</H3>

	<TABLE>
		<TR>
			<TD>Customer ID</TD>
			<TD><INPUT TYPE="text" NAME="customerID"></TD>
		</TR>
		<TR>
			<TD>Cruise ID</TD>
			<TD><INPUT TYPE="text" NAME="cruiseID"></TD>
		</TR>
		<TR>
			<TD>Cabin ID</TD>
			<TD><INPUT TYPE="text" NAME="cabinID"></TD>
		</TR>
		<TR>
			<TD>Price</TD>
			<TD><INPUT TYPE="text" NAME="price"></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" ALIGN="center"><INPUT TYPE="submit" VALUE="Submit"></TD>
		</TR>
	</TABLE>

</FORM>

<%

	try {

   		out.print("<H2>Contents of tables</H2>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ShipBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CabinBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CruiseBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "RESERVATION_CUSTOMER_LINK";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "RESERVATION_CABIN_LINK";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>



</body>
</html>
