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
<cfif isdefined("URL.RHEDtipo")>
	<cfparam name="FORM.RHEDtipo" type="string" default="#URL.RHEDtipo#">
</cfif>
<cfparam name="FORM.DEID1" type="string">
<cfparam name="FORM.RHEEID" type="numeric">
<cfparam name="FORM.DEID" type="numeric">
<cfparam name="FORM.ACTUALIZAR" type="string" default="">
<cfparam name="FORM.RHEDtipo" type="string" default="">
<cfquery name="ABC_Insert_RHEvaluadoresDes" datasource="#SESSION.DSN#">
	set nocount on
	<cfif isdefined("form.AgregarEval")>
		if not exists(select 1 
				from RHEvaluadoresDes 
				where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#"> 
				and  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#">
				and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID1#">)
		begin
			insert into RHEvaluadoresDes 
			(RHEEid, DEid, DEideval, RHEDtipo)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID1#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#FORM.RHEDtipo#">)
		end
		else
		begin
			update RHEvaluadoresDes 
			set RHEDtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#FORM.RHEDtipo#">
			where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#"> 
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#">
			and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID1#">
		end
	<cfelseif isdefined("form.btnEliminar.X") or isdefined("FORM.ELIMINAR")>
		delete from RHEvaluadoresDes
		where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#"> 
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#">
		  and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID1#">
	</cfif>
	set nocount off
</cfquery>
<cflocation url="registro_evaluacion.cfm?SEL=4&RHEEID=#FORM.RHEEID#&DEID=#FORM.DEID#">