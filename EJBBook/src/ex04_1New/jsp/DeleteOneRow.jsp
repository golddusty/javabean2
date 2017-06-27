
<%@ page import="java.sql.*,java.util.*" %>

<%!
private String getr(HttpServletRequest pRequest, String pParamName) {
	String[] results = pRequest.getParameterValues(pParamName);
	String result = "";
    if (results == null || results.length == 0) {
		// leave result as empty string..
	} else if (results.length == 1) {
		result = results[0];
	} else if (results.length > 1) {
		for (int ii=0; ii<results.length; ii++) {
			result += results[ii];
			if (ii<results.length) result += " ";  // space delimit multiple values
		}
	}
    return result;
}

private void redirect(HttpServletResponse pResponse, String pLocation)
	throws java.io.IOException
{
    pResponse.sendRedirect(pLocation);
    pResponse.flushBuffer();
    return;
}

%>

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
		String ss = "delete from "+table+" where "+col1+"="+col1value;
		if (!col2.equals("")) {
			ss += " and "+col2+"="+col2value;
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
