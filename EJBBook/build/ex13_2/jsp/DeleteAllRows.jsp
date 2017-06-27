<%@ page import="java.sql.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%
    Connection conn = null;
	try {

		Driver myDriver = (Driver) Class.forName("COM.cloudscape.core.RmiJdbcDriver").newInstance();
		conn = myDriver.connect("jdbc:cloudscape:rmi:TitanDB", null);

		String table = getr(request,"table");

		Statement stmt = conn.createStatement();
		String ss = "delete from "+"\""+table+"\"";

		System.out.println("Executing statement: "+ss);
		int rows = stmt.executeUpdate(ss);
		System.out.println("Row Count: "+rows);

		stmt.close();
		conn.close();

		redirect(response,"ViewDB.jsp");

	} catch(Throwable t) {
		t.printStackTrace();
		out.print("<html><body>"+t.getMessage()+"</body></html>");
		conn.close();
	}

%>
