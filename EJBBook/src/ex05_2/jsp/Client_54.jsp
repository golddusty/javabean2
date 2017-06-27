
<%@ page import="com.titan.travelagent.*,com.titan.cabin.*" %>
<%@ page import="java.io.*"%>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException,javax.ejb.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
	/**
	 * Test the equivalence of two remote references to the same bean
	 */
	public static void testReferences(javax.servlet.jsp.JspWriter out, CabinHomeRemote home)		
		throws Exception {

		out.print("Creating Cabin 101 and retrieving additional reference by pk"+"<br>");
		CabinRemote cabin_1 = home.create(new Integer(101));
		Integer pk = (Integer)cabin_1.getPrimaryKey();
		CabinRemote cabin_2 = home.findByPrimaryKey(pk);

		out.print("Testing reference equivalence"+"<br>");
		// We now have two remote references to the same bean -- Prove it!
		cabin_1.setName("Keel Korner");
		if (cabin_2.getName().equals("Keel Korner")) {
			out.print("Names match!"+"<br>");
		}

		// Test the isIdentical() function
		if (cabin_1.isIdentical(cabin_2)) {
			out.print("cabin_1.isIdentical(cabin_2) returns true - This is correct"+"<br>");
		} else {
			out.print("cabin_1.isIdentical(cabin_2) returns false - This is wrong!"+"<br>");
		}

	}

	/**
	 * Test the serialization/deserialization of a primary key.
	 */
	public static void testSerialization(javax.servlet.jsp.JspWriter out, CabinHomeRemote home)		
		throws Exception {										// FIX

		out.print("Testing serialization of primary key"+"<br>");
		Integer pk_1 = new Integer(101);
		CabinRemote cabin_1 = home.findByPrimaryKey(pk_1);
		out.print("Setting cabin name to Presidential Suite"+"<br>");
		cabin_1.setName("Presidential Suite");

		// Serialize the primary key for cabin 101 to a file.
		FileOutputStream fos = new FileOutputStream("pk101.ser");
		ObjectOutputStream outStream = new ObjectOutputStream(fos);
		out.print("Writing primary key object to file..."+"<br>");
		outStream.writeObject(pk_1);
		outStream.flush();
		outStream.close();
		pk_1 = null;

		// Deserialize the primary key for cabin 101.
		FileInputStream fis = new FileInputStream("pk101.ser");
		ObjectInputStream inStream = new ObjectInputStream(fis);
		out.print("Reading primary key object from file..."+"<br>");
		Integer pk_2 = (Integer)inStream.readObject();
		inStream.close();

		// Re-obtain a remote reference to cabin 101 and read its name.
		out.print("Acquiring reference using deserialized primary key..."+"<br>");
		CabinRemote cabin_2 = home.findByPrimaryKey(pk_2);
		out.print("Retrieving name of Cabin using new remote reference..."+"<br>");
		out.print(cabin_2.getName()+"<br>");

	}

  final String title = "Client_54 Example showing use of primary keys";
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

		testReferences(out, home);
		testSerialization(out, home);

		out.print("Removing Cabin from database to clean up.."+"<br>");
		// Make this client class re-entrant by cleaning up the bean we created
		Integer pk = new Integer(101);
		home.remove(pk);
			
%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
