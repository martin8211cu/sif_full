<cfif isdefined ('form.Alta')>
	<cfquery name="rsIns" datasource="#session.dsn#">
		insert into RHPedimentos
			(RHPfecha,RHPporc,RHPcodigo,RHMid,RHPjustificacion,RHPfunciones,RHPestado,Ecodigo,Usucodigo,FechaAlta)
		values(
			<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.montoPor#">,
			<cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">,
			<!---<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.tipoA#">,--->
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mot#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtJust#">,
			'#form.txtfunciones#',
			10,
			#session.Ecodigo#,
			#session.Usucodigo#,
			<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
			)
		<cf_dbidentity1 datasource="#session.DSN#" name="rsIns">
	</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="rsIns" returnvariable="LvarRHPid">	
	<cflocation url="pedimento.cfm?RHPid=#LvarRHPid#">
</cfif>


<cfif isdefined ('form.Cambio')>
	<cfquery name="rsUp" datasource="#session.dsn#">
		update RHPedimentos
			set RHPfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">,
			RHPporc=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.montoPor#">,
			RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">,
		<!---	RHTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.tipoA#">,--->
			RHMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mot#">,
			RHPjustificacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtJust#">,
			RHPfunciones='#form.txtfunciones#',
			RHPestado=10
		where RHPid=#form.RHPid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cflocation url="pedimento.cfm?RHPid=#form.RHPid#">
</cfif>

<cfif isdefined ('form.Nuevo')>
	<cflocation url="pedimento.cfm?btnNuevo=1">
</cfif>

<cfif isdefined ('form.Baja')>
	<cfquery name="rsDel" datasource="#session.dsn#">
		delete from RHPedimentos
		where RHPid=#form.RHPid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cflocation url="pedimento.cfm?btnNuevo=1">
</cfif>

<cfif isdefined ('form.Regresar')>
	<cflocation url="pedimento.cfm">
</cfif>


<cfif isdefined ('form.Aplicar')>	
	<cfquery name="rsUpE" datasource="#session.dsn#">
		update RHPedimentos set RHPestado=20 
		where RHPid=#form.RHPid#
	</cfquery>
	<cflocation url="pedimento.cfm">
</cfif>