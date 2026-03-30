
<cfif isdefined ('form.AltaDet')>
	<cfquery name="rsVal" datasource="#session.dsn#">
		select count(1) as cantidad from RHAsesor where 
		Ecodigo=#session.Ecodigo#
		and Usucodigo=#form.Usucodigo#
	</cfquery>
	<cfif rsVal.cantidad gt 0>
		<cf_errorCode	code="51959" msg="Ese empleado ya fue asignado como Asesor.Proceso Cancelado">
	</cfif>
	<cfquery name="rsIns" datasource="#session.dsn#">
		insert into RHAsesor (Usucodigo,Ecodigo)
		values (#form.Usucodigo#,#session.Ecodigo#)
	</cfquery>
	<cflocation url="asesores.cfm">
</cfif>

<cfif isdefined ('form.nuevodet')>
	<cflocation url="asesores.cfm">
</cfif>

<cfif isdefined ('form.bajadet')>
	<cfquery name="rsIns" datasource="#session.dsn#">
		delete from RHAsesor 
		where Usucodigo=#form.Usucodigo#
	</cfquery>
	<cflocation url="asesores.cfm">
</cfif>

