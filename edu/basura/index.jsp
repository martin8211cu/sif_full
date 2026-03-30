<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*, javax.naming.*, com.soin.utilitarios.db.*" errorPage="" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/xml" prefix="x" %>
<%@ taglib uri="http://soin.co.cr/taglibs/sdc-1.0" prefix="sdc" %>

<%-- Este include del common es sumamente importante para los usuarios que entran por primera vez al portal --%>
<jsp:include page="/h/common.jsp" />
<c:if test="${logoninfo.Usutemporal}">
	<c:redirect url="/sdc/cfg/cfg/signup.jsp" />
</c:if>

<html><!-- InstanceBegin template="/Templates/principal.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<!-- Generado: <%= (new java.util.Date()) %> -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>MiGestion</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta http-equiv='Expires' content='Fri, Jan 01 1970 08:20:00 GMT' />
<meta http-equiv='Pragma' content='no-cache' />
<meta http-equiv='Cache-Control' content='no-cache, no-store, must-revalidate' />
<link   href="/util/css/todo.css" rel="stylesheet" type="text/css"/>
<script src="/util/js/todo.js" type="text/JavaScript" language="JavaScript">//Menus</script>
<!-- InstanceBeginEditable name="head" --> 
<!-- InstanceEndEditable -->
</head>
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <!--DWLayoutTable-->
  <tr> 
    <td width="154" rowspan="2" align="center" valign="middle"><img src="/util/images/menu/logo2.gif" width="154" height="62"></td>
    <td width="100%" valign="top" style="padding-left: 5; padding-bottom: 5;"> 
      <jsp:include page="/sdc/p/ubica.jsp" /> </td>
  </tr>
  <tr> 
    <td valign="top"><!-- InstanceBeginEditable name="Encabezado" --> 
      <div align="right">[ &copy; migestion.net 1999-2002 ] </div>
      <!-- InstanceEndEditable --></td>
  </tr>
  <tr> 
    <td colspan="2" valign="top"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <!--DWLayoutTable-->
        <tr> 
          <td width="90" align="center" valign="top" nowrap>
		    <jsp:include page="/sdc/p/menu.jsp" />   
		  </td>
          <td width="100%" valign="top" style="padding-left: 5;"> <!-- InstanceBeginEditable name="Contenido" --> 
			<jsp:include page="contents.jsp"/>
			 <!-- InstanceEndEditable --> 
          </td>
        </tr>
      </table></td>
  </tr>
</table>

</body><%@ include file="/h/monitoreo.jsp" %>
<!-- InstanceEnd --></html>
