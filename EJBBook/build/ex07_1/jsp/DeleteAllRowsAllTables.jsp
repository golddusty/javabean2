
<%@ page import="java.sql.*,
                 java.util.ArrayList" %>

<%!

private void redirect(HttpServletResponse pResponse, String pLocation)
	throws java.io.IOException
{
    pResponse.sendRedirect(pLocation);
    pResponse.flushBuffer();
    return;
}

%>

<%

	// build the list of tables to attempt to delete, try to get them in the right child/parent order for FK constraints
	ArrayList tables = new ArrayList();
	tables.add("RESERVATION_CUSTOMER_LINK");
	tables.add("RESERVATION_CABIN_LINK");
	tables.add("CABIN");
	tables.add("RESERVATION");
	tables.add("CRUISE");
	tables.add("SHIP");
	tables.add("PhoneBeanTable");
	tables.add("CreditCardBeanTable");
	tables.add("CustomerBeanTable");
	tables.add("AddressBeanTable");

	Connection conn = null;

	try {

		Driver myDriver = (Driver) Class.forName("COM.cloudscape.core.RmiJdbcDriver").newInstance();
		conn = myDriver.connect("jdbc:cloudscape:rmi:TitanDB", null);
		
		Statement stmt = conn.createStatement();
		for (int kk=0; kk<tables.size(); kk++) {
			String table = (String)(tables.get(kk));
			String ss = "delete from "+table;
			System.out.println("Executing statement: "+ss);
			try {
				int rows = stmt.executeUpdate(ss);
				System.out.println("Row Count: "+rows);	
			}
			catch (Exception e) {
				System.out.println("Error executing delete, table "+table+" might be missing..");
				System.out.println(e.getMessage());
				System.out.println("If it is a foreign key problem, try repeating this page a few times until everything goes..");
			}
		}

		stmt.close();
		conn.close();

		redirect(response,"ViewDB.jsp");

	} catch(Throwable t) {
		t.printStackTrace();
		out.print("<html><body>"+t.getMessage()+"</body></html>");	
		conn.close();
	}

%>
