
<%@ page import="java.sql.*" %>

<%@ include file="CommonFunctions.jsp" %>

<%
    Connection conn = null;
	try {

		Driver myDriver = (Driver) Class.forName("COM.cloudscape.core.RmiJdbcDriver").newInstance();
		conn = myDriver.connect("jdbc:cloudscape:rmi:TitanDB", null);

		String table = getr(request,"table");
		String col1 = getr(request,"col1");
		String col2 = getr(request,"col2");
		String col1value = getr(request,"col1value");
		String col2value = getr(request,"col2value");

		Statement stmt = conn.createStatement();
		String ss = "delete from "+"\""+table+"\""+" where "+"\""+col1+"\""+"="+col1value;
		if (!col2.equals("")) {
			ss += " and "+"\""+col2+"\""+"="+col2value;
		}

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
