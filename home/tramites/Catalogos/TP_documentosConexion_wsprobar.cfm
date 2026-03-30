<cfquery name="rsMetodo" datasource="#session.tramites.dsn#">
	select 	  s.nombre_servicio
			, s.con_url
			, s.con_usuario
			, s.con_passwd
			, s.proxy_servidor
			, s.proxy_puerto
			, m.nombre_metodo
			, m.clase_input
			, m.clase_output
	  from WSMetodo m
	  	inner join WSServicio s
			on s.id_servicio = m.id_servicio
	 where m.id_metodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.M#">
</cfquery>

<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
	select 	  nombre_dato
			, direccion
			, tipo_dato
			, tipo_valor
			, valor
	  from WSDato
	 where id_metodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.M#">
</cfquery>

<html>
	<head>
		<title>
			Prueba de Conectividad de un WebService
		</title>
	</head>
	<body>
		<font face="Verdana, Arial, Helvetica, sans-serif"
				 color="#0000FF"
				 pointsize="18px"
		>
		<cfoutput>
		<form name="form1" method="post" action="">
			<table>
				<tr>
					<td>
						<strong>Servicio Web:</strong>
					</td>
					<td>
						#rsMetodo.nombre_servicio#
					</td>
				</tr>
				<tr>
					<td>
						<strong>Función:</strong>
					</td>
					<td>
						#rsMetodo.nombre_metodo#
					</td>
				</tr>
				<tr>
					<td>
						<strong>Dirección URL:&nbsp;</strong>
					</td>
					<td>
						#rsMetodo.con_url#
					</td>
				</tr>
			</table>
		</cfoutput>
		</font>
			<table>
				<tr>
					<td>
						<strong>Parametros de la Función:</strong>
					</td>
				</tr>
		<cfoutput query="rsDatos">
			<cfif direccion EQ "I">
				<tr>
					<td>
						<strong>#nombre_dato#</strong>
					</td>
					<td>
						<cfif tipo_dato EQ "N">
							Numérico
						<cfelseif tipo_dato EQ "S">
							Caracter
						<cfelseif tipo_dato EQ "F">
							Fecha
						<cfelseif tipo_dato EQ "B">
							Lógico&nbsp;(S/N)
						<cfelseif tipo_dato EQ "I">
							Imagen
						<cfelse>
							N/A
						</cfif>
					</td>
					<td>
						<input type="text" name="#nombre_dato#" value="<cfif isdefined("form.#nombre_dato#")>#evaluate("form.#nombre_dato#")#<cfelseif tipo_valor EQ 'V'>#valor#</cfif>">
					</td>
				</tr>
			</cfif>
		</cfoutput>
				<tr>
					<td colspan="3">
						<input type="submit" name="btnEjecutar" value="Ejecutar">
					</td>
				</tr>
			</table>
		</form>
<cfif isdefined("btnEjecutar")>
	<cfset LvarWS = StructNew()>

	<cfset LvarWS.Url 			= "#rsMetodo.con_url#">
	<cfset LvarWS.proxyServer 	= "#rsMetodo.proxy_servidor#">
	<cfset LvarWS.proxyPort 	= "#rsMetodo.proxy_puerto#">
	<cfset LvarWS.uid 			= "#rsMetodo.con_usuario#">
	<cfset LvarWS.pwd 			= "#rsMetodo.con_passwd#">
	<cfset LvarWS.clase_input 	= "#rsMetodo.clase_input#">
	<cfset LvarWS.clase_output	= "#rsMetodo.clase_output#">
	
	<cfset LvarWS.nombre		= "#rsMetodo.nombre_metodo#">
	<cfset LvarWS.inputDatos	= ArrayNew(1)>
	<cfset LvarWS.outputDatos	= ArrayNew(1)>
	<cfoutput query="rsDatos">
		<cfif direccion EQ "I">
			<cfset LvarDireccion = "inputDatos">
		<cfelse>
			<cfset LvarDireccion = "outputDatos">
		</cfif>
		<cfset LvarDato = StructNew()>
		<cfset LvarDato.Nombre = nombre_dato>
		<cfset LvarDato.Tipo   = tipo_dato>
		<cfif direccion EQ "I">
			<cfset LvarDato.Valor  = evaluate("form.#nombre_dato#")>
		</cfif>
		
		<cfset ArrayAppend(LvarWS[LvarDireccion], LvarDato)>
	</cfoutput>

	<cfobject name="LvarObj" component="home.tramites.componentes.WS">
	
	<cftry>
		<cfset LvarResultado = LvarObj.fnInvocaMetodo (LvarWS, LvarWS)>
		<cfdump var="#LvarResultado#">
	<cfcatch type="WSapp">
		<cfdump var="#cfcatch.Message#">
	</cfcatch>
	<cfcatch type="any">
		<cfdump var="#cfcatch#">
	</cfcatch>
	</cftry>
</cfif>
	</body>
</html>