<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<!-- TemplateBeginEditable name="doctitle" -->
<title>Saulasso's</title>
<!-- TemplateEndEditable --><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfinclude template="../tienda/public/estilo.cfm">
<!-- TemplateBeginEditable name="head" --><!-- TemplateEndEditable -->
</head>

<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <!--DWLayoutTable-->
  <tr>
    <td colspan="2" class="cuadro" align="right">
		<cfif IsDefined("session.Usucodigo") and session.Usucodigo NEQ 0>
	Bienvenido, 
		<cfquery name="rs_nombre_completo" datasource="SDC">
			select Pnombre+' '+isnull(Papellido1,'')+' '+isnull(Papellido2,'') as nombre 
			from Usuario u 
			where u.Usucodigo = #Session.Usucodigo#
		</cfquery><cfoutput>#rs_nombre_completo.nombre#</cfoutput> | <a href="../tienda/public/logout.cfm">Salir</a>	<cfelse><cfoutput><a href="/jsp/sdc/p/coldfusion.jsp?uri=#GetPageContext().getRequest().getRequestURI()#">Firmarse</a></cfoutput>
	</cfif></td>
  </tr>
  <tr> 
    <td valign="top"><cfinclude template="../tienda/public/logo.cfm">
<!-- TemplateBeginEditable name="left" -->&nbsp;<!-- TemplateEndEditable --></td>
    <td width="100%" valign="top"> <table width="100%">
        <!--DWLayoutTable-->
        <tr> 
          <td> <table width="100%" border="0">
              <!--DWLayoutTable-->
              <tr> 
                <td width="56" rowspan="2" align="center" valign="middle">
				<cfif IsDefined("session.total_carrito")>
					<a href="../tienda/public/carrito.cfm">
					<img src="../tienda/images/carrito.gif" width="58" height="62" align="middle" alt="Ver carrito" border="0">
					</a>
				<cfelse>
					<img src="../tienda/images/carrito.gif" width="58" height="62" align="middle" alt="Ver carrito" border="0">
				</cfif>
				</td>
                <td width="165" align="center" valign="middle">
					<cfif IsDefined("session.total_carrito")>
					<cfoutput>
					<a href="../tienda/public/carrito.cfm" class="top">
					<img src="../tienda/images/btn_micompra.gif" alt="Mi compra" width="140" height="16" border="0"><br>
					&cent;#LSCurrencyFormat(session.total_carrito,'none')# ivi</cfoutput></a>
					<cfelse>&nbsp;
					</cfif>
				</td>
                <td rowspan="2" align="center" valign="middle" class="catego"> 
                  <h1 align="center"><!-- TemplateBeginEditable name="Header1" -->Men&uacute; vigente
                  al d&iacute;a de hoy<!-- TemplateEndEditable --></h1></td>
                <td width="214" rowspan="2" align="right" valign="middle"><a href="/jsp/sdc/"><img src="../Imagenes/logo2.gif" width="154" height="62" align="middle" alt="migestion.net" border="0"></a></td>
              </tr>
              <tr> 
                <td align="center" valign="middle">
				<cfif IsDefined("session.Usucodigo") and session.Usucodigo NEQ 0>
				<a href="../tienda/private/comprar/favoritas.cfm" class="top"><img src="../tienda/images/btn_anteriores.gif" alt="Compras anteriores" width="140" height="16" border="0">                  </a>
				</cfif></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td valign="top"><!-- TemplateBeginEditable name="Contenido" -->Contenido<!-- TemplateEndEditable --></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td colspan="2" class="cuadro">&nbsp;</td>
  </tr>
</table>
</body>
</html>
