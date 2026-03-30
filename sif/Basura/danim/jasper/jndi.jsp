<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ page import="javax.naming.*" %>

<html>
<head>
<title>JRun jndi</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
.context {
	font-weight: bold;
	color: #FFFFFF;
	background-color: #999999;
}
.subcontext {
}
.contents {
	display:none;
	border: solid 1px black;
}
.binding {
}
-->
</style>
<script type="text/javascript">
	function contextClick(objid) {
		cnt = document.all["cnt"+objid];
		cnt.style.display=(cnt.style.display=="inline" ? "none" : "inline");
	}
</script>
</head>

<body>
HOLA<br>

<%!
	int objid = 0;
	public void printCtx(Context ctx, JspWriter out)
	throws Exception
	{
		String contextName = ctx.getNameInNamespace();
		if (contextName == null || contextName.length() == 0) {
			contextName = "/";
		}
		out.println("<table width=100% id=tbl" + (++objid) +" border=0 cellpadding=0 cellspacing=0>" +
			"<tr><td colspan=3 class='context' onclick='contextClick("+objid+");'>" +
			contextName + "</td></tr>");
		NamingEnumeration bindings = ctx.listBindings("");
		out.println("<tr><td colspan=3>" +
			"<table width=100% id=cnt" + objid +" class='contents' border=0 cellspacing=2 cellpadding=2>" +
			"<tr><td>");
		while (bindings.hasMore()) {
			Binding binding = (Binding)bindings.next();
			if (binding.getObject() instanceof Context) {
				out.println("<tr><td colspan=3 class='subcontext'>");
				printCtx((Context)binding.getObject(), out);
				out.println("</td></tr>");
			} else {
				out.println("<tr><td class='binding'>"  + binding.getName() +
							"</td><td>" + binding.getClassName() + 
							"</td><td>" + binding.getObject() + "</td></tr>");
			}
		}
		out.println("</td></tr></table></td></tr>");
		out.println("</table>");
		bindings.close();
	}
%>

<%
	javax.naming.Context ctx = new javax.naming.InitialContext();
	if (request.getParameter("ctx") != null) {
		Object obj = ctx.lookup(request.getParameter("ctx"));
		if (obj instanceof Context) {
			printCtx((Context)obj, out);
		} else {
			out.println("object: " + obj);
		}	
	} else {
		printCtx(ctx, out);
	}
%>
</body>
</html>
