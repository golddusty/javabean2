
<%@ page import="com.titan.cruise.*,com.titan.ship.*,com.titan.customer.*,com.titan.reservation.*,com.titan.cabin.*,
                 java.util.Calendar,
                 java.util.Iterator,
                 java.util.Set,
                 java.util.HashSet" %>
<%@ page import="java.text.*,javax.naming.*,javax.transaction.*,javax.rmi.*" %>

<% response.addHeader("Cache-Control", "no-cache, must-revalidate"); %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_77d Example Showing Cabin/Reservation Relationships";
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

		ShipLocal shipA = shiphome.create(new Integer(1), "Ship A", 30000.0); 
		CruiseLocal cruiseA = cruisehome.create("Cruise A", shipA); 

		out.print("cruise.getName()="+cruiseA.getName()+"<br>");
		out.print("ship.getName()="+shipA.getName()+"<br>");
		out.print("cruise.getShip().getName()="+cruiseA.getShip().getName()+"<br>");

		out.print("<H2>Creating Cabins </H2>");
		CabinLocal cabins[] = new CabinLocal[4];
		cabins[1] = cabinhome.create(new Integer(1));
		//cabins[1].setShip(shipA);
		cabins[1].setDeckLevel(1);
		cabins[1].setName("Minnesota Suite");
		cabins[1].setBedCount(2);

		cabins[2] = cabinhome.create(new Integer(2));
		//cabins[2].setShip(shipA);
		cabins[2].setDeckLevel(2);
		cabins[2].setName("California Suite");
		cabins[2].setBedCount(2);

		cabins[3] = cabinhome.create(new Integer(3));
		//cabins[3].setShip(shipA);
		cabins[3].setDeckLevel(3);
		cabins[3].setName("Missouri Suite");
		cabins[3].setBedCount(2);

		for (int jj=1; jj<4; jj++) {
			CabinLocal cc = cabins[jj];
			out.print(cc.getName()+"<br>");
		}

		out.print("<H2>Creating Reservations</H2>");

		// Create some Reservation beans - automatic key generation by CMP engine
		// Link 1-3 to Cruise A, 4-6 to Cruise B
		ReservationLocal reservations[] = new ReservationLocal[3];
		Calendar date = Calendar.getInstance();
		date.set(2002,10,1);

		reservations[1] = reservationhome.create(cruiseA, null);
		reservations[1].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[1].setAmountPaid(4000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		reservations[2] = reservationhome.create(cruiseA, null);
		reservations[2].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[2].setAmountPaid(5000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		DateFormat df = new SimpleDateFormat("MM/dd/yyyy");
		UserTransaction tran =
				(UserTransaction)jndiContext.lookup("java:comp/UserTransaction");

		// report information on the reservations
		for (int jj=1; jj<3; jj++) {
			ReservationLocal rr = reservations[jj];
			CruiseLocal thiscruise = rr.getCruise();
			String cruisename = (thiscruise!=null ? thiscruise.getName() : "No Cruise!");
			// Operations such as this must be done in a transaction, usually done within a
			// stateless session EJB using declarative transactions rather than manually like this
			String cabininfo = "";
			try {
				tran.begin();
				Set cabinset = rr.getCabins();
				Iterator iterator = cabinset.iterator();
				while(iterator.hasNext()){
					CabinLocal cabin = (CabinLocal)iterator.next();
					cabininfo += cabin.getName()+" ";
				}
				tran.commit();
			}
			catch (Exception e) {
				e.printStackTrace();
				tran.rollback();
			}
			out.print("Reservation date="+df.format(rr.getDate())
						+" amount paid= "+rr.getAmountPaid()
						+" is for "+cruisename+" with cabininfo "+cabininfo+"<br>");
		}

		out.print("<H2>Creating Links from Reservations to Cabins</H2>");

		Set cabins1 = new HashSet(2);
		cabins1.add(cabins[1]);
		cabins1.add(cabins[2]);
		Set cabins2 = new HashSet(2);
		cabins2.add(cabins[2]);
		cabins2.add(cabins[3]);

		reservations[1].setCabins(cabins1);
		reservations[2].setCabins(cabins2);

		// report information on the reservations
		for (int jj=1; jj<3; jj++) {
			ReservationLocal rr = reservations[jj];
			CruiseLocal thiscruise = rr.getCruise();
			String cruisename = (thiscruise!=null ? thiscruise.getName() : "No Cruise!");
			// Operations such as this must be done in a transaction, usually done within a
			// stateless session EJB using declarative transactions rather than manually like this
			String cabininfo = "";
			try {
				tran.begin();
				Set cabinset = rr.getCabins();
				Iterator iterator = cabinset.iterator();
				while(iterator.hasNext()){
					CabinLocal cabin = (CabinLocal)iterator.next();
					cabininfo += cabin.getName()+" ";
				}
				tran.commit();
			}
			catch (Exception e) {
				e.printStackTrace();
				tran.rollback();
			}
			out.print("Reservation date="+df.format(rr.getDate())
						+" amount paid= "+rr.getAmountPaid()
						+" is for "+cruisename+" with cabininfo "+cabininfo+"<br>");
		}

		out.print("<H2>Testing reservation_b.setCabins(reservation_a.getCabins())</H2>");

		// Operations such as this must be done in a transaction, usually done within a
		// stateless session EJB using declarative transactions rather than manually like this
		try {
			tran.begin();
			Set cabins_a = reservations[1].getCabins();
			reservations[2].setCabins(cabins_a);
			tran.commit();
		}
		catch (Exception e) {
			e.printStackTrace();
			tran.rollback();
		}

		// report information on the reservations
		for (int jj=1; jj<3; jj++) {
			ReservationLocal rr = reservations[jj];
			CruiseLocal thiscruise = rr.getCruise();
			String cruisename = (thiscruise!=null ? thiscruise.getName() : "No Cruise!");
			// Operations such as this must be done in a transaction, usually done within a
			// stateless session EJB using declarative transactions rather than manually like this
			String cabininfo = "";
			try {
				tran.begin();
				Set cabinset = rr.getCabins();
				Iterator iterator = cabinset.iterator();
				while(iterator.hasNext()){
					CabinLocal cabin = (CabinLocal)iterator.next();
					cabininfo += cabin.getName()+" ";
				}
				tran.commit();
			}
			catch (Exception e) {
				e.printStackTrace();
				tran.rollback();
			}
			out.print("Reservation date="+df.format(rr.getDate())
						+" amount paid= "+rr.getAmountPaid()
						+" is for "+cruisename+" with cabininfo "+cabininfo+"<br>");
		}

		out.print("<H2>Contents of Tables</H2>");

		out.print("<A HREF='DeleteAllRowsAllTables.jsp'>Delete All Rows in All Workbook Tables</A><br>");

		String table = "CabinBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBean_reservations_CabinBean_Table";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
