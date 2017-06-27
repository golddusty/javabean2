
<%@ page import="com.titan.travelagent.*,com.titan.cabin.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
	public static void getTheEJBHome(javax.servlet.jsp.JspWriter out, TravelAgentRemote agent)
		throws Exception {

		// The home interface is out of scope in this method,
		// so it must be obtained from the EJB object.
		Object ref = agent.getEJBHome();
		TravelAgentHomeRemote home = (TravelAgentHomeRemote)
			PortableRemoteObject.narrow(ref,TravelAgentHomeRemote.class);

		// Do something useful with the home interface
		EJBMetaData meta = home.getEJBMetaData();
		out.print(meta.getHomeInterfaceClass().getName()+"<br>");
		out.print(meta.getRemoteInterfaceClass().getName()+"<br>");
		out.print(meta.isSession()+"<br>");

	}

  final String title = "Client_53 Example of using EJBObject to retrieve home interface";
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
		Object ref = jndiContext.lookup("TravelAgentHome");
		TravelAgentHomeRemote home = (TravelAgentHomeRemote)
			PortableRemoteObject.narrow(ref,TravelAgentHomeRemote.class);

		// Get a remote reference to the bean (EJB object).
		TravelAgentRemote agent = home.create();

		// Pass the remote reference to some method.
		getTheEJBHome(out,agent);
			
%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
