<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cf_navegacion name="Nivel" default="1">
<cf_navegacion name="Eperiodo" default="0">
<cf_navegacion name="Emes" default="0">
<cf_navegacion name="CG5CON" default="0">
<cf_navegacion name="CGBBAT" default="0">
<cf_navegacion name="IDcontable" default="0">

<cfif form.Nivel EQ 1>
	<cfinclude template="CGV3cierres.cfm">
<cfelseif form.Nivel eq 2>
	<cfinclude template="CGV3asientos.cfm">
<cfelseif form.Nivel eq 3>
	<cfif form.IDcontable NEQ 0>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Eperiodo, Emes, CG5CON, CGBBAT
			  from CGV3asientos
			 where Ecodigo		= #session.Ecodigo#
			   and IDcontable	= #url.IDcontable#
		</cfquery>
		<cfset form.Eperiodo	= rsSQL.Eperiodo>
		<cfset form.Emes		= rsSQL.Emes>
		<cfset form.CG5CON		= rsSQL.CG5CON>
		<cfset form.CGBBAT		= rsSQL.CGBBAT>
	</cfif>
	<cfinclude template="CGV3detalles.cfm">
<cfelseif form.Nivel eq 4>
	<cfinclude template="CGV3cuentas.cfm">
<cfelseif form.Nivel eq 5>
	<cfinclude template="CGV3polizaGen.cfm">
<cfelseif form.Nivel eq 6>
	<cfinclude template="CGV3polizaApl.cfm">
<cfelse>
	<cfinclude template="CGV3cierres.cfm">
</cfif>
