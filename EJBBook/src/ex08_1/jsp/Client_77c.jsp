
<%@ page import="com.titan.cruise.*,com.titan.ship.*,com.titan.customer.*,com.titan.reservation.*,com.titan.cabin.*,
                 java.util.Calendar,
                 java.util.Set,
                 java.util.HashSet,
                 java.util.Iterator" %>
<%@ page import="java.text.*,javax.naming.*,javax.transaction.*,javax.rmi.*" %>
<%@ page import="com.titan.customer.Name" %>

<% response.addHeader("Cache-Control", "no-cache, must-revalidate"); %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_77c Example Showing Reservation/Cabin Relationships (Fig 7-20)";
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

		ShipLocal shipA = shiphome.create(new Integer(10773), "Ship A", 30000.0); 
		CruiseLocal cruiseA = cruisehome.create("Cruise A", shipA); 

		out.print("cruise.getName()="+cruiseA.getName()+"<br>");
		out.print("ship.getName()="+shipA.getName()+"<br>");
		out.print("cruise.getShip().getName()="+cruiseA.getShip().getName()+"<br>");

		out.print("<H2>Creating Cabins 1-6</H2>");

		// create four sets of cabins, 1-3, 2-4, 3-5, 4-6
		Set cabins13 = new HashSet();
		Set cabins24 = new HashSet();
		Set cabins35 = new HashSet();
		Set cabins46 = new HashSet();
		for (int kk=1; kk<7; kk++) {
			CabinLocal cabin = cabinhome.create(new Integer(kk));
			cabin.setName("Cabin "+kk);
			if (kk<=3)          { cabins13.add(cabin); }
			if (kk>=2 && kk<=4) { cabins24.add(cabin); }
			if (kk>=3 && kk<=5) { cabins35.add(cabin); }
			if (kk>=4)          { cabins46.add(cabin); }
			out.print(cabin.getName()+"<br>");
		}
		
		out.print("<H2>Creating Reservations 1-4 using three cabins each</H2>");

		// Create some Reservation beans - automatic key generation by CMP engine
		// Link 1 to cabins 1-3, link 2 to cabins 2-4, etc..

		ReservationLocal reservations[] = new ReservationLocal[5];
		Calendar date = Calendar.getInstance();
		date.set(2002,10,1);

		// leave Customers collection null, we dont care about it for this example

		reservations[1] = reservationhome.create(cruiseA, null);
		reservations[1].setCabins(cabins13);
		reservations[1].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[1].setAmountPaid(4000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		reservations[2] = reservationhome.create(cruiseA, null);
		reservations[2].setCabins(cabins24);
		reservations[2].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[2].setAmountPaid(5000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		reservations[3] = reservationhome.create(cruiseA, null);
		reservations[3].setCabins(cabins35);
		reservations[3].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[3].setAmountPaid(6000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		reservations[4] = reservationhome.create(cruiseA, null);
		reservations[4].setCabins(cabins46);
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
						+" is for "+cruisename+" with cabins "+cabininfo+"<br>");
		}

		out.print("<H2>Performing cabins_a collection iterator.remove() test</H2>");

		// Finally we can perform the test shown in Figure 7-22

		// Operations such as this must be done in a transaction, usually done within a
		// stateless session EJB using declarative transactions rather than manually like this
		try {
			tran.begin();
			Set cabins_a = reservations[1].getCabins();
			Iterator iterator = cabins_a.iterator();
			while (iterator.hasNext()) {
				CabinLocal cc = (CabinLocal)iterator.next();
				System.out.println("Removing "+cc.getName()+" from cabins_a");
				out.print("Removing "+cc.getName()+" from cabins_a"+"<br>");
				iterator.remove();
			}
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
						+" is for "+cruisename+" with cabins "+cabininfo+"<br>");
		}

		out.print("<H2>Contents of Tables</H2>");

		out.print("<A HREF='DeleteAllRowsAllTables.jsp'>Delete All Rows in All Workbook Tables</A><br>");

		String table = "CabinBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBean_cabins_CabinBean_Table";
		%><%@ include file="ViewTable.jsp" %><%		

%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
