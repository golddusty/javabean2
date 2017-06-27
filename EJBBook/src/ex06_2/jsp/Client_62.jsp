
<%@ page import="com.titan.customer.*, com.titan.customer.Name,java.sql.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_62 Example showing use of Name dependent value class";
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

		Object ref = jndiContext.lookup("CustomerHomeRemote");
		CustomerHomeRemote home = (CustomerHomeRemote)
			PortableRemoteObject.narrow(ref,CustomerHomeRemote.class);

		CustomerRemote customer = null;
		try {
			out.print("Finding Customer 1...<br>");
			customer = home.findByPrimaryKey(new Integer(1));
		}
		catch (FinderException fe) {
			System.out.println("Customer 1 not found, create it...");
			out.print("Customer 1 not found, create it...<br>");
			customer = home.create(new Integer(1));
		}
		
		if (request.getMethod().equals("POST")) {
		
			String lname = getr(request,"lastname");  // grab the POST variable  
			String fname = getr(request,"firstname");  // grab the POST variable  
			Name newname = new Name(lname,fname);
			out.print("Setting Customer 1 name to new values...<br>");
			customer.setName(newname);

			// lets redirect back to same page in GET mode to avoid "refresh" post problem
			response.sendRedirect("Client_62.jsp");
			response.flushBuffer();
			return;

		}

		out.print("<H2>Contents of CUSTOMER table</H2>");

		String table = "CUSTOMER";
		%><%@ include file="ViewTable.jsp" %><%		

		// If we are "GET" mode or have finished the POST operation, display form with current name

		Name name = customer.getName();
%>
		<H2>Handy-Dandy Name Changer</H2>
		<FORM METHOD=POST ACTION="Client_62.jsp">
			<TABLE>
			<TR>
				<TD>Last Name:</TD>
				<TD><INPUT TYPE="text" NAME="lastname" VALUE=<%= name.getLastName() %>></TD>
			</TR>
			<TR>
				<TD>First Name</TD>
				<TD><INPUT TYPE="text" NAME="firstname" VALUE=<%= name.getFirstName() %>></TD>
			</TR>
			<TR>
				<TD COLSPAN=2 ALIGN="CENTER"><INPUT TYPE="submit" VALUE="Update Name"></TD>
			</TABLE>
		</FORM>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
