
<%@ page import="com.titan.travelagent.*,com.titan.cabin.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_54 Example showing use of handles";
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
		CabinHomeRemote home = (CabinHomeRemote)
			PortableRemoteObject.narrow(ref,CabinHomeRemote.class);

		out.print("<br>"+"Testing serialization of EJBObject handle");

		Integer pk_1 = new Integer(100);
		CabinRemote cabin_1 = home.findByPrimaryKey(pk_1);

		// Serialize the Handle for cabin 100 to a file.
		Handle handle = cabin_1.getHandle();
		FileOutputStream fos = new FileOutputStream("handle100.ser");
		ObjectOutputStream outStream = new ObjectOutputStream(fos);
		out.print("<br>"+"Writing handle to file...");
		outStream.writeObject(handle);
		outStream.flush();
		fos.close();
		handle = null;

		// Deserialize the Handle for cabin 100.
		FileInputStream fis = new FileInputStream("handle100.ser");
		ObjectInputStream inStream = new ObjectInputStream(fis);
		out.print("<br>"+"Reading handle from file...");
		handle = (Handle)inStream.readObject();
		inStream.close();

		// Reobtain a remote reference to cabin 100 and read its name.
		out.print("<br>"+"Acquiring reference using deserialized handle...");
		ref = handle.getEJBObject();
		CabinRemote cabin_2 = (CabinRemote)
			PortableRemoteObject.narrow(ref, CabinRemote.class);

		if(cabin_1.isIdentical(cabin_2)) {
			out.print("<br>"+"cabin_1.isIdentical(cabin_2) returns true - This is correct");
		} else {
			out.print("<br>"+"cabin_1.isIdentical(cabin_2) returns false - This is wrong!");
		}

		out.print("<br>"+"Testing serialization of Home handle");

		// Serialize the HomeHandle for the cabin bean.
		HomeHandle homeHandle = home.getHomeHandle();
		fos = new FileOutputStream("handle.ser");
		outStream = new ObjectOutputStream(fos);
		out.print("<br>"+"Writing Home handle to file...");
		outStream.writeObject(homeHandle);
		outStream.flush();
		fos.close();
		homeHandle = null;

		// Deserialize the HomeHandle for the cabin bean.
		fis = new FileInputStream("handle.ser");
		inStream = new ObjectInputStream(fis);
		out.print("<br>"+"Reading Home handle from file...");
		homeHandle = (HomeHandle)inStream.readObject();
		fis.close();

		out.print("<br>"+"Acquiring reference using deserialized Home handle...");
		Object hometemp = homeHandle.getEJBHome();
		CabinHomeRemote home2 = (CabinHomeRemote)
			PortableRemoteObject.narrow(hometemp,CabinHomeRemote.class);


		out.print("<br>"+"Acquiring reference to bean using new Home interface...");
		CabinRemote cabin_3 = home2.findByPrimaryKey(pk_1);

		// Test that we end up with the same bean after finding it through this home
		if(cabin_1.isIdentical(cabin_3)) {
			out.print("<br>"+"cabin_1.isIdentical(cabin_3) returns true - This is correct");
		} else {
			out.print("<br>"+"cabin_1.isIdentical(cabin_3) returns false - This is wrong!");
		}

			
%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
