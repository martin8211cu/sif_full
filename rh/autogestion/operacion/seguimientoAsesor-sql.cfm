<cfif isdefined ('form.Cambio')>
	<cfquery name="rsUp" datasource="#session.dsn#">
		update RHPedimentos
			set RHPfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">,
			RHPporc=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.montoPor#">,
			RHPcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPcodigo#">,
			RHTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.tipoA#">,
			RHMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mot#">,
			RHPjustificacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtJust#">,
			RHPfunciones='#form.txtfunciones#',
			RHPestado=20,
			RHPasesor=#form.Usucodigo#
		where RHPid=#form.RHPid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>	
	<cflocation url="asignarAsesor.cfm?RHPid=#form.RHPid#">
</cfif>

<cfif isdefined ('form.Nuevo')>
	<cflocation url="pedimento.cfm?btnNuevo=1">
</cfif>

<cfif isdefined ('form.Baja')>
	<cfquery name="rsDel" datasource="#session.dsn#">
		drop from RHPedimentos
		where RHPid=#form.RHPid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cflocation url="pedimento.cfm?RHPid=#form.RHPid#">
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