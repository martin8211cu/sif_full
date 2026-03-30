<%@ page contentType="text/html; charset=iso-8859-1"
	language="java" import="java.sql.*" isErrorPage="true" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>


[<%=exception.getClass().getName()%>]<strong> <%= exception.getMessage() %></strong><hr><%
	%><xmp><% exception.printStackTrace(new java.io.PrintWriter(out)); %></xmp>
	
</body>
</html>
