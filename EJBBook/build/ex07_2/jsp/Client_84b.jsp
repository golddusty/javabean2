
<%@ page import="com.titan.customer.*,com.titan.customer.Name,com.titan.address.*,
                 java.util.Iterator,
                 java.util.Collection" %>
<%@ page import="com.titan.ship.*,com.titan.cruise.*,com.titan.reservation.*,com.titan.cabin.*" %>
<%@ page import="javax.naming.*,javax.ejb.EJBException,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_84b Example Demonstrating EJB-QL finder methods";
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

		Object obj = jndiContext.lookup("java:comp/env/CabinHomeLocal");
		CabinHomeLocal cabinhome = (CabinHomeLocal)obj;

		out.print("<H2>Retrieve a collection of all cabins on deck 3</H2>");

		Collection cabins = cabinhome.findAllOnDeckLevel(new Integer(3));
		
		Iterator iter = cabins.iterator();
		while (iter.hasNext()) {
			CabinLocal cabin = (CabinLocal)(iter.next());
			out.print(cabin.getName()+" on deck "+cabin.getDeckLevel()+"<br>");
		}

		out.print("<H2>Contents of Tables</H2>");

		String table = "CabinBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>


</body>
</html>
