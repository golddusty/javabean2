
<%@ page import="java.io.PrintWriter" %>

<%
	} catch (Throwable t) {
		t.printStackTrace();
		out.print(t.getMessage()+"<br>Stacktrace:<br>");
		t.printStackTrace(new PrintWriter(out,true));
	}
%>
