<!--- <cf_dump var="#url#"> --->
<cfif isDefined("url.AnexoCelId")>
	<cfset form.AnexoCelId = url.AnexoCelId>
</cfif>
<cfif isDefined("url.AnexoId")>
	<cfset form.AnexoId = url.AnexoId>
</cfif>
<cfif isDefined("url.Ecodigo")>
	<cfset form.Ecodigo = url.Ecodigo>
</cfif>
<cfif isDefined("url.Cconcepto")>
	<cfset form.Cconcepto = url.Cconcepto>
</cfif>
<cfif isDefined("url.modo")>
	<cfset form.modo = url.modo>
</cfif>

<cfif modo eq "ALTA">
	<cfquery name="rsAlta" datasource="#Session.DSN#">
		insert into AnexoCelConcepto (AnexoCelId,Ecodigo,Cconcepto)
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Cconcepto#">
		)
	</cfquery>
<cfelseif modo eq "BAJA">
	<cfquery name="rsBaja" datasource="#Session.DSN#">
		delete from AnexoCelConcepto
		where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
		  and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Cconcepto#">			  
	</cfquery>
	<cfset modo="ALTA">
</cfif>

<cfoutput>
<form action="anexo-conceptos.cfm?AnexoId=#form.AnexoId#&AnexoCelId=#AnexoCelId#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="AnexoId" type="hidden" value="#form.AnexoCelId#">
</form>
</cfoutput>		

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>