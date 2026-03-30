<cfif isdefined("url.BUid") and not isdefined("form.BUid") >
	<cfset form.BUid = url.BUid >
</cfif>
<cfif isdefined("url.PCcodigo") and not isdefined("form.PCcodigo") >
	<cfset form.PCcodigo = url.PCcodigo >
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Recursos Humanos - Test de Benziger</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">

<body>
	<cfinclude template="header.cfm">

	<br>
		<table width="40%" align="center" border="0" cellpadding="3" cellspacing="0">
			<tr><td colspan="3" align="center"><cf_botones exclude="alta,limpiar"></td></tr>
		</table>

<cfparam name="url.PCcodigo" default="BTSAes">
<cfset form.PCid = 0 >
<cfif isdefined("url.PCcodigo") and len(trim(url.PCcodigo))>
	<cfquery name="rsCuestionario" datasource="sifcontrol" >
		select PCid
		from PortalCuestionario
		where upper(PCcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.PCcodigo)#">
	</cfquery>
	<cfif len(trim(rsCuestionario.PCid)) eq 0 >
		<cfthrow message="No se ha definido el cuestionario.">
	</cfif>
	<cfset form.PCid = rsCuestionario.PCid >
</cfif>
<cfif isdefined("url.PCid") and not isdefined("form.PCid")>
	<cfset form.PCid = url.PCid >
</cfif>	

<cfset form.PCUid = 0 >
<cfif isdefined("form.BUid") and len(trim(form.BUid)) >
	<cfquery name="rsContestado" datasource="sifcontrol">
		select a.PCUid
		from PortalCuestionarioU a
		where a.BUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BUid#">
	</cfquery>
	<cfif len(trim(rsContestado.PCUid))>
		<cfset form.PCUid = rsContestado.PCUid >
	</cfif>
</cfif>	

<!--- 
	El pintado del cuestionario depende del tipo de evaluacion. 
	Hay dos tipos de evaluacion:
		1. Por habilidades: esta opcion significa que por cada habilidad asociada al puesto
							se va a pintar un cuestionario
		2. Por Cuestionario: para esta opcion solo se pinta el cuestionario que se selecciono
		   para la relacion de evaluacion.	
--->
<cfset tipo_evaluacion = 2 >
<cfif isdefined("form.PCid") and len(trim(form.PCid))>
	<cfset tipo_evaluacion = 2 >
</cfif>

<link type="text/css" rel="stylesheet" href="/cfmx/asp/css/asp.css">
<table width="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top"><cfinclude template="pccontestar-form.cfm"></td>
	</tr>
</table>



	<!---</form>--->
	
</body>
</html>