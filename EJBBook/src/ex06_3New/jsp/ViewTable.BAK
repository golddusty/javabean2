<%@ page import="javax.sql.*,java.util.*" %>

<H2><%= table %></H2>

<%
{  // control scope, allow multiple includes

	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	boolean rowspresent = false;
	String jdbcClass = "COM.cloudscape.core.RmiJdbcDriver";
	String jdbcURL	 = "jdbc:cloudscape:rmi:TitanDB";
	String user		 = "scott";
	String password	 = "tiger";

	try {

		InitialContext aContext = new InitialContext();
		javax.sql.DataSource aDatasource = (javax.sql.DataSource)aContext.lookup("jdbc/Titan");
		//	Driver myDriver = (Driver) Class.forName(jdbcClass).newInstance();
	//	Properties aProperties = new Properties();
	//	aProperties.put("user", user);
	//	aProperties.put("password",password);
		
	//	conn = myDriver.connect(jdbcURL,aProperties);
		conn = aDatasource.getConnection();
		out.println("Obtained a database connection to Cloudscape");
		
		stmt = conn.createStatement();
		rs = stmt.executeQuery("select * from "+"\""+table+"\"");

		if (rs != null)  {
        	ResultSetMetaData meta = rs.getMetaData();
        	int count = meta.getColumnCount();
        	while (rs.next()) {
				rowspresent = true;
				String line="";
            	HashMap cols = new HashMap(count);
            	for (int i=0; i<count; i++) {
					line += meta.getColumnLabel(i+1).toUpperCase() + "=";
                	Object o = rs.getObject(i+1);
                	if (rs.wasNull()) {
						line += "NULL  ";
                	} else {
                		line += o.toString()+"  ";
                	}
            	}
				String col1 = meta.getColumnLabel(1).toUpperCase();
				String deletelink = "DeleteOneRow.jsp?table="+table
						+"&col1="+col1+"&col1value="+rs.getObject(1).toString();
				if (table.indexOf("_LINK") != -1) {
					// link table, need both columns..
					String col2 = meta.getColumnLabel(2).toUpperCase();
					deletelink += "&col2="+col2+"&col2value="+rs.getObject(2).toString();
				}

				out.print(line+" <A HREF='"+deletelink+"'>Delete Row</A><br>");

        	}
        }

		stmt.close();
		conn.close();

		if (rowspresent) {
			out.print("<br><A HREF='DeleteAllRows.jsp?table="+table+"'>Delete all rows in "+table+" table</A><br>");
		} else {
			out.print("Empty Table<br>");
		}
	} catch (Exception e) {
	    System.out.println(e.getMessage());
		out.print("Error reading table, may not be present yet.<br>");
		stmt.close();
		conn.close();
	}

}
%>
