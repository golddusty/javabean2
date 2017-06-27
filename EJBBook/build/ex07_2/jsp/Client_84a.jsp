
<%@ page import="com.titan.customer.*,com.titan.customer.Name,com.titan.address.*,
                 java.util.*,java.sql.Date" %>
<%@ page import="com.titan.ship.*,com.titan.cruise.*,com.titan.reservation.*,com.titan.cabin.*" %>
<%@ page import="javax.naming.*,javax.ejb.EJBException,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_84a Setup Tables for Example Demonstrating EJB-QL";
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
		Object obj = jndiContext.lookup("java:comp/env/ShipHomeLocal");
		ShipHomeLocal shiphome = (ShipHomeLocal)obj;

		obj = jndiContext.lookup("java:comp/env/CruiseHomeLocal");
		CruiseHomeLocal cruisehome = (CruiseHomeLocal)obj;

		obj = jndiContext.lookup("java:comp/env/ReservationHomeLocal");
		ReservationHomeLocal reservationhome = (ReservationHomeLocal)obj;

		obj = jndiContext.lookup("java:comp/env/CustomerHomeLocal");
		CustomerHomeLocal customerhome = (CustomerHomeLocal)obj;

		obj = jndiContext.lookup("java:comp/env/CabinHomeLocal");
		CabinHomeLocal cabinhome = (CabinHomeLocal)obj;

		obj = jndiContext.lookup("java:comp/env/AddressHomeLocal");
		AddressHomeLocal addresshome = (AddressHomeLocal)obj;

		out.print("<H2>Creating a Ship and Cruise</H2>");

		ShipLocal shipA = shiphome.create(new Integer(10772), "Ship A", 30000.0); 
		CruiseLocal cruiseA = cruisehome.create("Cruise A", shipA); 

		out.print("cruise.getName()="+cruiseA.getName()+"<br>");
		out.print("ship.getName()="+shipA.getName()+"<br>");
		out.print("cruise.getShip().getName()="+cruiseA.getShip().getName()+"<br>");

		out.print("<H2>Creating Customers 1-6, each with 2 reservations for 2 cabins</H2>");

		Calendar date = Calendar.getInstance();
		date.set(2002,10,1);

		for (int kk=1; kk<7; kk++) {
			Collection customers = new ArrayList();
			CustomerLocal cust = customerhome.create(new Integer(kk));
			cust.setName(new Name("Customer "+kk,""));
			cust.setHasGoodCredit( (kk%2==0) );  // odds are bums
			AddressLocal addr = addresshome.createAddress("50"+kk+" Main Street","Minneapolis","MN","5510"+kk);
			cust.setHomeAddress(addr);
			out.print(cust.getName().getLastName()+"<br>");
			customers.add(cust);  // put this single customer in the collection
			Collection reservations = new ArrayList();

			for (int jj=0; jj<2; jj++) {

				ReservationLocal reservation = reservationhome.create(cruiseA, customers);
				reservation.setDate(new java.sql.Date(date.getTime().getTime()));
				reservation.setAmountPaid(1000*kk+100*jj+2000);
				out.print("&nbsp;&nbsp;"+reservation.getDate()+" "+reservation.getAmountPaid()+"<br>");
				date.add(Calendar.DAY_OF_MONTH, 7);

				Set cabins = new HashSet();
				CabinLocal cabin = cabinhome.create(new Integer(1000+kk*100+jj));
				cabin.setDeckLevel(kk);
				cabin.setName("Cabin "+kk+"0"+jj+"1");
				out.print("&nbsp;&nbsp;&nbsp;&nbsp;"+cabin.getName()+"<br>");
				cabins.add(cabin);
				cabin = cabinhome.create(new Integer(1000+kk*100+10+jj));
				cabin.setDeckLevel(kk);
				cabin.setName("Cabin "+kk+"0"+jj+"2");
				out.print("&nbsp;&nbsp;&nbsp;&nbsp;"+cabin.getName()+"<br>");
				cabins.add(cabin);

				reservation.setCabins(cabins);  // this reservation has 2 cabins
			}
		}

		out.print("<H2>Contents of Tables</H2>");

		out.print("<A HREF='DeleteAllRowsAllTables.jsp'>Delete All Rows in All Workbook Tables</A><br>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "AddressBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CabinBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "RESERVATION_CUSTOMER_LINK";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "RESERVATION_CABIN_LINK";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>


</body>
</html>
