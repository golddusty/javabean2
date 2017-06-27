
<%@ page import="com.titan.customer.*,com.titan.customer.Name,com.titan.address.*,
                 java.util.Calendar,
                 java.util.Collection,
                 java.util.ArrayList" %>
<%@ page import="com.titan.cruise.*,com.titan.reservation.*,com.titan.ship.*" %>
<%@ page import="javax.naming.*,javax.ejb.EJBException,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_86a Performs Customer Setup for Subsequent Examples";
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

		obj = jndiContext.lookup("java:comp/env/ShipHomeLocal");
		ShipHomeLocal shiphome = (ShipHomeLocal)obj;

		obj = jndiContext.lookup("java:comp/env/CruiseHomeLocal");
		CruiseHomeLocal cruisehome = (CruiseHomeLocal)obj;

		obj = jndiContext.lookup("java:comp/env/ReservationHomeLocal");
		ReservationHomeLocal reservationhome = (ReservationHomeLocal)obj;

		String cities[] = new String[6];
		cities[0]="Minneapolis"; cities[1]="St. Paul"; cities[2]="Rochester";
		cities[3]="Winona"; cities[4]="Wayzata"; cities[5]="Eagan";

		String fnames[] = new String[5];
		fnames[0]="John"; fnames[1]="Paul"; fnames[2]="Ringo";
		fnames[3]="Joe"; fnames[4]="Roger";

		String lnames[] = new String[3];
		lnames[0]="Smith"; lnames[1]="Johnson"; lnames[2]="Star";

		ShipLocal ship1 = shiphome.findByPrimaryKey(new Integer(1));
		CruiseLocal cruiseA = cruisehome.create("Alaska Cruise", ship1); 
		CruiseLocal cruiseB = cruisehome.create("Bohemian Cruise", ship1); 

		Calendar date = Calendar.getInstance();
		date.set(2002,10,1);

		out.print("<H2>Creating Customers 80-99</H2>");

		for (int kk=80; kk<=99; kk++) {
			CustomerLocal customer = customerhome.create(new Integer(kk));
			customer.setName( new Name(lnames[(kk-80)%3], fnames[(kk-80)%5]) );
			customer.addPhoneNumber("612-555-12"+kk,(byte)1);
			AddressLocal addr = addresshome.createAddress("10"+kk+" Elm Street", cities[(kk-80)%6], (kk%2==0?"MN":"CA"), "5540"+(kk%5+1));
			customer.setHomeAddress(addr);
			customer.setHasGoodCredit((kk%4==0));
			out.print("pk="+kk+" "+customer.getName().getFirstName()+" "+customer.getName().getLastName()
				+" "+addr.getStreet()+" "+addr.getCity()+", "+addr.getState()+" "+addr.getZip()+"<br>");

			// Some customers will have reservations already on one of the two cruises..
			if (kk%3!=0) {
				Collection customers = new ArrayList();
				customers.add(customer);  // put this single customer in the collection
				ReservationLocal reservation = reservationhome.create((kk%3==1?cruiseA:cruiseB), customers);
				reservation.setDate(new java.sql.Date(date.getTime().getTime()));
				reservation.setAmountPaid(10*kk+2000);
				out.print("&nbsp;&nbsp;Has Reservation on "+reservation.getCruise().getName()+" on date "+reservation.getDate()+" costing "+reservation.getAmountPaid()+"<br>");
				date.add(Calendar.DAY_OF_MONTH, 7);
			}
		}

		out.print("<H2>Contents of Tables</H2>");

		out.print("<A HREF='DeleteAllRowsAllTables.jsp'>Delete All Rows in All Workbook Tables</A><br>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "AddressBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CruiseBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "CustomerBean_reservations_ReservationBean_customersTable";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>


</body>
</html>
