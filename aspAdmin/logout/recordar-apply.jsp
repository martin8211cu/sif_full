<%@ page contentType="text/html; charset=iso-8859-1"
	language="java" import="javax.naming.*,com.soin.utilitarios.*,com.soin.sdc.seguridad.*,java.util.*,java.math.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://soin.co.cr/taglibs/sdc-1.0" prefix="sdc" %>
<%--
login: <c:out value="${param.login}" /><br>
respuesta: <c:out value="${param.respuesta}" /><br>
--%>
<c:if test="${empty param.login}">
	<c:redirect url="recordar.jsp">
		<c:param name="error" value="Digite el usuario" />
	</c:redirect>
</c:if>

<sql:query dataSource="jdbc/sdc" var="data">
	select Usucodigo, Ulocalizacion,
	  Usupregunta as pregunta, Usurespuesta as respuesta,
	  Usueplogin
	from Usuario
	where Usulogin = ? <sql:param value="${param.login}" />
	  and Usutemporal = 0
</sql:query>

data:<c:out value="${data}" />
<% if (true) return; %>

<c:set value="${data.rows[0]}" var="row" />

<c:if test="${(empty row.respuesta) or (empty row.pregunta) or (row.respuesta == ' ') or (row.pregunta == ' ')}">
	<c:redirect url="recordar-imposible.jsp">
		<c:param name="login" value="${param.login}" />
	</c:redirect>
</c:if>

<c:if test="${empty param.respuesta}">
	<c:redirect url="recordar.jsp" >
		<c:param name="login" value="${param.login}" />
		<c:param name="pregunta" value="${row.pregunta}" />
	</c:redirect>
</c:if>

<c:if test="${param.respuesta != row.respuesta}">
	<%-- Esperar diez segundos entre cada intento de respuesta --%>
	<% Thread.sleep(10000); %>
	<c:if test="${param.retry gt 1}">
		<c:redirect url="." />
	</c:if>
	<c:redirect url="recordar.jsp">
		<c:param name="login" value="${param.login}" />
		<c:param name="pregunta" value="${row.pregunta}" />
		<c:param name="retry" value="${param.retry + 1}"/>
		<c:param name="error" value="La respuesta no coincide con nuestros registros." />
	</c:redirect>
</c:if>

<c:if test="${param.respuesta == row.respuesta}"> 
	<%-- Enviar contrasena nueva --%>
	<%! Mensajeria msg = null; Afiliacion afilia = null;
		String randomPassword() {
			String chars = "abcdefghijkmnopqrstuvwxyz23456789";
			StringBuffer sb = new StringBuffer(6);
			for (int i = 0; i < 6; i++) {
				sb.append (chars.charAt ((int)Math.floor(Math.random() * chars.length())));
			}
			return sb.toString();
		}
	%>
	<%	
		Context ctx1 = new InitialContext();
		String adminuser = ctx1.lookup("java:comp/env/adminuser").toString();
		String adminpass = ctx1.lookup("java:comp/env/adminpass").toString();
		Properties p = new Properties();
		p.put(Context.SECURITY_PRINCIPAL, adminuser);
		p.put(Context.SECURITY_CREDENTIALS, adminpass);
		Context ctx = new InitialContext(p);
		MensajeriaHome h1 = (MensajeriaHome) javax.rmi.PortableRemoteObject.narrow(
			ctx.lookup("utilitarios/Mensajeria"), MensajeriaHome.class);
		msg = h1.create();
		javax.ejb.EJBHome home = (javax.ejb.EJBHome) javax.rmi.PortableRemoteObject.narrow(
				ctx.lookup("java:comp/env/ejb/Afiliacion"),
				javax.ejb.EJBHome.class);
		com.soin.sdc.seguridad.Afiliacion afilia = (com.soin.sdc.seguridad.Afiliacion)
			home.getClass().getMethod("create",null).invoke(home,null);
	%>
	
	
	<sql:query dataSource="jdbc/sdc" var="x">
		insert UsuarioBitacora (Usucodigo, Ulocalizacion, UBtipo, UBumod, UBfmod, UBdata)
		values (
			? <sql:param value="${row.Usucodigo}"/>,
			? <sql:param value="${row.Ulocalizacion}"/>,
			'cambioPassword', 'recordar password', getdate(), 'recordar')
	</sql:query>
	
	<jsp:useBean id="row" type="java.util.Hashtable" />
	<%
		String newPassword = randomPassword();
        afilia.cambiaPassword(row.get("Usueplogin").toString(), newPassword);
		msg.MensajeCorreo(
			(BigDecimal) row.get("Usucodigo"), row.get("Ulocalizacion").toString(),
			"Clave de acceso, migestion.net",
			"Usted ha solicitado una nueva clave de acceso para el portal. " +
			"La nueva clave es " + newPassword +
			". Debe utilizarla en minusculas, no utilice letras mayusculas al ingresarla."
			);
		// out.print("Enviado a " + row + "; " + newPassword);
    %>
	<c:redirect url="recordar-fin.jsp" /> 
</c:if>