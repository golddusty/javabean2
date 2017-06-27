
<%@ page import="com.titan.cabin.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_41 Example Showing Cabin EJB creation";
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
		// Obtain home interface for Cabin EJB
		Context jndiContext = getInitialContext();
		Object ref = jndiContext.lookup("CabinHome");
		CabinHomeRemote home = (CabinHomeRemote)
			PortableRemoteObject.narrow(ref,CabinHomeRemote.class);

		out.print("<H2>Creating Cabin 1</H2>");

		CabinRemote cabin_1 = home.create(new Integer(1));
		cabin_1.setName("Master Suite");
		cabin_1.setDeckLevel(1);
		cabin_1.setShipId(1);
		cabin_1.setBedCount(3);
			
		Integer pk = new Integer(1);

		out.print("<H2>Finding Cabin 1 Again using findByPrimaryKey()</H2>");

		CabinRemote cabin_2 = home.findByPrimaryKey(pk);

		out.print(cabin_2.getName()+"<br>");
		out.print(cabin_2.getDeckLevel()+"<br>");
		out.print(cabin_2.getShipId()+"<br>");
		out.print(cabin_2.getBedCount()+"<br>");

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
