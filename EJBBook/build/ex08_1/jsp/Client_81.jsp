
<%@ page import="com.titan.customer.*,com.titan.customer.Name,com.titan.address.*" %>
<%@ page import="javax.naming.*,javax.ejb.EJBException,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_81 Example Showing Simple Customer EJB-QL";
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
		// obtain Home interfaces
		Context jndiContext = getInitialContext();
		Object obj = jndiContext.lookup("java:comp/env/CustomerHomeLocal");
		CustomerHomeLocal customerhome = (CustomerHomeLocal)obj;

		obj = jndiContext.lookup("java:comp/env/AddressHomeLocal");
		AddressHomeLocal addresshome = (AddressHomeLocal)obj;

		String cities[] = new String[6];
		cities[0]="Minneapolis"; cities[1]="St. Paul"; cities[2]="Rochester";
		cities[3]="Winona"; cities[4]="Wayzata"; cities[5]="Eagan";

		out.print("<H2>Creating Customers 80-99</H2>");

		for (int kk=80; kk<=99; kk++) {
			CustomerLocal customer = customerhome.create(new Integer(kk));
			customer.setName( new Name("Smith"+kk,"John") );
			customer.addPhoneNumber("612-555-12"+kk,(byte)1);
			AddressLocal addr = addresshome.createAddress("10"+kk+" Elm Street", cities[(kk-80)%6], (kk%2==0?"MN":"CA"), "5540"+(kk%5+1));
			customer.setHomeAddress(addr);
			customer.setHasGoodCredit((kk%4==0));
			out.print("pk="+kk+" "+customer.getName().getFirstName()+" "+customer.getName().getLastName()
				+" "+addr.getStreet()+" "+addr.getCity()+", "+addr.getState()+" "+addr.getZip()+"<br>");
		}

		out.print("<H2>Finding Customer having name 'John Smith85'</H2>");

		CustomerLocal customer85 = customerhome.findByName("Smith85","John");
		AddressLocal addr85 = customer85.getHomeAddress();

		out.print(customer85.getName().getFirstName()+" "+customer85.getName().getLastName()
			+" "+addr85.getStreet()+" "+addr85.getCity()+", "+addr85.getState()+" "+addr85.getZip()+"<br>");


		out.print("<H2>Contents of Tables</H2>");

		out.print("<A HREF='DeleteAllRowsAllTables.jsp'>Delete All Rows in All Workbook Tables</A><br>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "AddressBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CreditCardBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "PhoneBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>


</body>
</html>
