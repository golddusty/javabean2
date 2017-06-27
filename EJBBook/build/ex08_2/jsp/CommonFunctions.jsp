<%@ page import="javax.naming.*" %>

<%!

    static public Context getInitialContext() throws Exception {
      // We are in the same WebLogic JVM, so we don't need properties..
      return new InitialContext();
    }

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

