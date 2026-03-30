<cffunction name="mailBody" returntype="string">
	<cfargument name="SNcodigo" type="numeric" required="yes">			<!--- id del socio invitado --->

	<cfsavecontent variable="_mail_body">
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		<html>
		<head>
		<title>Invitaci&oacute;n a Proceso de Compra</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<style type="text/css">
		<!--
		.style1 {
			font-size: 10px;
			font-family: "Times New Roman", Times, serif;
		}
		.style2 {
			font-family: Verdana, Arial, Helvetica, sans-serif;
			font-weight: bold;
			font-size: 14;
		}
		.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
		.style8 {font-size: 14}
		
		.style9 {font-size: 13}
		-->
		</style>
		</head>
		
		<body>
		<cfquery name="rsPara" datasource="#session.DSN#">
			select SNnombre
			from SNegocios
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">
		</cfquery>

		<cfoutput>
		  <table border="0" width="100%" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
			<tr bgcolor="##003399">
			  <td colspan="2" height="24"></td>
			</tr>
			<tr bgcolor="##999999">
			  <td colspan="2"> <strong>Invitaci&oacute;n a Proceso de Compra</strong> </td>
			</tr>
			<tr>
			  <td width="70">&nbsp;</td>
			  <td width="476">&nbsp;</td>
			</tr>
			<tr>
			  <td><span class="style2">De</span></td>
			  <td><span class="style7">#session.Enombre#</span></td>
			</tr>
		
			<tr>
			  <td><span class="style7"><strong>Para</strong></span></td>
			  <td> <span class="style7">#rsPara.SNnombre#</span></td>
			</tr>
		
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style8"></span></td>
			</tr>

			<tr>
			  <td><span class="style7"><strong>Asunto</strong></span></td>
			  <td>
			  	<span class="style7">Invitaci&oacute;n a Proceso de Compra.</span>
			  </td>
			</tr>
		
			<tr>
			  <td colspan="2">
				<table border="0" width="100%" cellpadding="2" cellspacing="0" > 
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Proceso de Compra:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#rsDatosProcesoEncabezado.CMPdescripcion#</span></td>
					</tr>
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Fecha de Publicaci&oacute;n:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#LSDateFormat(rsDatosProcesoEncabezado.CMPfechapublica,'dd/mm/yyyy')#</span></td>
					</tr>

					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Fecha maxima para recibir ofertas:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#LSDateFormat(rsDatosProcesoEncabezado.CMPfmaxofertas,'dd/mm/yyyy')#</span></td>
					</tr>

					<tr><td colspan="2">&nbsp;<hr size="1" color="##999999"></td></tr>
				</table>
			  </td>
			</tr>
		
			<!---
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style7">
					Ingrese a <a href='http://#session.sitio.host#/cfmx/sif/cm/operacion/reclamos-lista.cfm'> Reclamos Pendientes</a> para revisarlo.
			  </span></td>
			</tr>
		
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style8"></span></td>
			</tr>
			--->
		
			<cfset hostname = session.sitio.host>
			<cfset Usucodigo = session.Usucodigo>
			<cfset CEcodigo = session.CEcodigo>
		
			<!---<tr>
			  <td>&nbsp;</td>
			  <td align="center"><span class="style1">Nota: En #hostname# respetamos su privacidad. <br>
			  Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click <a href="http://#hostname#/cfmx/home/public/optout.cfm?a=#Usucodigo#&amp;b=#CEcodigo#&amp;c=#hostname#&amp;#Hash(Usucodigo & 'please let me out of ' & hostname)#">aqu&iacute;</a>. </span></td>
			</tr>--->
		
		  </table>
		</cfoutput>
		
		</body>
		</html>
	</cfsavecontent>

	<cfreturn _mail_body >
</cffunction>

<cffunction name="mailBodyCotizacion" returntype="string">
	<cfargument name="Nombre" type="string" required="yes">

	<cfsavecontent variable="_mail_body">
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		<html>
		<head>
		<title>Iniciar a Aprobación de Cotizaciones(Solicitante)</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<style type="text/css">
		<!--
		.style1 {
			font-size: 10px;
			font-family: "Times New Roman", Times, serif;
		}
		.style2 {
			font-family: Verdana, Arial, Helvetica, sans-serif;
			font-weight: bold;
			font-size: 14;
		}
		.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
		.style8 {font-size: 14}
		
		.style9 {font-size: 13}
		-->
		</style>
		</head>
		<cfquery name="rsPvalor" datasource="#session.DSN#">
			select Pvalor
			from Parametros
  			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 15500
		</cfquery>
		<body>
		<cfoutput>
		  <table border="0" width="100%" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
			<tr bgcolor="##003399">
			  <td colspan="2" height="24"></td>
			</tr>
			<tr bgcolor="##999999">
			  <td colspan="2"><strong>Iniciar la Aprobación de Cotizaciones(Solicitante)</strong> </td>
			</tr>
			<tr>
			  <td width="70">&nbsp;</td>
			  <td width="476">&nbsp;</td>
			</tr>
			<tr>
			  <td><span class="style2">De</span></td>
			  <td><span class="style7">#session.Enombre#</span></td>
			</tr>
		
			<tr>
			  <td><span class="style7"><strong>Para</strong></span></td>
			  <td> <span class="style7">#Arguments.Nombre#</span></td>
			</tr>
		
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style8"></span></td>
			</tr>

			<tr>
			  <td><span class="style7"><strong>Asunto</strong></span></td>
			  <td>
			  	<span class="style7">Iniciar la Aprobaci&oacute;n de Cotizaciones(Solicitante)</span>
			  </td>
			</tr>
		
			<tr>
			  <td colspan="2">
				<table border="0" width="100%" cellpadding="2" cellspacing="0" >
                	<tr>
						<td width="1%" nowrap><span class="style8"><strong>Num. Proceso:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#rsDatosProcesoEncabezado.CMPnumero#</span></td>
					</tr>
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Proceso de Compra:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#rsDatosProcesoEncabezado.CMPdescripcion#</span></td>
					</tr>
					<tr><td colspan="2">&nbsp;<hr size="1" color="##999999"></td></tr>
				</table>
			  </td>
			</tr>
            <cfset hostname  = session.sitio.host>
			<cfset Usucodigo = session.Usucodigo>
			<cfset CEcodigo  = session.CEcodigo>
            <tr>
			  <td colspan="2">
              <!---se hace la pregunta para saber cual link usar--->
              	<cfif rsPvalor.recordcount and rsPvalor.Pvalor EQ 1>
                	Para visualizar las Cotizaciones haga click <a href="http://#hostname#/cfmx/proyecto7/cotizaciones.cfm">aquí</a>.
                <cfelse>
              		Para visualizar las Cotizaciones haga click <a href="http://#hostname#/cfmx/sif/cm/operacion/evaluarCotizacionesSolicitante.cfm">aquí</a>.
               </cfif>
              </td>
           </tr>
			<!---<tr>
			  <td>&nbsp;</td>
			  <td align="center"><span class="style1">Nota: En #hostname# respetamos su privacidad. <br>
			  Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click <a href="http://#hostname#/cfmx/home/public/optout.cfm?a=#Usucodigo#&amp;b=#CEcodigo#&amp;c=#hostname#&amp;#Hash(Usucodigo & 'please let me out of ' & hostname)#">aqu&iacute;</a>. </span></td>
			</tr>--->
		
		  </table>
		</cfoutput>
		
		</body>
		</html>
	</cfsavecontent>

	<cfreturn _mail_body >
</cffunction>
<cffunction name="mailBodyAprobacionCotizacion" returntype="string">
	<cfargument name="Nombre" type="string" required="yes">

	<cfsavecontent variable="_mail_body">
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		<html>
		<head>
		<title>Finaliza a Aprobación de Cotizaciones(Solicitante)</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<style type="text/css">
		<!--
		.style1 {
			font-size: 10px;
			font-family: "Times New Roman", Times, serif;
		}
		.style2 {
			font-family: Verdana, Arial, Helvetica, sans-serif;
			font-weight: bold;
			font-size: 14;
		}
		.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
		.style8 {font-size: 14}
		
		.style9 {font-size: 13}
		-->
		</style>
		</head>
		
		<body>
		<cfoutput>
		  <table border="0" width="100%" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
			<tr bgcolor="##003399">
			  <td colspan="2" height="24"></td>
			</tr>
			<tr bgcolor="##999999">
			  <td colspan="2"><strong>Finaliza la Aprobación de Cotizaciones(Solicitante)</strong> </td>
			</tr>
			<tr>
			  <td width="70">&nbsp;</td>
			  <td width="476">&nbsp;</td>
			</tr>
			<tr>
			  <td><span class="style2">De</span></td>
			  <td><span class="style7">#session.Enombre#</span></td>
			</tr>
		
			<tr>
			  <td><span class="style7"><strong>Para</strong></span></td>
			  <td> <span class="style7">#arguments.Nombre#</span></td>
			</tr>
		
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style8"></span></td>
			</tr>

			<tr>
			  <td><span class="style7"><strong>Asunto</strong></span></td>
			  <td>
			  	<span class="style7">Finaliza la Aprobaci&oacute;n de Cotizaciones(Solicitante)</span>
			  </td>
			</tr>
		
			<tr>
			  <td colspan="2">
				<table border="0" width="100%" cellpadding="2" cellspacing="0" >
                	<tr>
						<td width="1%" nowrap><span class="style8"><strong>Num. Proceso:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#rsDatosProcesoEncabezado.CMPnumero#</span></td>
					</tr>
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Proceso de Compra:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#rsDatosProcesoEncabezado.CMPdescripcion#</span></td>
					</tr>
					<tr><td colspan="2">&nbsp;<hr size="1" color="##999999"></td></tr>
				</table>
			  </td>
			</tr>
		
			<cfset hostname = session.sitio.host>
			<cfset Usucodigo = session.Usucodigo>
			<cfset CEcodigo = session.CEcodigo>
		
			<!---<tr>
			  <td>&nbsp;</td>
			  <td align="center"><span class="style1">Nota: En #hostname# respetamos su privacidad. <br>
			  Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click <a href="http://#hostname#/cfmx/home/public/optout.cfm?a=#Usucodigo#&amp;b=#CEcodigo#&amp;c=#hostname#&amp;#Hash(Usucodigo & 'please let me out of ' & hostname)#">aqu&iacute;</a>. </span></td>
			</tr>--->
		
		  </table>
		</cfoutput>
		
		</body>
		</html>
	</cfsavecontent>

	<cfreturn _mail_body >
</cffunction>

<cffunction name="mailBodyRechazarCotizacion" returntype="string">
	<cfargument name="Nombre" type="string" required="yes">

	<cfsavecontent variable="_mail_body">
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		<html>
		<head>
		<title>Rechazo Cotizaciones por el Solicitante</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<style type="text/css">
		<!--
		.style1 {
			font-size: 10px;
			font-family: "Times New Roman", Times, serif;
		}
		.style2 {
			font-family: Verdana, Arial, Helvetica, sans-serif;
			font-weight: bold;
			font-size: 14;
		}
		.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
		.style8 {font-size: 14}
		
		.style9 {font-size: 13}
		-->
		</style>
		</head>
		
		<body>
		<cfoutput>
		  <table border="0" width="100%" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
			<tr bgcolor="##003399">
			  <td colspan="2" height="24"></td>
			</tr>
			<tr bgcolor="##999999">
			  <td colspan="2"><strong>Rechazo Cotizaciones por el Solicitante #session.datos_personales.Nombre# #session.datos_personales.Apellido1# #session.datos_personales.Apellido2#</strong> </td>
			</tr>
			<tr>
			  <td width="70">&nbsp;</td>
			  <td width="476">&nbsp;</td>
			</tr>
			<tr>
			  <td><span class="style2">De</span></td>
			  <td><span class="style7">#session.Enombre#</span></td>
			</tr>
		
			<tr>
			  <td><span class="style7"><strong>Para</strong></span></td>
			  <td> <span class="style7">#Arguments.Nombre#</span></td>
			</tr>
		
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style8"></span></td>
			</tr>

			<tr>
			  <td><span class="style7"><strong>Asunto</strong></span></td>
			  <td>
			  	<span class="style7">Rechazo de Aprobaci&oacute;n por el Solicitante #session.datos_personales.Nombre# #session.datos_personales.Apellido1# #session.datos_personales.Apellido2#</span>
			  </td>
			</tr>
		
			<tr>
			  <td colspan="2">
				<table border="0" width="100%" cellpadding="2" cellspacing="0" >
                	<tr>
						<td width="1%" nowrap><span class="style8"><strong>Num. Proceso:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#rsDatosProcesoEncabezado.CMPnumero#</span></td>
					</tr>
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Proceso de Compra:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#rsDatosProcesoEncabezado.CMPdescripcion#</span></td>
					</tr>
					<tr><td colspan="2">&nbsp;<hr size="1" color="##999999"></td></tr>
				</table>
			  </td>
			</tr>
		
			<cfset hostname = session.sitio.host>
			<cfset Usucodigo = session.Usucodigo>
			<cfset CEcodigo = session.CEcodigo>
		
			<!---<tr>
			  <td>&nbsp;</td>
			  <td align="center"><span class="style1">Nota: En #hostname# respetamos su privacidad. <br>
			  Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click <a href="http://#hostname#/cfmx/home/public/optout.cfm?a=#Usucodigo#&amp;b=#CEcodigo#&amp;c=#hostname#&amp;#Hash(Usucodigo & 'please let me out of ' & hostname)#">aqu&iacute;</a>. </span></td>
			</tr>--->
		
		  </table>
		</cfoutput>
		
		</body>
		</html>
	</cfsavecontent>

	<cfreturn _mail_body >
</cffunction>
<cffunction name="mailProveedorCotizacion" returntype="string">
	<cfargument name="SNid" type="numeric" required="yes">

	<cfsavecontent variable="_mail_body">
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		<html>
		<head>
		<title>Rechazo Proceso de Publicación de Compra</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<style type="text/css">
		<!--
		.style1 {
			font-size: 10px;
			font-family: "Times New Roman", Times, serif;
		}
		.style2 {
			font-family: Verdana, Arial, Helvetica, sans-serif;
			font-weight: bold;
			font-size: 14;
		}
		.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
		.style8 {font-size: 14}
		
		.style9 {font-size: 13}
		-->
		</style>
		</head>
		
		<body>

		<cfquery name="rsPara" datasource="#session.DSN#">
			select SNidentificacion, SNnombre
            from SNegocios
            where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SNid#">
		</cfquery>

		<cfoutput>
		  <table border="0" width="100%" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
			<tr bgcolor="##003399">
			  <td colspan="2" height="24"></td>
			</tr>
			<tr bgcolor="##999999">
			  <td colspan="2"><strong>Rechazo Proceso de Publicación de Compra</strong> </td>
			</tr>
			<tr>
			  <td width="70">&nbsp;</td>
			  <td width="476">&nbsp;</td>
			</tr>
			<tr>
			  <td><span class="style2">De</span></td>
			  <td><span class="style7">#session.Enombre#</span></td>
			</tr>
            <tr>
			  <td><span class="style2">Usuario</span></td>
			  <td><span class="style7">#session.datos_personales.Nombre# #session.datos_personales.Apellido1# #session.datos_personales.Apellido2#</span></td>
			</tr>
			<tr>
			  <td><span class="style7"><strong>Para</strong></span></td>
			  <td> <span class="style7">#rsPara.SNidentificacion# #rsPara.SNnombre#</span></td>
			</tr>
		
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style8"></span></td>
			</tr>

			<tr>
			  <td><span class="style7"><strong>Asunto</strong></span></td>
			  <td>
			  	<span class="style7">Rechazo Proceso de Publicación de Compra</span>
			  </td>
			</tr>
		
			<tr>
			  <td colspan="2">
				<table border="0" width="100%" cellpadding="2" cellspacing="0" >
                	<tr>
						<td width="1%" nowrap><span class="style8"><strong>Num. Proceso:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#rsDatosProcesoEncabezado.CMPnumero#</span></td>
					</tr>
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Proceso de Compra:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#rsDatosProcesoEncabezado.CMPdescripcion#</span></td>
					</tr>
                    <tr>
						<td width="1%" nowrap><span class="style8"><strong>Detalles:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">El proceso ha sido rechazado por el comprador, favor esperar hasta nuevo aviso.</span></td>
					</tr>
					<tr><td colspan="2">&nbsp;<hr size="1" color="##999999"></td></tr>
				</table>
			  </td>
			</tr>
		
			<cfset hostname = session.sitio.host>
			<cfset Usucodigo = session.Usucodigo>
			<cfset CEcodigo = session.CEcodigo>
		
			<!---<tr>
			  <td>&nbsp;</td>
			  <td align="center"><span class="style1">Nota: En #hostname# respetamos su privacidad. <br>
			  Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click <a href="http://#hostname#/cfmx/home/public/optout.cfm?a=#Usucodigo#&amp;b=#CEcodigo#&amp;c=#hostname#&amp;#Hash(Usucodigo & 'please let me out of ' & hostname)#">aqu&iacute;</a>. </span></td>
			</tr>--->
		
		  </table>
		</cfoutput>
		
		</body>
		</html>
	</cfsavecontent>

	<cfreturn _mail_body >
</cffunction>
