<cfdump var="#form#">
<cfif isdefined ('Alta')>
	<cfquery name="rsVal" datasource="#session.dsn#">
		select count(1) as cantidad from RHMotivos where RHMcodigo='#form.cod#'
	</cfquery>
	<cfif rsVal.cantidad gt 0>
		<cf_errorCode	code="51867" msg="Error! Ese código ya fue registrado.">
	</cfif>
	<cfquery name="rsIns" datasource="#session.dsn#">
		insert into RHMotivos (RHMcodigo,RHMdescripcion,Ecodigo)
		values('#form.cod#',
		'#form.des#',
		#session.Ecodigo#)
	<cf_dbidentity1 datasource="#session.DSN#" name="rsIns">
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="rsIns" returnvariable="LvarRHMid">
    <cf_translatedata name="set" tabla="RHMotivos" col="RHMdescripcion" valor="#form.des#" filtro=" RHMid=#LvarRHMid# ">
	<cflocation url="motivos.cfm?RHMid=#LvarRHMid#">
</cfif>

<cfif isdefined ('Nuevo')>
	<cflocation url="motivos.cfm">
</cfif>

<cfif isdefined ('Cambio')>
	<cfquery name="rsIns" datasource="#session.dsn#">
		update RHMotivos 
		set RHMcodigo='#form.cod#'
		,RHMdescripcion='#form.des#'
		where RHMid=#form.RHMid#
	</cfquery>
    <cf_translatedata name="set" tabla="RHMotivos" col="RHMdescripcion" valor="#form.des#" filtro=" RHMid=#form.RHMid# ">
	<cflocation url="motivos.cfm?RHMid=#form.RHMid#">
</cfif>

<cfif isdefined ('Baja')>
	<cfquery name="rsIns" datasource="#session.dsn#">
		delete from RHMotivos 
		where RHMid=#form.RHMid#
	</cfquery>
	<cflocation url="motivos.cfm">
</cfif>

