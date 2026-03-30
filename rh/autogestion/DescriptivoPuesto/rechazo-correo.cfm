<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Informacion_sobre_el_perfil_de_puesto_creado"
	Default="Información sobre el perfil de puesto creado"
	returnvariable="MSG_Informacion_sobre_el_perfil_de_puesto_creado"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_RecursosHumanos"
	Default="Recursos Humanos"
	returnvariable="MSG_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_El_Perfil_fue_rechazado_por_el_jefe_asesor"
	Default="El Perfil fue rechazado por el jefe asesor"
	returnvariable="MSG_El_Perfil_fue_rechazado_por_el_jefe_asesor"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_El_Perfil_fue_rechazado_por_el_encargado_del_centro_funcional"
	Default="El Perfil fue rechazado por el encargado del centro funcional"
	returnvariable="MSG_El_Perfil_fue_rechazado_por_el_encargado_del_centro_funcional"/>

<cffunction name="mailBody" returntype="string">
	<cfargument name="NombreDE" 	type="string" required="yes">
	<cfargument name="NombrePARA" 	type="string" required="yes">
	<cfargument name="motivo" 		type="string" required="yes">
 	<cfsavecontent variable="_mail_body">
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		<html>
		<head>
		<title><cfoutput>#MSG_Informacion_sobre_el_perfil_de_puesto_creado#</cfoutput></title>
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

		
		<!--- <cfquery name="dataCorreo" datasource="#session.DSN#">
			select a.ERid, a.SNcodigo, a.EDRnumero, a.EDRfecharec, a.ERobs,b.SNnumero, b.SNnombre
			from EReclamos a
		
			inner join SNegocios b
			on a.SNcodigo=b.SNcodigo
			and a.Ecodigo=b.Ecodigo
		
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.ERid=<cfqueryparam value="#arguments.ERid#" cfsqltype="cf_sql_numeric">
		</cfquery> --->
		

		
		<cfoutput>
		  <table border="0" width="100%" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
			<tr bgcolor="##003399">
			  <td colspan="2" height="24"></td>
			</tr>
			<tr bgcolor="##999999">
			  <td colspan="2"> <strong><cfoutput>#MSG_Informacion_sobre_el_perfil_de_puesto_creado#</cfoutput></strong> </td>
			</tr>
			<tr>
			  <td width="70">&nbsp;</td>
			  <td width="476">&nbsp;</td>
			</tr>
			<tr>
			  <td><span class="style2"><cf_translate  key="LB_De">De</cf_translate></span></td>
			  <td><span class="style7"><cfoutput>#arguments.NombreDE#</cfoutput></span></td>
			</tr>
		
			<tr>
			  <td><span class="style7"><strong><cf_translate  key="LB_Para">Para</cf_translate></strong></span></td>
			  <td> <span class="style7"><cfoutput>#arguments.NombrePARA#</cfoutput></span></td>
			</tr>
		
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style8"></span></td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td><span class="style7"><cfoutput>#MSG_Informacion_sobre_el_perfil_de_puesto_creado#</cfoutput></span></td>
			</tr>
		
			<tr>
			  <td>&nbsp;</td>
			  <td>
				<table border="0" width="100%" cellpadding="2" cellspacing="0" style="border:1px solid ##999999;" > 

					<tr>
						<td width="1%" nowrap><span class="style8"><strong><cf_translate  key="LB_Observaciones">Observaciones</cf_translate>:&nbsp;</strong></span></td>
						<td align="left">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr><td><span class="style8"><cfif len(trim(arguments.motivo)) ><p><cfoutput>#arguments.motivo#</cfoutput></p><cfelse>No se registraron observaciones</cfif></span></td></tr>
							</table>
						</td>
					</tr>
		
					
		
					
				</table>
			  </td>
			</tr>
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style8"></span></td>
			</tr>
		
			<cfset hostname = session.sitio.host>
			<cfset Usucodigo = session.Usucodigo>
			<cfset CEcodigo = session.CEcodigo>
		
			<tr>
			  <td>&nbsp;</td>
			  <td align="center"><span class="style1">Nota: En #hostname# respetamos su privacidad. <br>
			  Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click <a href="http://#hostname#/cfmx/home/public/optout.cfm?a=#Usucodigo#&amp;b=#CEcodigo#&amp;c=#hostname#&amp;#Hash(Usucodigo & 'please let me out of ' & hostname)#">aqu&iacute;</a>. </span></td>
			</tr>
		
		  </table>
		</cfoutput>
		
		</body>
		</html>
 	</cfsavecontent>
	<cfreturn _mail_body >
</cffunction>