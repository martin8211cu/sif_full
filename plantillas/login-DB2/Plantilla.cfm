<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>$$TITLE$$</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<script language="javascript1.2" type="text/javascript" src="utiles.js"> </script>
<link href="/cfmx/plantillas/login02/login02.css" rel="stylesheet" type="text/css">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
</head>

<body style="margin:0;">
<cf_templatecss>
<center><img src="/cfmx/plantillas/login-DB2/images/headerv2.gif" width="980" height="82" alt="SOIN Soluciones Integrales, S.A.  L&iacute;deres en Innovaci&oacute;n Tecnol&oacute;gica"></center>
<center>
<table border="0" cellspacing="0" cellpadding="0" width="980" style="margin:0; ">  
  <tr>
    <td style="background-image:url(/cfmx/plantillas/login02/images/menuimg.gif)" valign="top">&nbsp;</td>
	<td style="background-image:url(/cfmx/plantillas/login02/images/menuimg.gif)" valign="middle" height="20">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td align="center">&nbsp;</td>
					<td width="10%" align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a tabindex="-1" href="/cfmx/home/index.cfm">INICIO</a></td>
					<td width="70%" align="center">&nbsp;</td>
					<!---EMPRESA Y CAMBIO DE LA MISMA--->
					<cfsetting enablecfoutputonly="yes">
					<cfquery name="header__rsEmpresasU" datasource="asp" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
						select Ecodigo, count(1) as rsEmpresasU_cantidad
						from vUsuarioProcesos up
						where up.Usucodigo = #Session.Usucodigo#
						group by Ecodigo
					</cfquery>
					<cfset LvarEmpresasUsuario = "">
					<cfoutput query="header__rsEmpresasU">
						<cfset LvarEmpresasUsuario=LvarEmpresasUsuario & header__rsEmpresasU.Ecodigo & ",">
					</cfoutput>
					<cfset LvarEmpresasUsuario = LvarEmpresasUsuario & "-1">
					<cfquery name="header__rsEmpresas" datasource="asp" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
						select 
							  e.Enombre
							, e.Ecodigo
							, e.Ereferencia as Ereferencia
							, upper( e.Enombre ) as Enombre_upper
							, ((select min(c.Ccache)
								from Caches c
								where c.Cid = e.Cid
							)) as Ccache
							, e.ts_rversion as ts_rversion
						from Empresa e
						where e.Ecodigo   in (#LvarEmpresasUsuario#)
						  and e.CEcodigo   = #Session.CEcodigo#
						<cfif Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0>
						  and e.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.Ecodigo#">
						<cfelse>
						  order by e.Enombre
						</cfif>
					</cfquery>
					<cfsetting enablecfoutputonly="no">
					<script type="text/javascript">
					function header__empresas(v) {
						var f = document.forms.header__formempresas;
						var a = document.all?document.all.header__aempresas:document.getElementById('header__aempresas');
						f.style.display=v?'inline':'none';
						a.style.display=v?'none':'inline';
					}
					</script>
					<td width="272" align="right" valign="middle" nowrap="nowrap" class="iconoUsuario">
					<cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo) and Session.Usucodigo NEQ 0>
        				<cfoutput>
          					<cfif (header__rsEmpresas.RecordCount GT 1)>
            					<a href="javascript:header__empresas(true)" id="header__aempresas" style="display:none;"> # HTMLEditFormat( REReplace(session.Enombre, '<[^>]+>', '', 'all'))#</a>
								<form style="display:inline;" name="header__formempresas" id="header__formempresas" action="/cfmx/home/menu/index.cfm">
								  <select name="seleccionar_EcodigoSDC" onChange="this.form.submit()">
									<cfloop query="header__rsEmpresas">
									  <option value="#Ecodigo#" <cfif Ecodigo EQ session.EcodigoSDC>selected="selected"</cfif>>#HTMLEditFormat( REReplace( Enombre, '<[^>]+>', '', 'all') )#</option>
									</cfloop>
								  </select>
								  <noscript>
								  <input type="submit" value="Ir" class="btnSiguiente">
								  </noscript>
								</form>
								<script type="text/javascript">
									header__empresas(false);
							   </script>
            				<cfelse>
            					<strong>#HTMLEditFormat(session.enombre)#</strong>
         		 			</cfif>
        				</cfoutput>
    				</cfif>
	  				</td>
					<!---FIN EMPRESA Y CAMBIO DE LA MISMA--->
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td width="10%" align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a tabindex="-1" href="/cfmx/home/menu/micuenta/">PREFERENCIAS</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td width="10%" align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a tabindex="-1" href="/cfmx/home/public/logout.cfm">SALIR</a></td>
					<td align="center">&nbsp;</td>
				  </tr>
		</table>
	</td>
  </tr>
</table></center>
<center>
<table border="0" cellspacing="0" cellpadding="0" width="980" align="center" style="margin:0; vertical-align:top ">
  <tr >
	<td valign="top" colspan="2" align="center">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				<td rowspan="2" align="left" valign="top">$$LEFT OPTIONAL$$
				  </td>
				<td align="left" valign="top">$$HEADER OPTIONAL$$ </td>
				</tr>
				<tr>
				  <td align="left" valign="top">$$BODY$$ </td>
				</tr>
	  	</table>
	</td>
  </tr>

<tr><td colspan="2">&nbsp;</td></tr>
  <tr>
    <td style="background-image:url(/cfmx/plantillas/login02/images/menuimg.gif)" valign="top">&nbsp;</td>
	<td style="background-image:url(/cfmx/plantillas/login02/images/menuimg.gif)" height="20" valign="middle">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td align="center">&nbsp;</td>
					<td valign="middle" align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a tabindex="-1" style="color:#000099" href="/cfmx/home/index.cfm">INICIO</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a tabindex="-1" style="color:#000099" href="/cfmx/plantillas/info/nosotros.cfm">NOSOTROS</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a tabindex="-1" style="color:#000099" href="/cfmx/plantillas/info/productos.cfm">PRODUCTOS</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a tabindex="-1" style="color:#000099" href="/cfmx/plantillas/info/capacitacion.cfm">CAPACITACI&Oacute;N</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a tabindex="-1" style="color:#000099" href="/cfmx/home/menu/index.cfm">SERVICIOS</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a tabindex="-1" style="color:#000099" href="/cfmx/plantillas/info/soporte.cfm">SOPORTE</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a tabindex="-1" style="color:#000099" href="/cfmx/plantillas/info/contactenos.cfm">CONT&Aacute;CTENOS</a></td>
					<td align="center">&nbsp;</td>
				  </tr>
		</table>
	</td>
  </tr>
  
  
  
  <tr>
    <td colspan="2">
		<font size="1" face="Verdana" color="black"> &copy; SOIN, Soluciones Integrales S.A. 2004 </font>
	</td>
  </tr>
</table></center>
</body>
</html>
