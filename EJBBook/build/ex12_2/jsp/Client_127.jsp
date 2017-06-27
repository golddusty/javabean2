
<%@ page import="com.titan.travelagent.*, com.titan.customer.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_126 Lists available cabins for a specific Cruise having a desired number of beds";
%>

<html>
<head>

<title><%= title %></title>

</head>

<body bgcolor="#ffffff" LEFTMARGIN="10" RIGHTMARGIN="10"
      link="#3366cc" vlink="#9999cc" alink="#0000cc">

<H1><%= title %></H1>

<FORM METHOD=POST ACTION="Client_127_action.jsp">

	<H3>Enter the desired parameters for the call to listAvailableCabins()</H3>

	<TABLE>
		<TR>
			<TD>Cruise ID</TD>
			<TD><INPUT TYPE="text" NAME="cruiseID"></TD>
		</TR>
		<TR>
			<TD>Bed Count</TD>
			<TD><INPUT TYPE="text" NAME="bedCount"></TD>
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

		table = "CustomerBean_reservations_ReservationBean_customersTable";
		%><%@ include file="ViewTable.jsp" %><%

		table = "ReservationBean_cabins_CabinBean_Table";
		%><%@ include file="ViewTable.jsp" %><%

        table = "ShipBean_cabins_CabinBean_shipTable";
		%><%@ include file="ViewTable.jsp" %><%

        table = "CruiseBean_ship_ShipBean_Table";
		%><%@ include file="ViewTable.jsp" %><%

%>

<%@ include file="CatchBlocks.jsp" %>



</body>
</html>
