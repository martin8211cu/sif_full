<cfset GvarEcodigo = 1>
<cfset GvarConexion = 'minisif'>
<cfset GvarEnombre = 'Dorian´s Shop'>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Obtener Cliente</title>
</head>
<body>
	<cfif isdefined("form.NumeroSocio")>
		<h1>Proceso</h1>
		<cfdump var="#form#">
		<cftry>
		<cfset info = getSocio(form.NumeroSocio,form.DireccionEnvio,form.DireccionFact)>
		<cfdump var="#info#">
		<cfcatch>
			<cfoutput>
				<h3>Error:</h3>
				<cfdump var="#cfcatch.Message#"><br>				
			</cfoutput>
		</cfcatch>
		</cftry>
	</cfif>
	<h1>Obtener Cliente</h1>
	<form name="form1" method="post" action="getSocio.cfm">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td>Envío(SNcodigoext,SNDcodigo):&nbsp;</td>
		<td><input type="text" name="DireccionEnvio"></td>
	  </tr>
	  <tr>
		<td>Fact(SNcodigoext,SNDcodigo):&nbsp;</td>
		<td><input type="text" name="DireccionFact"></td>
	  </tr>
	  <tr>
		<td>Socio(SNcodigoext, SNnumero):&nbsp;</td>
		<td><input type="text" name="NumeroSocio">&nbsp;</td>
	  </tr>
	</table>
	<input type="submit" name="submit" value="submit">
	</form>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td valign="top">
				<cfquery name="rsSNDirecciones" maxrows="25" datasource="minisif">
					select SNcodigoext, SNDcodigo, SNnombre, SNDenvio, SNDfacturacion, SNcodigo, id_direccion
					from SNDirecciones
					where SNcodigoext is not null
					or SNDcodigo is not null
					and Ecodigo = 1
					order by SNcodigo
				</cfquery>
				<cfdump var="#rsSNDirecciones#">
		</td>
		<td valign="top">
				<cfquery name="rsSNegocios" maxrows="25" datasource="minisif">
					select SNcodigoext, SNnumero, SNnombre, SNcodigo, SNid
					from SNegocios
					where SNcodigoext is not null
					or SNnumero is not null
					and Ecodigo = 1
					order by SNcodigo
				</cfquery>
				<cfdump var="#rsSNegocios#">
		</td>
	  </tr>
	</table>
</body>
</html>

<cffunction access="private" name="getSocio" output="true" returntype="query">
	<cfargument name="NumeroSocio" required="yes" type="string">
	<cfargument name="CodigoDireccionEnvio" required="yes" type="string">
	<cfargument name="CodigoDireccionFact" required="yes" type="string">
	<cfset var Lvar_SNid = 0>
	<cfset var Lvar_SNcodigo = 0>
	<cfset var Lvar_id_direccion_envio = 0>
	<cfset var Lvar_id_direccion_fact = 0>
	<!--- 	Consulta Dirección de Envío 
			Cuendo Viene la Dirección de Envío, se toma el Socio de la Dirección de Envío como el Socio de Negocios, 
			omitiendo el valor del Argumento NumeroSocio.
	--->
	<cfif len(trim(Arguments.CodigoDireccionEnvio))>
		<!--- Busca la Direccion por SNcodigoext  --->
		<cfquery name="query1" datasource="#GvarConexion#">
			select SNid, SNcodigo, id_direccion
			from SNDirecciones
			where upper(rtrim(SNcodigoext)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.CodigoDireccionEnvio))#">
			and SNDenvio = 1
		</cfquery>
		<cfif query1.recordcount eq 0>
			<cfquery name="query1" datasource="#GvarConexion#">
				select SNid, SNcodigo, id_direccion
				from SNDirecciones
				where upper(rtrim(SNDcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.CodigoDireccionEnvio))#">
				and SNDenvio = 1
			</cfquery>
		</cfif>
		<cfif query1.recordcount gt 0>
			<cfset Lvar_SNid = query1.SNid>
			<cfset Lvar_SNcodigo = query1.SNcodigo>
			<cfset Lvar_id_direccion_envio = query1.id_direccion>
		</cfif>
	</cfif>
	<!--- 	Consulta Dirección de Facturación
			Cuendo Viene la Dirección de Facturación, se toma el Socio de la Dirección de Facturación como el Socio de Negocios, 
			omitiendo el valor del Argumento NumeroSocio, SI Y SOLO SI no se pudo obtener el Socio por el campo de Dirección de Envío.
	--->
	<cfif len(trim(Arguments.CodigoDireccionFact))>
		<!--- Busca la Direccion por SNcodigoext  --->
		<cfquery name="query2" datasource="#GvarConexion#">
			select SNid, SNcodigo, id_direccion
			from SNDirecciones
			where upper(rtrim(SNcodigoext)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.CodigoDireccionFact))#">
			and SNDfacturacion = 1
		</cfquery>
		<cfif query2.recordcount eq 0>
			<cfquery name="query2" datasource="#GvarConexion#">
				select SNid, SNcodigo, id_direccion
				from SNDirecciones
				where upper(rtrim(SNDcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.CodigoDireccionFact))#">
				and SNDfacturacion = 1
			</cfquery>
		</cfif>
		<cfif query2.recordcount gt 0>
			<cfif Lvar_SNid eq 0>
				<cfset Lvar_SNid = query2.SNid>
				<cfset Lvar_SNcodigo = query2.SNcodigo>
			</cfif>
			<cfset Lvar_id_direccion_fact = query2.id_direccion>
		</cfif>
	</cfif>
	<!--- 	Consulta Socio de Negocios 
			SI Y SOLO SI no se pudo obtener el Socio por el campo de Dirección de Envío, Ni por el de Facturación.
	--->
	<cfif Lvar_SNid eq 0 and len(trim(NumeroSocio)) gt 0>
		<cfquery name="query3" datasource="#GvarConexion#" maxrows="1">
			select SNid,SNcodigo,id_direccion
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
			  and SNcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.NumeroSocio#">
		</cfquery>
		<cfif query3.recordcount eq 0>
			<cfquery name="query3" datasource="#GvarConexion#" maxrows="1">
				select SNid,SNcodigo,id_direccion
				from SNegocios
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				  and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.NumeroSocio#">
			</cfquery>
		</cfif>
		<cfif query3.recordcount gt 0>
			<cfset Lvar_SNid = query3.SNid>
			<cfset Lvar_SNcodigo = query3.SNcodigo>
			<cfset Lvar_id_direccion_envio = query3.id_direccion>
			<cfset Lvar_id_direccion_fact = query3.id_direccion>
		</cfif>
	</cfif>
	<!--- Valida el Proceso --->
	<cfif Lvar_SNid lte 0 or len(trim(Lvar_SNcodigo)) lte 0>
		<cfthrow message="Error en Interfaz 10. NumeroSocio es inválido, La Dirección de Envío, Dirección de Facturación y El Numero de Socio no corresponden con ningún Socio de la Empresa #GvarEnombre#. Proceso Cancelado!.">
	</cfif>
	<cfquery name="Lvar_Query" datasource="#GvarConexion#">
		select #Lvar_SNid# as SNid,
			#Lvar_SNcodigo# as SNcodigo,
			#Lvar_id_direccion_envio# as id_direccion_envio,
			#Lvar_id_direccion_fact# as id_direccion_fact
		from dual
	</cfquery>
	<cfreturn Lvar_Query>
</cffunction>