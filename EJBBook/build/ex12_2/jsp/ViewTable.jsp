<%@ page import="java.sql.*,java.util.HashMap" %>

<H2><%= table %></H2>

<%
    {  // control scope, allow multiple includes

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        boolean rowspresent = false;

        try {

           	Driver myDriver = (Driver) Class.forName("COM.cloudscape.core.RmiJdbcDriver").newInstance();
            conn = myDriver.connect("jdbc:cloudscape:rmi:TitanDB", null);

            stmt = conn.createStatement();

            rs = stmt.executeQuery("select * from "+"\""+table+"\"");

            if (rs != null)
            {
                ResultSetMetaData meta = rs.getMetaData();
                int count = meta.getColumnCount();
                out.println("Table name is :: "+table);
                out.println("cloumn count is :: "+count);
                while (rs.next())
                {
                    rowspresent = true;
                    String line="";
                    HashMap cols = new HashMap(count);
                    String columnLabel = null;
                    String idLabel ="id";
                    String idValue = "0";
                    for (int i=0; i<count; i++)
                    {
                        columnLabel = meta.getColumnLabel(i+1);
                        line += columnLabel + "=";
                        Object o = rs.getObject(i+1);
                        if ( "id".equalsIgnoreCase(columnLabel.trim()) )
                        {
                            idLabel = columnLabel;
                            if ( o != null )
                            {
                                idValue = o.toString();
                            }
                            else
                            {
                                idValue = new String("0");
                            }
                        }
                        if (rs.wasNull()) {
                            line += "NULL  ";
                        } else {
                            line += o.toString()+"  ";
                        }
                    }
                    String deletelink = "DeleteOneRow.jsp?table="+table
                            +"&col1="+idLabel+"&col1value="+idValue;
                    if ( deletelink != null )
                    {
                        out.println(" string not null for delete link creation");
                    }
                    if (table.indexOf("_") != -1) {
                        // link table, need both columns..
                        String col2 = meta.getColumnLabel(2);
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
