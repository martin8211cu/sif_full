<cfif not isdefined("Session.CursosMant")>
	<cfset Session.CursosMant = StructNew()>
</cfif>
<cfif isdefined("Form.CILcodigo")>
	<cfset StructInsert(Session.CursosMant, "CILcodigo", Form.CILcodigo, true)>
	<!--- Obtener el tipo de duración del ciclo --->
	<cfquery name="rsCicloLectivoSel" datasource="#Session.DSN#">
		select convert(varchar,a.CILcodigo) as CILcodigo, CILnombre, CILtipoCicloDuracion
		from CicloLectivo a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CursosMant.CILcodigo#">
	</cfquery>
	<cfset StructInsert(Session.CursosMant, "CILtipoCicloDuracion", rsCicloLectivoSel.CILtipoCicloDuracion, true)>
<cfelseif not isdefined("Session.CursosMant.CILcodigo") and isdefined("rsCicloLectivo") and rsCicloLectivo.recordCount GT 0>
	<cfset StructInsert(Session.CursosMant, "CILcodigo", rsCicloLectivo.CILcodigo, true)>
	<!--- Obtener el tipo de duración del ciclo --->
	<cfquery name="rsCicloLectivoSel" datasource="#Session.DSN#">
		select convert(varchar,a.CILcodigo) as CILcodigo, CILnombre, CILtipoCicloDuracion
		from CicloLectivo a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CursosMant.CILcodigo#">
	</cfquery>
	<cfset StructInsert(Session.CursosMant, "CILtipoCicloDuracion", rsCicloLectivoSel.CILtipoCicloDuracion, true)>
</cfif>
<cfif isdefined("Form.EScodigo")>
	<cfset StructInsert(Session.CursosMant, "EScodigo", Form.EScodigo, true)>
</cfif>
<cfif isdefined("Form.GAcodigo")>
	<cfset StructInsert(Session.CursosMant, "GAcodigo", Form.GAcodigo, true)>
</cfif>
<cfif isdefined("Form.Scodigo")>
	<cfset StructInsert(Session.CursosMant, "Scodigo", Form.Scodigo, true)>
</cfif>
<cfif isdefined("Form.PLcodigo")>
	<cfset StructInsert(Session.CursosMant, "PLcodigo", Form.PLcodigo, true)>
</cfif>
<cfif isdefined("Form.PEcodigo")>
	<cfset StructInsert(Session.CursosMant, "PEcodigo", Form.PEcodigo, true)>
</cfif>
<cfif isdefined("Form.rdPlan")>
	<cfset StructInsert(Session.CursosMant, "rdPlan", Form.rdPlan, true)>
</cfif>
