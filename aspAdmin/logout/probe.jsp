<%@ page buffer="100kb" %>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<% String
	uid  = request.getParameter("uid"),
	pwd  = request.getParameter("pwd"),
	jndi = request.getParameter("jndi");
	if (jndi == null || jndi.length() == 0) {
		jndi = request.getParameter("jndi2");
	}
	if (uid  != null && uid .length() == 0) uid  = null;
	if (pwd  != null && pwd .length() == 0) pwd  = null;
	if (jndi == null) jndi = "";
%>
<script type="text/javascript">
function goto(jndi) {
	form1.jndi.value="";
	form1.jndi2.value=jndi;
	form1.submit();
}
</script>
<form name="form1" method="get" action="">
<a href="probe.jsp">Probando</a> instalaci&oacute;n en el j2ee container
    <table border="0" cellspacing="0" cellpadding="2" style="border:solid 1px">
        <tr>
            <td valign="top">Usuario</td>
            <td valign="top"><input type="text" name="uid" <%if (uid != null){%> value="<%=uid%>" <% } %> ></td>
        </tr>
        <tr>
            <td valign="top">Contrase&ntilde;a</td>
            <td valign="top"><input type="text" name="pwd" <%if (pwd != null){%> value="<%=pwd%>" <% } %> ></td>
        </tr>
        <tr>
            <td valign="top">JNDI</td>
            <td valign="top">
			<select name="jndi" onChange="form1.jndi2.value=value">
			<%  String names[] = {"/", "jdbc", "jdbc/sdc", "SdcSeguridad/Afiliacion", "utilitarios/Mensajeria",
					"Correo/BuzonSalida", "utilitarios/CronService", "Workflow/Operations", "Monitor/Monitor"};
				boolean namefound = false;
				for (int i3 = 0; i3 < names.length; i3++) {
					%><option value="<%= names[i3] %>" <% if (names[i3].equals(jndi)) { 
						namefound = true;
						%> selected <%
					}%> ><%= names[i3] %></option><%
				}
				%>
				<option value="" <% if (!namefound) {%> selected <% } %> >Otro...</option>
			</select>
			
			<input type="text" name="jndi2" <%if (jndi != null && !namefound){%> value="<%=jndi%>" <% } 
			%>  onKeyUp="form1.jndi.value=value;" onChange="form1.jndi.value=value;"  ></td>
        </tr>
<%if (uid != null && pwd != null){%> 
        <tr>
            <td valign="top">Resultado</td>
            <td valign="top">
		<%
		try {
			java.util.Properties prop = new java.util.Properties();
			prop.put(javax.naming.Context.SECURITY_PRINCIPAL,   uid);
			prop.put(javax.naming.Context.SECURITY_CREDENTIALS, pwd);
			javax.naming.InitialContext initContext = new javax.naming.InitialContext(prop);
			Object ret = initContext.lookup(jndi);
			if (ret != null) {
				%>
					class: 
					<%  Class cls = ret.getClass();
						while (cls != null) {
							%> <%= cls.getName() %><%
							cls = cls.getSuperclass();
							if (cls != null) { %> extends <% }
						}
						Class[] intf = ret.getClass().getInterfaces();
						for (int i9 = 0; i9 <intf.length; i9++) {
							%> implements <%= intf[i9].getName() %><%
						}
					%><br>
					value: <%= ret.toString() %><br>
				<%
			} else {
				%>NULL<br><%
			}
			if (jndi.indexOf("/Afiliacion") != -1) {
				Object ejb = ret.getClass().getMethod("create",null).invoke(ret,null);
				String sess = (String) ejb.getClass().getMethod("autenticar", 
					new Class[]{String.class,String.class}).invoke(ejb,new Object[]{uid,pwd});
				if (sess != null && sess.length() > 1) {
					%>sesi&oacute;n iniciada<%
				} else {
					%>sesi&oacute;n inv&aacute;lida<%
				}
			} else if (ret instanceof javax.sql.DataSource) {
				java.sql.Connection conn = null;
				java.sql.Statement stmt = null;
				java.sql.ResultSet rs = null;
				try {
					conn = ((javax.sql.DataSource)ret).getConnection();
					stmt = conn.createStatement();
					rs = stmt.executeQuery(
						"select db_name() as dbname, suser_name() as lname, "+
						"user_name() as uname, @@servername as server");
					rs.next();
					%>
						conectado a <%=
							rs.getString("lname")%>@<%=
							rs.getString("server")%>.<%=
							rs.getString("dbname")%>.<%=
							rs.getString("uname")%>
					<%
					rs.close();
					stmt.close();
				} finally {
					if (rs   != null) rs  .close();
					if (stmt != null) stmt.close();
					if (conn != null) conn.close();
				}
			} else if (ret instanceof javax.naming.Context) {
				javax.naming.NamingEnumeration bindings = ((javax.naming.Context)ret).listBindings("");
				String bindThis = jndi;
				if (bindThis.length() == 0 || "/".equals(bindThis)) {
					bindThis = "";
				} else {
					bindThis = bindThis + "/";
				}
				%><%=jndi%><br><%
				while (bindings.hasMore()) {
					javax.naming.Binding bind = (javax.naming.Binding)bindings.next();
					%>&nbsp;&nbsp;<a href="#" onClick="javascript:goto('<%=bindThis+bind.getName()%>')"><%=bind.getName()%></a> ( <%=bind.getClassName()%> )<br><%
				}
				bindings.close();
			} else if (ret instanceof javax.ejb.EJBHome) {
				Object ejb = ret.getClass().getMethod("create", null).invoke(ret, null);
				%> EJBHome.create() = <%= ejb %> <%= ejb.getClass().getName() %> <%
				ejb.getClass().getMethod("remove", null).invoke(ejb, null);
			}
		} catch ( Throwable t ) { 
			%><font color="#FF0000"><%= t.toString() %></font><%
		} // try
		%>
		</td>
        </tr>
<%}%> 
        <tr valign="top">
            <td colspan="2"><input type="submit" name="j2ee" value="Probar"></td>
        </tr>
    </table>
</form>
</body>
</html>
