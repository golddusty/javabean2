
<%@ page import="com.titan.cruise.*,com.titan.ship.*,com.titan.reservation.*,
                 java.util.Calendar,java.sql.Date,
                 java.util.Collection,
                 javax.transaction.UserTransaction" %>
<%@ page import="java.text.*" %>
<%@ page import="javax.naming.*,javax.rmi.PortableRemoteObject,java.rmi.RemoteException" %>

<% response.addHeader("Cache-Control", "no-cache, must-revalidate"); %>

<%@ include file="CommonFunctions.jsp" %>

<%!
  final String title = "Client_76 Example Showing Cruise/Reservation Relationship Using set() (Fig 7-16)";
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
		// obtain CruiseHome
		Context jndiContext = getInitialContext();
		Object obj = jndiContext.lookup("java:comp/env/CruiseHomeLocal");
		CruiseHomeLocal cruisehome = (CruiseHomeLocal)obj;

		out.print("<H2>Creating Cruises</H2>");

		// Create some Cruise beans - leave ship reference empty since we don't care
		CruiseLocal cruiseA = cruisehome.create("Cruise A", null); 
		CruiseLocal cruiseB = cruisehome.create("Cruise B", null);
        Integer cruiseAID = (Integer)cruiseA.getPrimaryKey();
        Integer cruiseBID = (Integer)cruiseB.getPrimaryKey();

		out.print("name="+cruiseA.getName()+"<br>");
		out.print("name="+cruiseB.getName()+"<br>");

		out.print("<H2>Creating Reservations</H2>");

		// Create some Reservation beans - automatic key generation by CMP engine
		// Link 1-3 to Cruise A, 4-6 to Cruise B
		obj = jndiContext.lookup("java:comp/env/ReservationHomeLocal");
		ReservationHomeLocal reservationhome = (ReservationHomeLocal)obj; 
		ReservationLocal reservations[] = new ReservationLocal[7];
		Calendar date = Calendar.getInstance();
		date.set(2002,10,1);
        java.sql.Date aDate = new java.sql.Date(date.getTime().getTime());

		// Leave the Customers collection null in the create() call, we don't care about it right now

		reservations[1] = reservationhome.create(cruiseA,null);
		reservations[1].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[1].setAmountPaid(4000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		reservations[2] = reservationhome.create(cruiseA,null);
		reservations[2].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[2].setAmountPaid(5000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		reservations[3] = reservationhome.create(cruiseA,null);
		reservations[3].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[3].setAmountPaid(6000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		reservations[4] = reservationhome.create(cruiseB,null);
		reservations[4].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[4].setAmountPaid(7000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		reservations[5] = reservationhome.create(cruiseB,null);
		reservations[5].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[5].setAmountPaid(8000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		reservations[6] = reservationhome.create(cruiseB,null);
		reservations[6].setDate(new java.sql.Date(date.getTime().getTime()));
		reservations[6].setAmountPaid(9000.0);
		date.add(Calendar.DAY_OF_MONTH, 7);

		DateFormat df = new SimpleDateFormat("MM/dd/yyyy");

		// Report information on the 6 reservations 

		for (int jj=1; jj<7; jj++) {
			ReservationLocal rr = reservations[jj];
			CruiseLocal thiscruise = rr.getCruise();
			String cruisename = (thiscruise!=null ? thiscruise.getName() : "No Cruise!");
			out.print("Reservation date="+df.format(rr.getDate())
						+" amount paid= "+rr.getAmountPaid()
						+" is for "+cruisename+"<br>");
		}

		out.print("<H2>Testing CruiseB.setReservations( CruiseA.getReservations() )</H2>");
        UserTransaction tran = (UserTransaction)jndiContext.lookup("java:comp/UserTransaction");
        try
        {
            tran.begin();
            // show the effect of a simple "setReservations" on a cruise
            //cruiseA = cruisehome.findByPrimaryKey(cruiseAID);
            Collection a_reservations = cruiseA.getReservations();
           // cruiseB = cruisehome.findByPrimaryKey(cruiseBID);
            cruiseB.setReservations(a_reservations );
            tran.commit();
			}
			catch (Exception e) {
				e.printStackTrace();
				tran.rollback();
			}
            // Report information on the 6 reservations

            for (int jj=1; jj<7; jj++) {
                ReservationLocal rr = reservations[jj];
                CruiseLocal thiscruise = rr.getCruise();
                String cruisename = (thiscruise!=null ? thiscruise.getName() : "No Cruise!");
                out.print("Reservation date="+df.format(rr.getDate())
                            +" amount paid= "+rr.getAmountPaid()
                            +" is for "+cruisename+"<br>");
            }


		out.print("<H2>Contents of Tables</H2>");

		out.print("<A HREF='DeleteAllRowsAllTables.jsp'>Delete All Rows in All Workbook Tables</A><br>");

		String table = "CruiseBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		

		table = "ReservationBeanTable";
		%><%@ include file="ViewTable.jsp" %><%		


%>

<%@ include file="CatchBlocks.jsp" %>

</body>
</html>
