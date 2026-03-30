<cfif isdefined("URL.DEID1")>
	<cfparam name="FORM.DEID1" type="string" default="#URL.DEID1#">
</cfif>
<cfif isdefined("URL.RHEEID")>
	<cfparam name="FORM.RHEEID" type="numeric" default="#URL.RHEEID#">
</cfif>
<cfif isdefined("URL.DEID")>
	<cfparam name="FORM.DEID" type="numeric" default="#URL.DEID#">
</cfif>
<cfif isdefined("URL.ACTUALIZAR")>
	<cfparam name="FORM.ACTUALIZAR" type="string" default="#URL.ACTUALIZAR#">
</cfif>
<cfif isdefined("URL.ELIMINAR")>
	<cfparam name="FORM.ELIMINAR" type="string" default="#URL.ELIMINAR#">
</cfif>
<cfif isdefined("URL.HABILITAR")>
	<cfparam name="FORM.HABILITAR" type="string" default="#URL.HABILITAR#">
</cfif>
<cfif isdefined("URL.RHEDtipo")>
	<cfparam name="FORM.RHEDtipo" type="string" default="#URL.RHEDtipo#">
</cfif>
<cfparam name="FORM.DEID1" type="string">
<cfparam name="FORM.RHEEID" type="numeric">
<cfparam name="FORM.DEID" type="numeric">
<cfparam name="FORM.ACTUALIZAR" type="string" default="">
<cfparam name="FORM.RHEDtipo" type="string" default="">
<cfif isdefined("form.AgregarEval")>
	<cfquery name="ABC_valida" datasource="#SESSION.DSN#">
			select 1 
			from RHEvaluadoresDes 
			where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#"> 
			and  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#">
			and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID1#">
	</cfquery>
	<cfif ABC_valida.recordCount EQ 0>
		<cfquery name="ABC_insert" datasource="#SESSION.DSN#">
			insert  into RHEvaluadoresDes 
			(RHEEid, DEid, DEideval, RHEDtipo)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID1#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#FORM.RHEDtipo#">)
		</cfquery>
	<cfelse>
		<cfquery name="ABC_update" datasource="#SESSION.DSN#">
			update RHEvaluadoresDes 
			set RHEDtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#FORM.RHEDtipo#">
			where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#"> 
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#">
			and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID1#">
		</cfquery>
	</cfif>
<cfelseif isdefined("form.btnEliminar.X") or isdefined("FORM.ELIMINAR")>
	<cfquery name="ABC_valida" datasource="#SESSION.DSN#">
		delete from RHEvaluadoresDes
		where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#"> 
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#">
		and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID1#">
	</cfquery> 
<cfelseif isdefined("FORM.HABILITAR")>
	<cfquery name="ABC_update" datasource="#SESSION.DSN#">
		update PortalCuestionarioU 
		set PCUestado = 0
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#">
		and PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#"> 
		and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID1#">					
	</cfquery>
	<cfquery name="ABC_update" datasource="#SESSION.DSN#">
		update RHEvaluadoresDes 
		set Estado = 0
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#">
		and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID1#"> 									
		and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#"> 		  
	</cfquery>	
</cfif>
<cflocation url="registro_evaluacion.cfm?SEL=4&RHEEID=#FORM.RHEEID#&DEID=#FORM.DEID#">