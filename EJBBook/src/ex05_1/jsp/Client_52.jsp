<%@ page language="java" %>
<%@ page import="com.titan.travelagent.*,com.titan.cabin.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_52 Example showing metadata functions";
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
	   
		Object ref = jndiContext.lookup("CabinHome");
		CabinHomeRemote c_home = (CabinHomeRemote)
			PortableRemoteObject.narrow(ref, CabinHomeRemote.class);

		EJBMetaData meta = c_home.getEJBMetaData();

		out.print(meta.getHomeInterfaceClass().getName()+"<br>");
		out.print(meta.getRemoteInterfaceClass().getName()+"<br>");
		out.print(meta.getPrimaryKeyClass().getName()+"<br>");
		out.print(meta.isSession()+"<br>");

		Class primKeyType = meta.getPrimaryKeyClass();
		if (primKeyType.getName().equals("java.lang.Integer")) {
			Integer pk = new Integer(1);
			Object ref2 = meta.getEJBHome();
			CabinHomeRemote c_home2 = (CabinHomeRemote)
				PortableRemoteObject.narrow(ref2,CabinHomeRemote.class);
			CabinRemote cabin = c_home2.findByPrimaryKey(pk);
			out.print(cabin.getName()+"<br>");
		}
			
%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
