
<%@ page import="com.titan.cruise.*,com.titan.ship.*,com.titan.customer.*,com.titan.reservation.*, com.titan.cabin.*,
                 java.util.Calendar,
                 java.util.HashSet,
                 java.util.Set,
                 java.util.Iterator" %>
<%@ page import="java.text.*,javax.naming.*,javax.transaction.*,javax.rmi.*" %>
<%@ page import="com.titan.customer.Name" %>

<% response.addHeader("Cache-Control", "no-cache, must-revalidate"); %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_77b Example Showing Reservation/Customer Relationships (Fig 7-18)";
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

		out.print("<H2>Creating a Ship and Cruise</H2>");

		ShipLocal shipA = shiphome.create(new Integer(10772), "Ship A", 30000.0); 
		CruiseLocal cruiseA = cruisehome.create("Cruise A", shipA); 

		out.print("cruise.getName()="+cruiseA.getName()+"<br>");
		out.print("ship.getName()="+shipA.getName()+"<br>");
		out.print("cruise.getShip().getName()="+cruiseA.getShip().getName()+"<br>");

		out.print("<H2>Creating Customers 1-6</H2>");

		// create four sets of customers, 1-3, 2-4, 3-5, 4-6
		Set customers13 = new HashSet();
		Set customers24 = new HashSet();
		Set customers35 = new HashSet();
		Set customers46 = new HashSet();
		for (int kk=1; kk<7; kk++) {
			CustomerLocal cust = customerhome.create(new Integer(kk));
			cust.setName(new Name("Customer "+kk,""));
			if (kk<=3)          { customers13.add(cust); }
			if (kk>=2 && kk<=4) { customers24.add(cust); }
			if (kk>=3 && kk<=5) { customers35.add(cust); }
			if (kk>=4)          { customers46.add(cust); }
			out.print(cust.getName().getLastName()+"<br>");
		}
		
		out.print("<H2>Creating Reservations 1-4 using three customers each</H2>");

		// Create some Reservation beans - automatic key generation by CMP engine
		// Link 1 to customers 1-3, link 2 to customers 2-4, etc..

		ReservationLocal reservations[] = new ReservationLocal[5];
		Calendar date = Calendar.getInstance();
		date.set(2002,10,1);

		reservations[1] = reservationhome.create(cruiseA, customers13);
		reservations[1].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[1].setAmountPaid(4000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		reservations[2] = reservationhome.create(cruiseA, customers24);
		reservations[2].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[2].setAmountPaid(5000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		reservations[3] = reservationhome.create(cruiseA, customers35);
		reservations[3].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[3].setAmountPaid(6000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		reservations[4] = reservationhome.create(cruiseA, customers46);
		reservations[4].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[4].setAmountPaid(7000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		DateFormat df = new SimpleDateFormat("MM/dd/yyyy");

		UserTransaction tran = (UserTransaction)jndiContext.lookup("java:comp/UserTransaction");

		// report information on the reservations
		for (int jj=1; jj<5; jj++) {
			ReservationLocal rr = reservations[jj];
			CruiseLocal thiscruise = rr.getCruise();
			String cruisename = (thiscruise!=null ? thiscruise.getName() : "No Cruise!");
			// Operations such as this must be done in a transaction, usually done within a
			// stateless session EJB using declarative transactions rather than manually like this
			String customerinfo = "";
			try {
				tran.begin();
				Set customerset = rr.getCustomers();
				Iterator iterator = customerset.iterator();
				while(iterator.hasNext()){
					CustomerLocal cust = (CustomerLocal)iterator.next();
					customerinfo += cust.getName().getLastName()+" ";
				}
				tran.commit();
			}
			catch (Exception e) {
				e.printStackTrace();
				tran.rollback();
			}
			out.print("Reservation date="+df.format(rr.getDate())
						+" amount paid= "+rr.getAmountPaid()
						+" is for "+cruisename+" with customers "+customerinfo+"<br>");
		}

		out.print("<H2>Performing reservationD.setCustomers(customersA) test</H2>");

		// Finally we can perform the test shown in Figure 7-20

		// Operations such as this must be done in a transaction, usually done within a
		// stateless session EJB using declarative transactions rather than manually like this
		try {
			tran.begin();
			Set customers_a = reservations[1].getCustomers();
			reservations[4].setCustomers(customers_a);
			tran.commit();
		}
		catch (Exception e) {
			e.printStackTrace();
			tran.rollback();
		}

		// report information on the reservations
		for (int jj=1; jj<5; jj++) {
			ReservationLocal rr = reservations[jj];
			CruiseLocal thiscruise = rr.getCruise();
			String cruisename = (thiscruise!=null ? thiscruise.getName() : "No Cruise!");
			// Operations such as this must be done in a transaction, usually done within a
			// stateless session EJB using declarative transactions rather than manually like this
			String customerinfo = "";
			try {
				tran.begin();
				Set customerset = rr.getCustomers();
				Iterator iterator = customerset.iterator();
				while(iterator.hasNext()){
					CustomerLocal cust = (CustomerLocal)iterator.next();
					customerinfo += cust.getName().getLastName()+" ";
				}
				tran.commit();
			}
			catch (Exception e) {
				e.printStackTrace();
				tran.rollback();
			}
			out.print("Reservation date="+df.format(rr.getDate())
						+" amount paid= "+rr.getAmountPaid()
						+" is for "+cruisename+" with customers "+customerinfo+"<br>");
		}

		out.print("<H2>Contents of Tables</H2>");

		out.print("<A HREF='DeleteAllRowsAllTables.jsp'>Delete All Rows in All Workbook Tables</A><br>");

		String table = "CustomerBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBean_reservations_CustomerBean_Table";
		%><%@ include file="ViewTable.jsp" %><%		


%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
