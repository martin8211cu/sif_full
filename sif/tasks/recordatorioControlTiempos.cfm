<cfsetting enablecfoutputonly="yes">
	<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,0,0,10)#>
<cfinclude template="/home/check/dominio.cfm">

<cffunction name="mensaje" returntype="string">
	<cfargument name="nombre_empresa" required="yes" type="string">
	<cfargument name="nombre_persona" required="yes" type="string">
	<cfargument name="email" required="yes" type="string">
	<cfargument name="EcodigoSDC" required="yes" type="numeric">
	<cfargument name="inicio" required="yes" type="string">
	<cfargument name="fin" required="yes" type="string">

<!---
	<cfsavecontent variable="msj">
		<html>
		<head>
		<title>Registro de Control de Tiempos</title>
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
		-->
		</style>
		</head>
		
		<body>

		<cfparam name="hostname" default="localhost">
		
		<cfoutput>
		  <table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
			<tr bgcolor="##999999">
			  <td colspan="2" height="8"></td>
			</tr>
			<tr bgcolor="##003399">
			  <td colspan="2" height="24">
			  </td>
			</tr>

			<tr bgcolor="##999999">
			  <td colspan="2"> <strong>Registro de Control de Tiempos en #arguments.nombre_empresa# </strong> </td>
			</tr>

			<tr>
			  <td width="70">&nbsp;</td>
			  <td width="476">&nbsp;</td>
			</tr>
			<tr>
			  <td><span class="style2">De</span></td>
			  <td><span class="style7">#nombre_empresa# </span></td>
			</tr>
			<tr>
			  <td><span class="style7"><strong>Para</strong></span></td>
			  <td> <span class="style7">#arguments.nombre_persona#</span></td>
			</tr>
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style8"></span></td>
			</tr>
			<tr>
			  <td><span class="style8"></span></td>
			  <td>&nbsp;</td>
			</tr>

			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style7">#arguments.nombre_empresa# le recuerda que debe registrar el Control de Tiempos por Proyectos correspondiente a la semana del #arguments.inicio# al #arguments.fin#.<br>
				Ingrese a <a href='http://#session.sitio.host#/cfmx/sif/ControlTiempos/operacion/registroTiempos.cfm?seleccionar_EcodigoSDC=#arguments.EcodigoSDC#'>Registro de Control de Tiempos</a> para registrar los datos.
			  </td>
			</tr>
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style8"></span></td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td><span class="style1">Nota: este mensaje es generado autom&aacute;ticamente por el sistema de Control de Tiempos. Por favor no responda a este mensaje.</span></td>
			</tr>

		  </table>
		</cfoutput>

		</body>
		</html>
	</cfsavecontent>
--->			
	<cfsavecontent variable="msj">
		<cfoutput>
		#arguments.nombre_empresa# le recuerda que debe registrar el Control de Tiempos por Proyectos correspondiente a la semana del #arguments.inicio# al #arguments.fin#.<br>
		<!---
		Ingrese a <a href='http://#session.sitio.host#/cfmx/sif/ControlTiempos/operacion/registroTiempos.cfm?seleccionar_EcodigoSDC=#arguments.EcodigoSDC#'>Registro de Control de Tiempos</a> para registrar los datos.<br>--->
		<font size="2">Nota: este mensaje es generado autom&aacute;ticamente por el sistema de Control de Tiempos. Por favor no responda a este mensaje.</font>
		</cfoutput>
	</cfsavecontent>
	<cfreturn #msj# >
</cffunction>

<cfset registros = 0 >
<cfset vDebug = false >

<cfset start = Now()>
<cfoutput>
Proceso de Env&iacute;o de Correos de Registro de Control de Tiempos<br>
Iniciando proceso #TimeFormat(start,"HH:MM:SS")#<br></cfoutput>

<cfquery name="bds" datasource="asp">
	select distinct c.Ccache
	from Empresa e, ModulosCuentaE m, Caches c
	where e.CEcodigo = m.CEcodigo
	  and c.Cid = e.Cid
	  and m.SScodigo = 'ControlT'
	and Ereferencia is not null
</cfquery>

<!--- calculo de la semana --->
<cfset fecha = now() >
<cfset fecha_inicio = dateadd('d', 1-DayOfWeek(fecha),fecha) >
<cfset fecha_final  = dateadd('d',7-DayOfWeek(fecha),fecha) >

<cfset contador = 0 >
<cfloop query="bds">
	<cfif vDebug >***********************************************************<br><b>CACHE:</b> <cfdump var="#bds.Ccache#"><br><br></cfif>

	<cfset cache = trim(bds.Ccache) > 

	<cfset continuar = true >
	<!--- validacion de existencia de las tablas --->
	<cftry>
		<cfquery name="rsEmpresas" datasource="#cache#">
			select 1 from Empresas
		</cfquery>
	
		<cfquery name="rsEmpresas" datasource="#cache#">
			select Usucodigo from CTTiempos 
		</cfquery>

		<cfquery name="rsEmpresas" datasource="#cache#">
			select 1 from Usuario
		</cfquery>

		<cfquery name="rsEmpresas" datasource="#cache#">
			select 1 from DatosPersonales
		</cfquery>
		
	<cfcatch type="any">
		<cfset continuar = false >
	</cfcatch>
	</cftry>

	<cfif continuar >
		<cfquery name="empresas" datasource="#cache#">
			select Ecodigo, Edescripcion, EcodigoSDC
			from Empresas
		</cfquery>

		<cfloop query="empresas">
			<cfset empresa = empresas.Ecodigo >
			<cfset empresasdc = empresas.EcodigoSDC >
			<cfset empresa_nombre = empresas.Edescripcion >

			<cfquery name="data" datasource="#cache#">
				select distinct a.Usucodigo, coalesce(c.Pemail1, c.Pemail2) as Pemail, Pnombre || ' ' || Papellido1 || ' ' || Papellido2 as Pnombre
				from CTTiempos a
				
				inner join Usuario b
				on a.Usucodigo=b.Usucodigo
				
				inner join DatosPersonales c
				on b.datos_personales=c.datos_personales
				
				where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
				and a.CTTfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d', -30, fecha)#">
								   and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
			</cfquery>
			<cfloop query="data">
				<cfif len(trim(data.Pemail))>
					<cfset contador = contador + 1 >
					<cfset texto = mensaje( empresa_nombre, data.Pnombre, data.Pemail, empresasdc, LSDateFormat(fecha_inicio,'dd/mm/yyyy'), LSDateFormat(fecha_final,'dd/mm/yyyy') ) >
					<cfquery datasource="asp">
						insert into SMTPQueue(SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml )
						values ( 'gestion@soin.co.cr',
								 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#data.Pemail#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar"   value="Registro de Control de Tiempos">,
								 <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#texto#">,
								 1 )
					</cfquery>
				</cfif>
			</cfloop>

			<cfif vDebug ><b>Empresa:</b><cfdump var="#empresa#"><br><br></cfif>
		</cfloop> <!--- control de empresas --->
	</cfif>	
	<!---<cfif vDebug ><br>***********************************************************<br></cfif>--->
</cfloop>

<cfoutput>
<cfset finish = Now()>
Correos enviados: #contador#<br>
Proceso terminado #TimeFormat(finish,"HH:MM:SS")#<br>
</cfoutput>
