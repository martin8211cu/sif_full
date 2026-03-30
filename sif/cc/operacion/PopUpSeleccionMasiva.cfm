<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined("url.pn_disponible") and len(trim(url.pn_disponible)) and not isdefined("form.pn_disponible")>
	<cfset form.pn_disponible = url.pn_disponible>
</cfif>
<cfif isdefined("url.Mcodigo") and len(trim(url.Mcodigo)) and not isdefined("form.Mcodigo")>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif>
<cfif isdefined("url.Pcodigo") and len(trim(url.Pcodigo)) and not isdefined("form.Pcodigo")>
	<cfset form.Pcodigo = url.Pcodigo>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsSocio" datasource="#session.DSN#">
	select SNnumero#_Cat#' - '#_Cat# SNnombre as SocioNegocio
	from SNegocios
	where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
</cfquery>
<cfquery name="rsMoneda" datasource="#session.DSN#">
	select Mnombre from Monedas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
</cfquery>

<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td><strong>Socio de Negocio:&nbsp;</strong></td>
			<td>#rsSocio.SocioNegocio#</td>					
		</tr>		
		<tr>
			<td><strong>Moneda:&nbsp;</strong></td>
			<td>#rsMoneda.Mnombre#</td>
		</tr>
		
	</table>
</cfoutput>


<body>
</body>
</html>

